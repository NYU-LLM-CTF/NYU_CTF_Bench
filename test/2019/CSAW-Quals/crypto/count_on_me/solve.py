#!/usr/bin/env python3
from pwn import *
import random

def random_bytes():
    return random.getrandbits(32).to_bytes(16, 'little')

def xor(x, y):
    return bytes([i ^ j for i, j in zip(x, y)])

'''
i = 71790
while True:
    random.seed(i)
    if len(set([random_bytes() for i in range(300)])) < 300:
        print(f'i = {i}')
        break
    i += 1
'''

random.seed(71789)
current = []
for i in range(100):
    for j in range(3):
        x = random_bytes()
        if x in current:
            print(current.index(x))
            print(i * 3 + j)
        current.append(x)

r = remote('localhost', 12312)
r.sendafter('Send me a random seed\n', '71789'.rjust(16, '0'))
r.recvuntil('Encrypted flag:\n')
encs = []
for i in range(100):
    encs.append(r.recvn(49)[:-1])

print(xor(xor(encs[47 // 3][32:], encs[114 // 3][:16]), b'Encrypted Flag: '))

random.seed(72454)
current = []
for i in range(100):
    for j in range(3):
        x = random_bytes()
        if x in current:
            print(current.index(x))
            print(i * 3 + j)
        current.append(x)

r = remote('localhost', 12312)
r.sendafter('Send me a random seed\n', '72454'.rjust(16, '0'))
r.recvuntil('Encrypted flag:\n')
encs = []
for i in range(100):
    encs.append(r.recvn(49)[:-1])

print(xor(xor(encs[48 // 3][:16], encs[106 // 3][16:32]), b'Encrypted Flag: '))