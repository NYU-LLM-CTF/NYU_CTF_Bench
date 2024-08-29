#!/usr/bin/env python3

import logging
import socket
import ssl
import sys

log = logging.getLogger(__name__)
log.setLevel(logging.DEBUG)

PORT = 9000
BUFSIZE = 4096


def unwraprecv(sock):
    data = b''
    while len(data) <= 8 or data[:4] != data[-1:-5:-1]:
        rec = sock.recv(BUFSIZE)
        if not rec:
            raise ConnectionError('empty recv')
        data += rec
    return data[4:-4]
def wrapsend(sock, msg):
    sock.send(b'AAAA' + msg + b'AAAA')


def client(sock):
    sock.settimeout(1.0)
    try:
        wrapsend(sock, b'\x41\xca')
        print(unwraprecv(sock))
        sock = ssl.wrap_socket(sock, suppress_ragged_eofs=True)
        print(unwraprecv(sock))
        wrapsend(sock, b'\x0a\xca')
        log.info('session initialized')
        wrapsend(sock, b'\x20\x00\x08\x08\x00\x20\x00\x05admin\x20\x00\x05admin')
        print(unwraprecv(sock))
        wrapsend(sock, b'\x66\xca')
        print(unwraprecv(sock))
        wrapsend(sock, b'\x66\x00\x02\x02\x02\x00\x30\x00\x30\x00\x30\x00')
        print(unwraprecv(sock))
    except BaseException as e:
        raise
    finally:
        sock.close()


if __name__ == '__main__':
    target = 'localhost' if len(sys.argv) < 2 else sys.argv[1]
    targetsock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    targetsock.connect((target, PORT))
    client(targetsock)
