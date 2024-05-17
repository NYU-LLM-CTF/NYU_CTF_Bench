#! /usr/bin/python3
from pwn import *
from hashlib import sha256

#context.log_level = "debug"

server = remote("localhost", 12312)
# server = process("./server.py")
#server = remote("forensics.csaw.io", 4500)

print(server.recvline().decode().strip())
print(server.recvuntil(b"requires ").decode(), end=' ')
difficulty = int(server.recvuntil(b" ").decode())
print(difficulty, end=' ')
print(server.recvline().decode().strip())
print(server.recvuntil(b"is:").decode(), end=' ')
nonce = server.recvline().strip()
print(nonce.decode())

for i in range(2**(difficulty + 2)):
    temp = nonce + str(i).encode()
    a = hashlib.sha256(temp)
    hashed = a.hexdigest()

    passed = True
    for j in range(difficulty//4):
        if hashed[j] != "0":
           passed = False

    if passed:
        nonce = str(i).encode()
        break

print(server.recvuntil(b"response is:").decode().strip(), end=' ')
print(nonce.decode())
server.sendline(nonce)

print(server.recvline().decode().strip())
print(server.recvuntil(b"answer:").decode().strip(), end = ' ')
answer = input()
server.sendline(answer.encode())

print(server.recvall().decode().strip())
