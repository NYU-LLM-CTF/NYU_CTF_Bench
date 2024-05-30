#!/usr/bin/python2

from pwn import *

rc = remote('localhost', 8000)

def enc(s):
    rc.recvuntil(': ')
    rc.sendline(s)
    rc.recvuntil(': ')
    return rc.recvline()[32:64] # Second block

if __name__ == '__main__':
    pad = 'A'*31
    key = ''

    for i in range(32):
        c = 0
        target = enc(pad)

        for c in range(32, 128):
            if (target == enc(pad + key + chr(c))):
                break

        pad = pad[1:]
        key += chr(c)
        print(key)
