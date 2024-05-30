from pwn import *
import sys

name = "marine.starcraft"

f = open(name,"wb")

payload = b""
payload += p32(0x17202508)
payload += b"test" + p32(0)
payload += p32(0xEA93014f)
payload += p32(0x455A00E4)
payload += p32(0x55544152)
payload += p32(0x4153004C)
payload += p32(0x00444556)
payload += p32(0x004c4c41)

f.write(payload)
f.close()

f = open(name,"rb")
data = f.read()
f.close()

local = 0

if local:
	r = process("./prophecy")

else:
	r = remote("localhost",8027)

pause()
print(r.recvuntil(">>"))
r.sendline(name)
print(r.recvuntil(">>"))
r.sendline(data)
#stdout
r.interactive()
