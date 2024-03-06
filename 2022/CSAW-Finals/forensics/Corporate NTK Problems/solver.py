from pwn import *

host = "misc.chal.csaw.io"
port = "5030"

server = remote(host, port)

print(server.recvuntil(b"Please enter your answer:")) #1
server.sendline(b"BIGCORPLT978")
print(server.recvuntil(b"Please enter your answer:")) #2
server.sendline(b"John Smith")
print(server.recvuntil(b"Please enter your answer:")) #3
server.sendline(b"Pacific Standard Time")
print(server.recvuntil(b"Please enter your answer:")) #4
server.sendline(b"2022-10-01 08:36:47")
print(server.recvuntil(b"Please enter your answer:")) #5
server.sendline(b"Yes")
print(server.recvuntil(b"Please enter your answer:")) #6
server.sendline(b"b383b191dd43beb620cd1e8adf8e6f8032842f9f935c492e45cd5f2f9934bba1")
print(server.recvuntil(b"Please enter your answer:")) #7
server.sendline(b"6b32444e3ec51e9ddb6e25695a006e4b51253967e7f124414ed0c7e1f86fa9b2")
print(server.recvline())
print(server.recvuntil(b"Please enter your answer:")) #8
server.sendline(b"none")
print(server.recvuntil(b"Please enter your answer:")) #9
server.sendline(b"aa773fbd9bb1ce1b9aabc98e6a6f7f7391999fdfdf422b9ee583da7de46b38a7")
print(server.recvuntil(b"Please enter your answer:")) #10
server.sendline(b"2c5d0c6611016b35e85ee0944f21198b3e3f616da077faf3849d673eefbb6938")
print(server.recvuntil(b"Please enter your answer:")) #11
server.sendline(b"none")
print(server.recvuntil(b"Please enter your answer:")) #12
server.sendline(b"0ae25651d1a1ecb5facd059a81c764b051e7280cacc02ad62075957b1aaad997")
print(server.recvuntil(b"Please enter your answer:")) #13
server.sendline(b"none")

print(server.recvline())
print(server.recvline())
print(server.recvline())
print(server.recvline())

server.close()
