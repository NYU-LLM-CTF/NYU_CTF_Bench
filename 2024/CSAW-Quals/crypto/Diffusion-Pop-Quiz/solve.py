from pwn import *

server = process(['python3','server.py'])
#server = remote("crypto.csaw.io",5001)

for _ in range(14):
	print(server.recvline())
server.sendline("hello")
print(server.recvline())
print(server.recvline())
server.sendline("no")
print(server.recvline())
server.sendline("Diffusion matters a lot")

for _ in range(11):
	print(server.recvline())
server.sendline("0x16")

for _ in range(25):
	print(server.recvline())
server.sendline("x3+x2*x3+x1*x2")

for _ in range(16):
	print(server.recvline())
server.sendline("x3+x2*x3+x1*x2")
for _ in range(3):
	print(server.recvline())
server.sendline("1+x3+x2+x2*x3+x1*x3+x1*x2")

for _ in range(12):
	print(server.recvline())
server.sendline("x8+x7+x6+x5+x5*x6+x5*x6*x8+x5*x6*x7*x8+x4*x7+x4*x7*x8+x4*x6*x8+x4*x6*x7*x8+x4*x5*x7*x8+x4*x5*x6*x8+x3*x7+x3*x7*x8+x3*x6+x3*x6*x7+x3*x6*x7*x8+x3*x5*x7+x3*x5*x6*x8+x3*x5*x6*x7*x8+x3*x4+x3*x4*x8+x3*x4*x7+x3*x4*x7*x8+x3*x4*x6+x3*x4*x6*x7+x3*x4*x6*x7*x8+x3*x4*x5*x8+x3*x4*x5*x7*x8+x3*x4*x5*x6*x8+x3*x4*x5*x6*x7*x8+x2+x2*x8+x2*x7+x2*x7*x8+x2*x6+x2*x6*x7*x8+x2*x5*x7*x8+x2*x5*x6+x2*x5*x6*x8+x2*x4+x2*x4*x7*x8+x2*x4*x6*x7+x2*x4*x5*x8+x2*x4*x5*x6+x2*x4*x5*x6*x8+x2*x4*x5*x6*x7+x2*x3+x2*x3*x8+x2*x3*x7+x2*x3*x7*x8+x2*x3*x6*x7*x8+x2*x3*x5+x2*x3*x5*x8+x2*x3*x5*x7+x2*x3*x5*x6+x2*x3*x4+x2*x3*x4*x8+x2*x3*x4*x6*x8+x2*x3*x4*x6*x7*x8+x2*x3*x4*x5*x7+x1*x8+x1*x7+x1*x7*x8+x1*x6+x1*x6*x8+x1*x6*x7+x1*x6*x7*x8+x1*x5+x1*x5*x8+x1*x5*x7+x1*x5*x7*x8+x1*x5*x6+x1*x5*x6*x8+x1*x5*x6*x7+x1*x5*x6*x7*x8+x1*x4+x1*x4*x8+x1*x4*x7+x1*x4*x7*x8+x1*x4*x6+x1*x4*x6*x8+x1*x4*x6*x7+x1*x4*x6*x7*x8+x1*x4*x5+x1*x4*x5*x8+x1*x4*x5*x7+x1*x4*x5*x7*x8+x1*x4*x5*x6+x1*x4*x5*x6*x8+x1*x4*x5*x6*x7+x1*x4*x5*x6*x7*x8+x1*x3*x5*x8+x1*x3*x5*x7*x8+x1*x3*x5*x6*x8+x1*x3*x5*x6*x7*x8+x1*x3*x4*x5*x8+x1*x3*x4*x5*x7*x8+x1*x3*x4*x5*x6*x8+x1*x3*x4*x5*x6*x7*x8+x1*x2+x1*x2*x8+x1*x2*x7+x1*x2*x7*x8+x1*x2*x6+x1*x2*x6*x8+x1*x2*x6*x7+x1*x2*x6*x7*x8+x1*x2*x5+x1*x2*x5*x8+x1*x2*x5*x7+x1*x2*x5*x7*x8+x1*x2*x5*x6+x1*x2*x5*x6*x8+x1*x2*x5*x6*x7+x1*x2*x5*x6*x7*x8+x1*x2*x4*x5*x6*x7*x8+x1*x2*x3*x5*x8+x1*x2*x3*x5*x7*x8+x1*x2*x3*x4*x5*x6*x8")
for _ in range(3):
	print(server.recvline())
server.sendline("x1,x2,x3,x4,x5,x6,x7,x8")
for _ in range(3):
	print(server.recvline())
server.sendline("yes")
for _ in range(3):
	print(server.recvline())
