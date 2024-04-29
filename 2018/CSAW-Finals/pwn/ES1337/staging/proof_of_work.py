#!/usr/bin/env python3

from pwn import *
import struct
from hashlib import sha256

def checkPOW(chall, solution, hardness):
    h = sha256(chall + struct.pack('<Q', solution)).hexdigest()
    return int(h, 16) < 2**256 / hardness

def solvePOW(task):
    hardness = 2**24

    print('Solving POW for',task)
    i = 0
    while True:
        if i % 1000000 == 0: print('Progress: %d' % i)
        if checkPOW(task, i, hardness):
            return i
        i += 1

if __name__ == '__main__':
    import sys
    if len(sys.argv) < 2:
        print(f'Usage: {sys.argv[0]} <URL> [host [port]]')
        sys.exit(1)
    url = sys.argv[1]
    if len(sys.argv) > 2:
        host = sys.argv[2]
    else:
        host = 'es1337'
    if len(sys.argv) > 3:
        port = int(sys.argv[3])
    else:
        port = 1337
    p = remote(host, port)

    data = p.readuntil(b'(hex encoded):').decode()
    chal = data.split('sha256(',1)[1].split('.',1)[0]

    sol = solvePOW(chal.encode())
    sol = struct.pack('<Q',sol).hex()

    print('Found sol',sol)
    p.sendline(sol.encode())
    p.sendline(url.encode())
    print(p.recvall().decode())
