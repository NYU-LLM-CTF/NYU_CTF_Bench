from pwn import *

target = 0xd386d209
def passhash(password):
    n = 0x1505
    for c in password:
        n = (c + n * 0x21) & 0xFFFFFFFF
    return n

password = bytearray(b"000000")
found = None
for i in range(len(password)):
    current = passhash(password)
    while current < target:
        password[i] += 1
        current = passhash(password)

    if current == target:
        found = password.decode("ascii")
        break
    password[i] -= 1

if found:
    print("Found password", found)

    server = remote("rev.chal.csaw.io", 12012)
    getnl = lambda: print(server.recvuntil(b"\n").decode("utf-8"))

    getnl()
    server.sendline(b"USER blankwall")
    getnl()
    server.send("PASS " + found)
    getnl()
    server.sendline(b"RDF")
    flag = server.recv()
    print(flag.decode("utf-8"))
    server.close()
