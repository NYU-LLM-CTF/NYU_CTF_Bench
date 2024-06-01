#!/usr/bin/env python3
from pwn import *

conn = remote("localhost", 7890)

payload = "aaaaa-(((((-<<<<<-`````-iiiii"
conn.sendline(payload.encode())

print("Sent: " + payload)
print("Received: " + conn.recvall().decode())
