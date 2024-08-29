from pwn import *

host = "localhost"
port = "8085"

server = remote(host, port)

print(server.recvuntil(b"Please enter your answer:") #1
server.sendline(b"08/2022")
print(server.recvuntil(b"Please enter your answer:") #2
server.sendline(b"spyduhman")
print(server.recvuntil(b"Please enter your answer:") #3
server.sendline(b"log.txt")
print(server.recvuntil(b"Please enter your answer:") #4
server.sendline(b"canada")
print(server.recvuntil(b"Please enter your answer:") #5
server.sendline(b"TDOMCATTTOR")
print(server.recvuntil(b"Please enter your answer:") #6
server.sendline(b"copyright infringement")

print(server.recvline())
print(server.recvline())

server.close()
