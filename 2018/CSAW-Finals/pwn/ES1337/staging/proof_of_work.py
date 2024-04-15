#!/usr/bin/env python2
from pwn import *
import struct
from hashlib import sha256

def checkPOW(chall, solution, hardness):
    h = sha256(chall + struct.pack('<Q', solution)).hexdigest()
    return int(h, 16) < 2**256 / hardness

def solvePOW(task):
    hardness = 2**24

    print 'Solving POW for',task
    i = 0
    while True:
        if i % 1000000 == 0: print('Progress: %d' % i)
        if checkPOW(task, i, hardness):
            return i
        i += 1

if __name__ == '__main__':
    p = remote('<server ip here>',1337)

    data = p.readuntil('(hex encoded):')
    print data

    chal = data.split('sha256(',1)[1].split('.',1)[0]

    sol = solvePOW(chal)
    sol = struct.pack('<Q',sol).encode('hex')

    print 'Found sol',sol
    p.sendline(sol)

    p.interactive()
