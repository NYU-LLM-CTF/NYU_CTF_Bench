#!/usr/bin/env python
from z3 import *
from pwn import *
context.log_level = "DEBUG"

#p = process("./algebra.py")

p = remote("misc.chal.csaw.io", 9002)
count = 0
p.recvuntil('**********************************************************************************\n')
while(1):
    equ = p.recvline()
    p.recvuntil("?:") #eat interstitial
    
    e = equ.split(" = ")

    s = Solver()
    X = Real("X")
    s.add(eval(e[0])== int(e[1].strip()))
    print count
    print s.check()
    print(s.model())
    ans = s.model()[X]

    anstr = ans.as_string()
    if "/" in anstr:
        anstr = str(eval(anstr + ".0"))
    
    p.sendline(anstr)
    p.recvline()
    count += 1
