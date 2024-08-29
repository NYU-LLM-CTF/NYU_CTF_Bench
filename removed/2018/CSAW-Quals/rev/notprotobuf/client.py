#!/usr/bin/env python3

import logging
import pickle
import random
import socket
import ssl
import sys
import threading
from os import environ

from library import CREDS, Message
from library import MessageType as mt

logging.basicConfig()
log = logging.getLogger(__name__)
log.setLevel(logging.DEBUG)

PORT = int(environ.get('PORT', 51966))


def client(sock):
    sock.settimeout(10)
    try:
        Message(mt.HELLO).send(sock)
        Message.recv(sock, mt.SUCCESS)

        sock = ssl.wrap_socket(sock, suppress_ragged_eofs=True)
        res = Message.recv(sock, mt.HELLO)
        Message(mt.SUCCESS).send(sock)
        log.info('session initialized')

        Message(mt.LOGIN, random.choice(CREDS)).send(sock)
        Message.recv(sock, mt.SUCCESS)

        with open('goodpixels.pickle', 'rb') as f:
            pixels = pickle.load(f)
        for _ in range(10):
            pixel = random.choice(list(pixels))
            Message(mt.SETPIXEL, [pixel, pixels[pixel]]).send(sock)
            res = Message.recv(sock, mt.PIXEL)

        Message(mt.GOODBYE).send(sock)
        log.debug('sent goodbye')

    except BaseException as e:
        raise
    finally:
        log.info('closing connection')
        sock.close()


if __name__ == '__main__':
    myserver = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    myserver.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    myserver.bind(('0.0.0.0', PORT))
    myserver.listen(2)
    log.debug(f'LISTENER ready on port {PORT}')

    while True:
        targetsock, addr = myserver.accept()
        log.debug(f'connect from {addr}')
        threading.Thread(target=client, args=(targetsock,)).start()
