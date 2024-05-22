#!/usr/bin/env python3
from pwn import *
from supercurve import SuperCurve, curve

r = remote('localhost', 12312)

r.recvlines(4)
public = eval(r.recvline().partition(b'Public key: ')[2])
r.recvline()

for i in range(7919):
    if curve.mult(i, curve.g) == public:
        r.sendline(str(i))
        break

r.interactive()