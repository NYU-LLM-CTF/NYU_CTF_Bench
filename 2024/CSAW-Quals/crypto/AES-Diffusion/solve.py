from pwn import *

server = process(['python3','server.py'])
#server = remote("crypto.csaw.io",5002)

for _ in range(30):
	print(server.recvline())
server.sendline("[['x0', 'x4', 'x8', 'x12'], ['x5', 'x9', 'x13', 'x1'], ['x10', 'x14', 'x2', 'x6'], ['x15', 'x3', 'x7', 'x11']]")
for _ in range(3):
	print(server.recvline())
server.sendline("[['2*x0 + 3*x5 + 1*x10 + 1*x15', '2*x4 + 3*x9 + 1*x14 + 1*x3', '2*x8 + 3*x13 + 1*x2 + 1*x7', '2*x12 + 3*x1 + 1*x6 + 1*x11'], ['1*x0 + 2*x5 + 3*x10 + 1*x15', '1*x4 + 2*x9 + 3*x14 + 1*x3', '1*x8 + 2*x13 + 3*x2 + 1*x7', '1*x12 + 2*x1 + 3*x6 + 1*x11'], ['1*x0 + 1*x5 + 2*x10 + 3*x15', '1*x4 + 1*x9 + 2*x14 + 3*x3', '1*x8 + 1*x13 + 2*x2 + 3*x7', '1*x12 + 1*x1 + 2*x6 + 3*x11'], ['3*x0 + 1*x5 + 1*x10 + 2*x15', '3*x4 + 1*x9 + 1*x14 + 2*x3', '3*x8 + 1*x13 + 1*x2 + 2*x7', '3*x12 + 1*x1 + 1*x6 + 2*x11']]")
for _ in range(3):
	print(server.recvline())
server.sendline("x0,x5,x10,x15")
for _ in range(3):
	print(server.recvline())
server.sendline("x2,x7,x8,x13")
for _ in range(3):
	print(server.recvline())
server.sendline("no")
for _ in range(3):
	print(server.recvline())
server.sendline("12")
for _ in range(5):
	print(server.recvline())
server.sendline("x0:1,x5:1,x10:1,x15:1")
for _ in range(3):
	print(server.recvline())
server.sendline("x0:0,x1:0,x2:0,x3:0,x4:0,x5:0,x6:0,x7:0,x8:0,x9:0,x10:0,x11:0,x12:0,x13:0,x14:0,x15:0")
for _ in range(9):
	print(server.recvline())
server.sendline("x0")
for _ in range(9):
	print(server.recvline())
server.sendline("(2*(2*x0 + 3*x1 + 1*x2 + 1*x3) + 3*(1*x0 + 2*x1 + 3*x2 + 1*x3) + 1*(1*x0 + 1*x1 + 2*x2 + 3*x3) + 1*(3*x0 + 1*x1 + 1*x2 + 2*x3))")
for _ in range(3):
	print(server.recvline())
server.sendline("no")

for _ in range(5):
	print(server.recvline())
server.close()