from math import log10
from pwn import *
import sys

sys.set_int_max_str_digits(1000000)

def solve(b):
    return (b-4)*b**(b-1)+2*(b**(b-2))+b**(b-3)+b**3

#p = process("chall.py")
p=remote("describeme",21200)

buf = p.recvuntil(b">")[:-1].strip()

bae = int(buf.split(b" ")[-1].strip())

print(bae)
sol = solve(bae)
print("Digits in sol: ", log10(sol)+1)
p.sendline(str(sol).encode())

print(p.recvall().decode())
