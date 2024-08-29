#!/usr/bin/env python3
from pwn import *
from math import gcd
from functools import reduce
from Crypto.Util.number import *

def s2n(s):
    return bytes_to_long(bytearray(s, 'latin-1'))

e = 0x10001

r = remote('localhost', 12312)
ns = []
for i in [2, 3, 5]:
    r.recvlines(8)
    r.sendline('4')
    r.sendafter('input the data:', i.to_bytes(1, 'little'))
    ns.append(i ** e - int(r.recvline(), 16))
n = reduce(gcd, ns)
print(f'n = {n}')

r.recvlines(8)
r.sendline('1')
c = int(r.recvline(), 16)
print(f'c = {c}')

r.recvlines(8)
r.sendline('3')
test = int(r.recvline(), 16)
for i in range(1000):
    fake = s2n('fake_flag{%s}' % (('%X' % i).rjust(32, '0')))
    p = gcd(n, fake ** e - test)
    if n > p > 10000:
        print(f'p = {p}')
        q = n // p
        r = (p - 1) * (q - 1)
        d = inverse(e, r)
        m = pow(c, d, n)
        print(long_to_bytes(m))
        break