#!/usr/bin/env python
from z3 import *
from pwn import *#
context.log_level = "DEBUG"

#p = process("./algebra.py")

for i in range(1,10):
    p = remote("misc.chal.csaw.io", 4324)
    #p = remote("localhost", 4324)
    count = 0
    p.recvuntil('**********************************************************************************\n')
    while(1):
        equ = p.recvline()
        print(equ)
        p.recvuntil("?:") #eat interstitial
    
        e = equ.split(b" = ")

        s = Solver()
        X = Real("X")
        s.add(eval(e[0])== int(e[1].strip()))
        print (count)
        print (s.check())
        print(s.model())
        ans = s.model()[X]

        try:
            anstr = ans.as_string()
            if "/" in anstr:
                print(anstr)
                anstr = str(eval(anstr + ".0"))
        except:
            pass
    
        p.sendline(anstr)
        p.recvline()
        count += 1
    p.sendline(b"cat flag.txt\n")
    p.recvuntil("}")
    p.close()


exit(0)
