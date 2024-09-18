#! /usr/bin/python

from pwn import *


if __name__=="__main__":
    p  = remote('rev.chal.csaw.io', 8000)
    print(p.readuntil(")\n"))
    p.write(str.encode("0x00") + b"\n")
    print(p.readuntil(")\n"))
    p.write(str.encode("0x00") + b"\n")
    print(p.readuntil(")\n"))
    p.write(str.encode("0x0000") + b"\n")
    print(p.readuntil(")\n"))
    p.write(str.encode("0x0e74") + b"\n")
    print(p.readuntil(")\n"))
    p.write(str.encode("0x0e61") + b"\n")
    print(p.readuntil("}\n"))
   
