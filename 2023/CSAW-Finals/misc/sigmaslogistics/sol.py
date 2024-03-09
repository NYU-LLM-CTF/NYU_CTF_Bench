from pwn import *
from math import log
context.log_level= "info"
flag = []

def model(x):
    #p = process("./chal.py")
    p = remote("mandf.csaw.io", 3000)
    #p.interactive()
    for i in x:
        p.sendlineafter("Enter your input: ", str(i))
    #p.interactive()
    p.recvuntil(b"Your result is:")
    p.recvline()
    return float(p.recvline())

x = [0]*30
b = model(x)
b = round(log((1-b)/b)) * -1
print(b)


for i in range(30):
    x = [0]*30
    x[i] = 1
    y = model(x)

    w = -b-log((1-y)/y)

    flag.append(int(w*-1))

flag = [chr(i) for i in flag]
flag = "".join(flag)
print(flag)