server.sendline("x7*x8+x6+x6*x7*x8+x5*x7+x5*x6+x5*x6*x7+x4*x7+x4*x6*x7+x4*x6*x7*x8+x4*x5+x4*x5*x7+x4*x5*x6*x8+x4*x5*x6*x7+x3+x3*x7*x8+x3*x6*x7+x3*x5*x8+x3*x5*x7+x3*x5*x7*x8+x3*x5*x6+x3*x5*x6*x7+x3*x5*x6*x7*x8+x3*x4*x6*x8+x3*x4*x6*x7+x3*x4*x5+x3*x4*x5*x7*x8+x3*x4*x5*x6*x8+x3*x4*x5*x6*x7*x8+x2+x2*x8+x2*x7*x8+x2*x6*x8+x2*x6*x7+x2*x6*x7*x8+x2*x5+x2*x5*x8+x2*x5*x7*x8+x2*x4+x2*x4*x8+x2*x4*x6+x2*x4*x6*x8+x2*x4*x6*x7+x2*x4*x6*x7*x8+x2*x4*x5*x8+x2*x4*x5*x7*x8+x2*x4*x5*x6*x8+x2*x4*x5*x6*x7*x8+x2*x3*x7+x2*x3*x6+x2*x3*x6*x7*x8+x2*x3*x5*x8+x2*x3*x5*x6+x2*x3*x5*x6*x8+x2*x3*x5*x6*x7*x8+x2*x3*x4*x6+x2*x3*x4*x6*x7+x2*x3*x4*x5*x7+x2*x3*x4*x5*x7*x8+x2*x3*x4*x5*x6*x8+x2*x3*x4*x5*x6*x7+x1*x7+x1*x7*x8+x1*x6*x8+x1*x5+x1*x5*x7+x1*x5*x7*x8+x1*x5*x6*x7+x1*x5*x6*x7*x8+x1*x4*x7*x8+x1*x4*x6*x7+x1*x4*x5*x7+x1*x4*x5*x7*x8+x1*x4*x5*x6*x7+x1*x4*x5*x6*x7*x8+x1*x3+x1*x3*x8+x1*x3*x7+x1*x3*x7*x8+x1*x3*x6*x8+x1*x3*x5*x7+x1*x3*x5*x6+x1*x3*x5*x6*x7+x1*x3*x5*x6*x7*x8+x1*x3*x4+x1*x3*x4*x8+x1*x3*x4*x7+x1*x3*x4*x7*x8+x1*x3*x4*x6+x1*x3*x4*x6*x7*x8+x1*x3*x4*x5*x7+x1*x3*x4*x5*x6+x1*x2+x1*x2*x8+x1*x2*x7+x1*x2*x6+x1*x2*x5*x6*x7*x8+x1*x2*x4*x7*x8+x1*x2*x4*x6*x8+x1*x2*x4*x5+x1*x2*x4*x5*x7+x1*x2*x4*x5*x6+x1*x2*x4*x5*x6*x8+x1*x2*x4*x5*x6*x7+x1*x2*x4*x5*x6*x7*x8+x1*x2*x3+x1*x2*x3*x8+x1*x2*x3*x6*x7+x1*x2*x3*x5+x1*x2*x3*x5*x8+x1*x2*x3*x5*x6*x8+x1*x2*x3*x5*x6*x7+x1*x2*x3*x4*x6*x8+x1*x2*x3*x4*x5+x1*x2*x3*x4*x5*x8+x1*x2*x3*x4*x5*x7*x8+x1*x2*x3*x4*x5*x6*x8")
for _ in range(3):
	print(server.recvline())
server.sendline("x1,x2,x3,x4,x5,x6,x7,x8")
for _ in range(3):
	print(server.recvline())
server.sendline("yes")
for _ in range(3):
	print(server.recvline())
