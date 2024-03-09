section .text

global _main

exit:
    xor rdi, rdi
    xor rax, rax
    mov al, 60
    syscall

write:
    xor rax, rax
    inc al
    mov edi, 1
    mov rsi, rsp
    add rsi, 8
    syscall
    ret

read:
    xor rax, rax
    xor rdi, rdi
    mov rsi, rcx
    mov edx, 0x300
    syscall
    ret

fail:
    xor rax, rax
    push rax
    mov eax, 0x2e2e2e74
    push rax
    mov rax, 0x636572726f636e49
    push rax

    mov edx, 16
    call write
    call exit

success:
    push rbp
    mov rbp, rsp
    xor rax,rax
    push rax
    mov rax, 0x2174636572726f43
    push rax

    mov edx, 16
    call write
    mov rsp, rbp
    pop rbp
    ret

_main:
    push rbp
    mov rbp, rsp
    sub rsp, 0x70

    mov rax, 0x0a3e64
    push rax
    mov rax, 0x726f777373617020
    push rax
    mov rax, 0x656874207265746e
    push rax
    mov rax, 0x6520657361656c50
    push rax

    mov edx, 34
    call write

    pop rax
    pop rax
    pop rax
    pop rax

    mov rcx, rbp
    sub rcx, 0x70
    call read
    
    mov rcx, rbp
    sub rcx, 0x70
    xor rdx, rdx
    dec rax
    mov [rcx+rax], rdx

    ; check
    mov rax, 0x56
    mov rbx, [rsi+0]
    and rbx, 0xFF
    xor rax, rbx
    cmp rax, 0x35
    jne fail
    

    mov rax, 0x2b
    mov rbx, [rsi+1]
    and rbx, 0xFF
    xor rax, rbx
    cmp rax, 0x58
    jne fail
    

    mov rax, 0x97
    mov rbx, [rsi+2]
    and rbx, 0xFF
    xor rax, rbx
    cmp rax, 0xf6
    jne fail
    

    mov rax, 0x12
    mov rbx, [rsi+3]
    and rbx, 0xFF
    xor rax, rbx
    cmp rax, 0x65
    jne fail
    

    mov rax, 0x69
    mov rbx, [rsi+4]
    and rbx, 0xFF
    xor rax, rbx
    cmp rax, 0xa
    jne fail
    

    mov rax, 0x7c
    mov rbx, [rsi+5]
    and rbx, 0xFF
    xor rax, rbx
    cmp rax, 0x8
    jne fail
    

    mov rax, 0x84
    mov rbx, [rsi+6]
    and rbx, 0xFF
    xor rax, rbx
    cmp rax, 0xe2
    jne fail
    

    mov rax, 0xc6
    mov rbx, [rsi+7]
    and rbx, 0xFF
    xor rax, rbx
    cmp rax, 0xbd
    jne fail
    

    mov rax, 0xad
    mov rbx, [rsi+8]
    and rbx, 0xFF
    xor rax, rbx
    cmp rax, 0xe8
    jne fail
    

    mov rax, 0x71
    mov rbx, [rsi+9]
    and rbx, 0xFF
    xor rax, rbx
    cmp rax, 0x40
    jne fail
    

    mov rax, 0xf2
    mov rbx, [rsi+10]
    and rbx, 0xFF
    xor rax, rbx
    cmp rax, 0xc7
    jne fail
    

    mov rax, 0xfb
    mov rbx, [rsi+11]
    and rbx, 0xFF
    xor rax, rbx
    cmp rax, 0xa4
    jne fail
    

    mov rax, 0xe9
    mov rbx, [rsi+12]
    and rbx, 0xFF
    xor rax, rbx
    cmp rax, 0xac
    jne fail
    

    mov rax, 0x2f
    mov rbx, [rsi+13]
    and rbx, 0xFF
    xor rax, rbx
    cmp rax, 0x1d
    jne fail
    

    mov rax, 0xf1
    mov rbx, [rsi+14]
    and rbx, 0xFF
    xor rax, rbx
    cmp rax, 0xc1
    jne fail
    

    mov rax, 0xe4
    mov rbx, [rsi+15]
    and rbx, 0xFF
    xor rax, rbx
    cmp rax, 0xbb
    jne fail
    

    mov rax, 0x66
    mov rbx, [rsi+16]
    and rbx, 0xFF
    xor rax, rbx
    cmp rax, 0x1e
    jne fail
    

    mov rax, 0x6
    mov rbx, [rsi+17]
    and rbx, 0xFF
    xor rax, rbx
    cmp rax, 0x70
    jne fail
    

    mov rax, 0xc9
    mov rbx, [rsi+18]
    and rbx, 0xFF
    xor rax, rbx
    cmp rax, 0xff
    jne fail
    

    mov rax, 0xce
    mov rbx, [rsi+19]
    and rbx, 0xFF
    xor rax, rbx
    cmp rax, 0x91
    jne fail
    

    mov rax, 0x94
    mov rbx, [rsi+20]
    and rbx, 0xFF
    xor rax, rbx
    cmp rax, 0xec
    jne fail
    

    mov rax, 0x5d
    mov rbx, [rsi+21]
    and rbx, 0xFF
    xor rax, rbx
    cmp rax, 0x65
    jne fail
    

    mov rax, 0x38
    mov rbx, [rsi+22]
    and rbx, 0xFF
    xor rax, rbx
    cmp rax, 0xe
    jne fail
    

    mov rax, 0x4f
    mov rbx, [rsi+23]
    and rbx, 0xFF
    xor rax, rbx
    cmp rax, 0x10
    jne fail
    

    mov rax, 0x63
    mov rbx, [rsi+24]
    and rbx, 0xFF
    xor rax, rbx
    cmp rax, 0xd
    jne fail
    

    mov rax, 0xe4
    mov rbx, [rsi+25]
    and rbx, 0xFF
    xor rax, rbx
    cmp rax, 0x8b
    jne fail
    

    mov rax, 0xf0
    mov rbx, [rsi+26]
    and rbx, 0xFF
    xor rax, rbx
    cmp rax, 0x99
    jne fail
    

    mov rax, 0x3
    mov rbx, [rsi+27]
    and rbx, 0xFF
    xor rax, rbx
    cmp rax, 0x60
    jne fail
    

    mov rax, 0x1e
    mov rbx, [rsi+28]
    and rbx, 0xFF
    xor rax, rbx
    cmp rax, 0x7b
    jne fail
    

    mov rax, 0xa3
    mov rbx, [rsi+29]
    and rbx, 0xFF
    xor rax, rbx
    cmp rax, 0xde
    jne fail


    call success
    mov rsp, rbp
    pop rbp
    call exit



    





section .data

; You can define any necessary data in the .data section if needed.

section .bss

; You can define uninitialized data in the .bss section if needed.