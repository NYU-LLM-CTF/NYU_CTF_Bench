#!/usr/bin/env python3

import logging
import pickle
import random
import socket
import ssl
import struct
import sys
import threading
from enum import Enum
from os import environ
from time import sleep

from sqlalchemy import create_engine
from sqlalchemy.orm import scoped_session, sessionmaker
from sqlalchemy.pool import NullPool

from library import CERTFILE, CREDS, KEYFILE, Message
from library import MessageType as mt
from library import Pixel

logging.basicConfig()
log = logging.getLogger(__name__)
log.setLevel(logging.DEBUG)
# log.addHandler(logging.FileHandler('server.log'))

PROD = environ.get('PROD', False)
PORT = int(environ.get('PORT', 51966))
if PROD:
    FLAG = environ['FLAG']
    CREDS = (CREDS[0],)  # Just admin:admin


def server(sock, Session):
    session = Session()
    sock.settimeout(2)
    try:
        Message.recv(sock, mt.HELLO)
        Message(mt.SUCCESS).send(sock)

        sock = ssl.wrap_socket(
            sock,
            server_side=True,
            suppress_ragged_eofs=True,
            certfile=CERTFILE,
            keyfile=KEYFILE,
        )
        log.debug('started ssl')
        Message(mt.HELLO).send(sock)
        res = Message.recv(sock, mt.SUCCESS)
        log.info(f'session initialized')

        requested_flag = False
        logged_in = False
        with open('goodpixels.pickle', 'rb') as f:
            pixels = pickle.load(f)
        pixel_test = list()
        for _ in range(100):
            res = Message.recv(sock)
            if res.type == mt.ERROR:
                return
            elif res.type == mt.FLAG:
                if PROD:
                    if logged_in:
                        if pixel_test:
                            log.debug(
                                f'testing {res.contents} against {pixel_test[1]}'
                            )
                            if res.contents == pixel_test[1]:
                                Message(mt.FLAG, FLAG).send(sock)
                            else:
                                Message(mt.ERROR, 'Confirmation failed').send(
                                    sock
                                )
                                raise Exception('flag pixel error')
                        else:
                            pixel_test = [
                                list(x)
                                for x in random.choice(
                                    tuple(pixels.items())
                                )
                            ]
                            log.info(f'testing {pixel_test}')
                            Message(
                                mt.FLAG,
                                f'Flag request acknowledged. Please resend message with the value at the location: {pixel_test[0]}',
                            ).send(sock)
                    else:
                        Message(mt.ERROR, 'not logged in').send(sock)
                        raise Exception('flag auth error')
                else:
                    Message(
                        mt.ERROR, 'functionality not available in test server'
                    ).send(sock)
            elif res.type == mt.GETPIXEL:
                p = (
                    session.query(Pixel)
                    .filter_by(x=res.contents[0], y=res.contents[1])
                    .one()
                )
                Message(mt.PIXEL, (p.r, p.g, p.b)).send(sock)
                session.close()
            elif res.type == mt.GOODBYE:
                return
            elif res.type == mt.HELLO:
                Message(mt.SUCCESS).send(sock)
            elif res.type == mt.LOGIN:
                log.debug(f'log in with creds {res.contents}')
                if res.contents in CREDS:
                    logged_in = True
                    Message(mt.SUCCESS).send(sock)
                else:
                    logged_in = False
                    Message(mt.ERROR, 'invalid credentials').send(sock)
                    if PROD:
                        raise Exception('failed auth')
            elif res.type == mt.PIXEL:
                Message(mt.ERROR, 'what do you want me to do with this?').send(
                    sock
                )
            elif res.type == mt.SETPIXEL:
                sleep(.1)
                p = (
                    session.query(Pixel)
                    .filter_by(x=res.contents[0][0], y=res.contents[0][1])
                    .one()
                )
                p.r = res.contents[1][0]
                p.g = res.contents[1][1]
                p.b = res.contents[1][2]
                session.commit()
                log.debug(f'pixel set for {p.x}, {p.y}')
                Message(mt.PIXEL, (p.r, p.g, p.b)).send(sock)
                session.close()
            elif res.type == mt.SUCCESS:
                raise Exception('got unexpected SUCCESS message')
            else:
                Message(mt.ERROR, f'Unknown Message type {res.type}').send(
                    sock
                )
        else:
            log.info('Received 100 packets')

    except BaseException as e:
        log.error(f'caught error: {e}')
        raise
    finally:
        log.debug(f'closing connection')
        sock.close()
        session.close()


if __name__ == '__main__':
    engine = create_engine('sqlite:///pixels.db', poolclass=NullPool)
    Session = scoped_session(sessionmaker(bind=engine))

    myserver = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    myserver.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    myserver.bind(('0.0.0.0', PORT))
    myserver.listen(2)
    log.debug(f'LISTENER ready on port {PORT}')

    while True:
        client, addr = myserver.accept()
        log.debug(f'connect from {addr}')
        threading.Thread(target=server, args=(client, Session)).start()
