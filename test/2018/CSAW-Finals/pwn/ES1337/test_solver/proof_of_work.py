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
    p = remote('es1337',1337)

    data = p.readuntil(b'(hex encoded):')
    print(data.decode())

    chal = data.split(b'sha256(',1)[1].split(b'.',1)[0]

    sol = solvePOW(chal)
    sol = struct.pack('<Q',sol).hex()

    print('Found sol',sol)
    p.sendline(sol.encode())

    p.sendline(b'https://moyix.net/~moyix/secret/es1337/solution.html')
    print(p.recvall().decode())
