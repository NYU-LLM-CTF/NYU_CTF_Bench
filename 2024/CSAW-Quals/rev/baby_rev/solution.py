#!/usr/bin/env python3

from pwn import *
import base64

context.log_level='debug'
p = process("./baby_rev")

p.recvuntil("> ".encode())

flag ='Y3Nhd2N0ZntOM3Yzcl9wcjA3M2M3X3MzbnMxNzF2M18xbmYwcm00NzEwbl91czFuZ19qdXM3XzNuYzBkMW5nIV8jM25jMGQxbmdfMXNfbjB0XzNuY3J5cDcxMG4hfQ=='

p.sendline(flag.encode())
p.recvall()

print(f"\n\n{base64.b64decode(flag).decode()}\n\n")