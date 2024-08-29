from pwn import *

host = "misc.chal.csaw.io"
port = "5012"

server = remote(host, port)

print(server.recvuntil(b"Please enter your answer:")) #1
server.sendline(b"301 Keawe Street")
print(server.recvuntil(b"Please enter your answer:")) #2
server.sendline(b"3DSS-22-0000203")
print(server.recvuntil(b"Please enter your answer:")) #3
server.sendline(b"202207160041807")
print(server.recvuntil(b"Please enter your answer:")) #4
server.sendline(b"Nancy Juvonen")
print(server.recvuntil(b"Please enter your answer:")) #5
server.sendline(b"200 Park Avenue South")
print(server.recvuntil(b"Please enter your answer:")) #6
server.sendline(b"4839348")
print(server.recvuntil(b"Please enter your answer:")) #7
server.sendline(b"23.236.62.147")
print(server.recvuntil(b"Please enter your answer:")) #7
server.sendline(b"PERFECT PRIVACY, LLC")

print(server.recvline())
print(server.recvline())
print(server.recvline())
print(server.recvline())

server.close()
