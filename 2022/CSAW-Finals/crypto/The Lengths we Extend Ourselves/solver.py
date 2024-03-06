from pwn import *

host = "crypto.chal.csaw.io"
port = "5004"

server = remote(host, port)

print(server.recvuntil(b"Please enter your answer:")) #1
server.sendline(b"ba65cf5860ff5a095bbb0ad2c64c08f9adabdff77f4e5ef17d96433f9ddd9ff5")
  
print(server.recvline())
print(server.recvline())
print(server.recvline())
print(server.recvline())

server.close()
