#!/usr/bin/env python3

import logging
import pickle
import socket
import ssl
import sys
from ast import literal_eval

from library import CREDS, Message
from library import MessageType as mt

logging.basicConfig()
log = logging.getLogger(__name__)
log.setLevel(logging.DEBUG)

PORT = 9000


def client(sock):
    sock.settimeout(1.0)
    try:
        Message(mt.HELLO).send(sock)
        Message.recv(sock, mt.SUCCESS)

        sock = ssl.wrap_socket(sock, suppress_ragged_eofs=True)
        res = Message.recv(sock, mt.HELLO)
        Message(mt.SUCCESS).send(sock)
        log.info('session initialized')

        Message(mt.LOGIN, CREDS[0]).send(sock)
        Message.recv(sock, mt.SUCCESS)

        with open('goodpixels.pickle', 'rb') as f:
            pixels = pickle.load(f)
        Message(mt.FLAG).send(sock)
        res = Message.recv(sock, mt.FLAG).contents
        need_pixels = literal_eval(res[res.find('[') :])
        log.info(
            f'sending {pixels[tuple(need_pixels)]} to confirm {need_pixels}'
        )
        Message(mt.FLAG, pixels[tuple(need_pixels)]).send(
            sock
        )
        log.info(Message.recv(sock, mt.FLAG).contents)

        Message(mt.GOODBYE).send(sock)

    except BaseException as e:
        raise
    finally:
        sock.close()


if __name__ == '__main__':
    target = 'localhost' if len(sys.argv) < 2 else sys.argv[1]
    targetsock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    targetsock.connect((target, PORT))
    client(targetsock)
