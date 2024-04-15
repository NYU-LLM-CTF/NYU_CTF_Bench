from pwn import *

server = remote("misc.chal.csaw.io",5015)

print(server.recvuntil(b"What is the answer?\r\n")) #1
server.sendline(b"5P3C7r3-1MP3r1UM")

print(server.recvuntil(b"What is the answer?\r\n")) #2
server.sendline(b"Singapore")

print(server.recvuntil(b"What is the answer?\r\n")) #3a
server.sendline(b"Spectre")

print(server.recvuntil(b"What is the answer?\r\n")) #3b
server.sendline(b"S-1-5-21-4228526091-1870561526-3973218081-1001")

print(server.recvuntil(b"What is the answer?\r\n")) #3c
server.sendline(b"09:01:28 11/01/2021")

print(server.recvuntil(b"What is the answer?\r\n")) #3d
server.sendline(b"Administrator")

print(server.recvuntil(b"What is the answer?\r\n")) #4a
server.sendline(b"3v1L_Dr1v3")

print(server.recvuntil(b"What is the answer?\r\n")) #4b
server.sendline(b"E")

print(server.recvuntil(b"What is the answer?\r\n")) #4c
server.sendline(b"04016cd7fe9bdb2e12fdc62886a111831a8be58c0143f781b2179f053e9682a")

print(server.recvuntil(b"What is the answer?\r\n")) #4d
server.sendline(b"04:36:59 10/31/2021")

print(server.recvuntil(b"What is the answer?\r\n")) #4e
server.sendline(b"15:49:01 11/01/2021")

print(server.recvuntil(b"What is the answer?\r\n")) #4f
server.sendline(b"15:49:13 11/01/2021")

print(server.recvuntil(b"What is the answer?\r\n")) #4g
server.sendline(b"d53e38d0-36db-11ec-ae51-080027ec0de9")

print(server.recvuntil(b"What is the answer?\r\n")) #5a
server.sendline(b"VK7JG-NPHTM-C97JM-9MPGT-3V66T")

print(server.recvuntil(b"What is the answer?\r\n")) #5b
server.sendline(b"Windows 10 Pro")

print(server.recvuntil(b"What is the answer?\r\n")) #5c
server.sendline(b"21H1")

print(server.recvuntil(b"What is the answer?\r\n")) #5d
server.sendline(b"Spectre")

print(server.recvuntil(b"What is the answer?\r\n")) #5e
server.sendline(b"16:02:09 10/26/2021")

print(server.recvline())
print(server.recvline())

server.close()