server.sendline("x8+x7+x6*x8+x5*x8+x5*x7*x8+x5*x6+x5*x6*x8+x4*x8+x4*x7+x4*x7*x8+x4*x6*x8+x4*x6*x7+x4*x5+x4*x5*x8+x4*x5*x7+x4*x5*x7*x8+x4*x5*x6+x4*x5*x6*x8+x4*x5*x6*x7+x4*x5*x6*x7*x8+x3+x3*x8+x3*x7*x8+x3*x6*x8+x3*x6*x7+x3*x6*x7*x8+x3*x5*x8+x3*x5*x7+x3*x5*x7*x8+x3*x5*x6*x8+x3*x5*x6*x7+x3*x5*x6*x7*x8+x3*x4*x8+x3*x4*x7+x3*x4*x6+x3*x4*x6*x7*x8+x3*x4*x5+x3*x4*x5*x6*x7+x3*x4*x5*x6*x7*x8+x2*x8+x2*x7*x8+x2*x6*x7+x2*x5*x8+x2*x5*x7*x8+x2*x5*x6+x2*x5*x6*x7+x2*x5*x6*x7*x8+x2*x4*x8+x2*x4*x7*x8+x2*x4*x6*x8+x2*x4*x5+x2*x4*x5*x8+x2*x4*x5*x7*x8+x2*x4*x5*x6+x2*x4*x5*x6*x7+x2*x4*x5*x6*x7*x8+x2*x3+x2*x3*x7+x2*x3*x7*x8+x2*x3*x5+x2*x3*x5*x8+x2*x3*x5*x6+x2*x3*x5*x6*x7*x8+x2*x3*x4*x6+x2*x3*x4*x6*x8+x2*x3*x4*x6*x7+x2*x3*x4*x6*x7*x8+x2*x3*x4*x5+x2*x3*x4*x5*x7+x2*x3*x4*x5*x6*x8+x1+x1*x8+x1*x7*x8+x1*x6*x8+x1*x6*x7+x1*x6*x7*x8+x1*x5*x8+x1*x5*x7+x1*x5*x6+x1*x5*x6*x8+x1*x5*x6*x7*x8+x1*x4+x1*x4*x8+x1*x4*x7+x1*x4*x6*x8+x1*x4*x6*x7+x1*x4*x6*x7*x8+x1*x4*x5*x8+x1*x4*x5*x7*x8+x1*x4*x5*x6+x1*x4*x5*x6*x8+x1*x4*x5*x6*x7*x8+x1*x3*x8+x1*x3*x7+x1*x3*x6*x7+x1*x3*x6*x7*x8+x1*x3*x5*x8+x1*x3*x5*x7+x1*x3*x5*x7*x8+x1*x3*x5*x6*x8+x1*x3*x4*x7+x1*x3*x4*x6+x1*x3*x4*x6*x7+x1*x3*x4*x6*x7*x8+x1*x3*x4*x5*x8+x1*x3*x4*x5*x7*x8+x1*x3*x4*x5*x6*x7+x1*x2+x1*x2*x8+x1*x2*x6+x1*x2*x6*x7+x1*x2*x6*x7*x8+x1*x2*x5*x7+x1*x2*x5*x7*x8+x1*x2*x5*x6*x7+x1*x2*x4+x1*x2*x4*x7*x8+x1*x2*x4*x6+x1*x2*x4*x6*x7+x1*x2*x4*x5*x7+x1*x2*x4*x5*x7*x8+x1*x2*x4*x5*x6+x1*x2*x4*x5*x6*x8+x1*x2*x4*x5*x6*x7+x1*x2*x4*x5*x6*x7*x8+x1*x2*x3*x7+x1*x2*x3*x6+x1*x2*x3*x6*x8+x1*x2*x3*x5+x1*x2*x3*x5*x8+x1*x2*x3*x5*x7+x1*x2*x3*x5*x7*x8+x1*x2*x3*x5*x6+x1*x2*x3*x5*x6*x8+x1*x2*x3*x5*x6*x7*x8+x1*x2*x3*x4+x1*x2*x3*x4*x8+x1*x2*x3*x4*x7+x1*x2*x3*x4*x7*x8+x1*x2*x3*x4*x6*x8+x1*x2*x3*x4*x5+x1*x2*x3*x4*x5*x7*x8+x1*x2*x3*x4*x5*x6+x1*x2*x3*x4*x5*x6*x8+x1*x2*x3*x4*x5*x6*x7")
for _ in range(3):
	print(server.recvline())
server.sendline("x1,x2,x3,x4,x5,x6,x7,x8")
for _ in range(3):
	print(server.recvline())
server.sendline("yes")

for _ in range(5):
	print(server.recvline())
server.sendline("no")
for _ in range(3):
	print(server.recvline())
server.sendline("y7")
for _ in range(3):
	print(server.recvline())
server.sendline("x7+x6+x6*x8+x5*x8+x5*x6+x4*x8+x4*x7+x4*x7*x8+x4*x6*x7+x4*x5*x6+x4*x5*x6*x8+x4*x5*x6*x7+x4*x5*x6*x7*x8+x3*x7+x3*x6+x3*x6*x7+x3*x5+x3*x5*x6+x3*x4+x3*x4*x8+x3*x4*x7+x3*x4*x6*x8+x3*x4*x6*x7*x8+x3*x4*x5*x7*x8+x3*x4*x5*x6*x8+x2*x8+x2*x7*x8+x2*x6+x2*x6*x7*x8+x2*x5*x7+x2*x5*x6+x2*x5*x6*x8+x2*x4*x8+x2*x4*x6+x2*x4*x6*x7+x2*x4*x6*x7*x8+x2*x4*x5*x8+x2*x4*x5*x7+x2*x4*x5*x6*x7+x2*x4*x5*x6*x7*x8+x2*x3*x8+x2*x3*x6*x8+x2*x3*x6*x7*x8+x2*x3*x5*x7+x2*x3*x5*x6*x8+x2*x3*x4")
for _ in range(3):
	print(server.recvline())
server.sendline("x1")
for _ in range(3):
	print(server.recvline())
server.sendline("yes")
for _ in range(3):
	print(server.recvline())
server.sendline("yes")

for _ in range(6):
	print(server.recvline())
server.close()