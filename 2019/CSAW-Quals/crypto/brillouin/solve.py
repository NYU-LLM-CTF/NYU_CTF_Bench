#!/usr/bin/env python3
from pwn import *
from base64 import b64decode, b64encode
from bls.scheme import *
from bplib.bp import G1Elem, G2Elem

r = remote('localhost', 12312)

params = setup()

publics = []
r.recvlines(3)
publics.append(G2Elem.from_bytes(b64decode(r.recvline()), params[0]))
r.recvline()
publics.append(G2Elem.from_bytes(b64decode(r.recvline()), params[0]))
r.recvline()
publics.append(G2Elem.from_bytes(b64decode(r.recvline()), params[0]))

r.recvline()
r.sendline('3')
r.recvline()
r.sendline('this stuff')
r.recvline()
s = G1Elem.from_bytes(b64decode(r.recvline()), params[0])

r.recvline()
r.sendline('4')
r.recvline()

r.recvline()
r.sendline(b64encode(s.export()))
r.recvline()
r.sendline(b64encode(publics[2].export()))

r.recvline()
r.sendline(b64encode((2 * s).export()))
r.recvline()
r.sendline(b64encode(publics[1].export()))

l2 = [lagrange_basis(2, params[1], i, 0) for i in range(1,2+1)]
l3 = [lagrange_basis(3, params[1], i, 0) for i in range(1,3+1)]
r.recvline()
r.sendline(b64encode(((
    (l2[0] * publics[2] + l2[1] * 2 * publics[2]) -
    (l3[0] * publics[2] + l3[1] * publics[1])
)).export()))

r.interactive()