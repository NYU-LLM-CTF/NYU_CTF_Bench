from pwn import *

p = remote("localhost", 31138)

p.sendline(b"400717")

p.interactive()

