from pwn import *
context.log_level= "debug"
flag = []

#p = process("./chal.py")
p = remote("localhost", 3000)
x = [0]*30
for i in x:
    p.sendlineafter("Enter your input: ", str(i))
print(p.recvuntil(b"Your result is:\r\n"))
b = int(p.recvline())

print("b: ", b)
for i in range(30):
    x = [0]*30
    x[i] = 1
    #p = process("chal.py")
    p = remote("localhost", 3000)
    for i in x:
        p.sendlineafter("Enter your input: ", str(i))
    p.recvuntil(b"Your result is:\r\n")
    flag.append(int(p.recvline())-b)
    print(flag)
    p.close()
flag.append(b)
flag = [chr(i) for i in flag]
flag = "".join(flag)
print(flag)
