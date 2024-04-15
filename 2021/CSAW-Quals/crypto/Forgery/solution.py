from random import randint
from Crypto.Util.number import long_to_bytes, bytes_to_long
from pwn import *

server = remote("crypto.chal.csaw.io",5006)

public_key = server.recvline().split()
print(public_key)
p = int(public_key[4])
g = int(public_key[5])
y = int(public_key[6])
MASK = (2**p.bit_length() - 1)

e = randint(1, p-1)
r = y*pow(g,e,p) % p
s = -r % (p - 1)
m = (e*s) % (p-1)
m += (bytes_to_long(b'both') << 1200)
M = hex(m)[2:]

print(f'M: {M}')
print(f'r: {r}')
print(f's: {s}')

print(server.recvline())
print(server.recvline())
server.sendline(M)
print(server.recvline())
server.sendline(str(r))
print(server.recvline())
server.sendline(str(s))

print(server.recvline())
print(server.recvline())
print(server.recvline())
print(server.recvline())
