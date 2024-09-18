
%macro popreg 0
    pop r15
    pop r8
    pop r9
%endmacro

%macro pushreg 0
    push r9
    push r8
    push r15
    ret
%endmacro

%macro pushregnoret 0
    push r9
    push r8
%endmacro

section .text

global mpush
global madd
global msub
global mxor
global mmov
global minc
global mdec
global mcmp
global mjne
global mret
global mcall
global msyscall
global mcpu_entry
global mand

mpush:
    popreg
    sub rbp, 8
    mov [rbp], r8
    pushreg    

mpop:
    popreg
    mov r8, [rbp]
    add rbp, 8
    pushreg

madd:
    popreg
    add r8, r9
    pushreg

msub:
    popreg
    sub r8, r9
    pushreg

mxor:
    popreg
    xor r8, r9
    pushreg

mand:
    popreg
    and r8, r9
    pushreg

mmov:
    popreg
    mov r8, r9
    pushreg

mmov_reg:
    popreg
    pop r14
    mov [r8+r14], r9
    push r14
    pushreg

mmov_regimmrhs:
    popreg
    pop r14
    mov r8, [r9+r14]
    push r14
    pushreg

minc:
    popreg
    inc r8
    pushreg

mdec:
    popreg
    dec r8
    pushreg

mcmp:
    popreg
    ; clear LSB
    and r10, 0xfffffffffffffffe
    cmp r8, r9
    jne mcmp_exit
    or r10, 1
mcmp_exit:
    pushreg

mjne:
    popreg
    mov r9, r10
    and r9, 1
    cmp r9, 1
    je mjne_exit
    add rsi, r8
mjne_exit:
    pushreg

mret:
    popreg
    mov rsi, [rbp]
    add rbp, 8
    pushreg

mcall:
    popreg
    sub rbp, 8
    mov [rbp], rsi
    add rsi, r8
    pushreg

msyscall:
    popreg

    ; save the registers
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    push rbp
    push rsp
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    push r14
    push r15
    pushfq

    syscall

    ; restore registers

    popfq
    pop r15
    pop r14
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rsp
    pop rbp
    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rbx

    mov r8, rax

    pushreg

; TODO:
; push every register to stack
; pop opcode, lhs, rhs, imm
; based on opcode's flag, push imm or dereference lhs rhs to stack
; BUGFIX:
; when the routine returns, make sure the register in memory is modified correctly

mcpu_entry:

    ; reference to the registers
    sub rsp, 0x90
    mov r12, rsp

    mov rsp, rdi
    sub rsp, 0x2000
    ; save state a chunk of buf for base pointer based buf for our prog
    mov [r12 + 16*8], rdi
    ; save state a chunk of rsp for our cpu based calculations, no need for a lot
    ; move the rest to rbp for the prog's calculation need
    mov rbp, rsp
    sub rbp, 0x2000

    ; savestate stack
    mov [r12 + 7*8], rbp

mcpu_loop:

    ; sync registers
    mov rbp, [r12 + 7*8]

    ; opcode
    mov r13, [rsi]
    add rsi, 8
    ; lhs, rhs, imm
    mov r8, [rsi]
    add rsi, 8
    mov r9, [rsi]
    add rsi, 8
    mov r14, [rsi]
    add rsi, 8

    ; mpush
    mov r15, r13
    and r15, 0b1
    cmp r15, 0
    je mpush_out
    mov r15, r13
    and r15, 0b10
    cmp r15, 0
    jne mpush_imm

    push r9
    push r8
    push qword [r12 + r9*8]
    push qword [r12 + r8*8]
    call mpush
    mov [r12 + 7*8], rbp
    pop r8
    pop r9
    pop r15
    mov [r12+r15*8], r8
    pop r15
    ; mov [r12+r15*8], r9

    jmp out
mpush_imm:

    push r8
    push r14
    push r8
    call mpush
    mov [r12 + 7*8], rbp
    pop r8
    pop r14
    pop r15


    jmp out
mpush_out:
    mov r15, r13
    and r15, 0b10000
    cmp r15, 0
    je madd_out
    mov r15, r13
    and r15, 0b100000
    cmp r15, 0
    jne madd_regimm

    push r9
    push r8
    push qword [r12 + r9*8]
    push qword [r12 + r8*8]
    call madd
    pop r8
    pop r9
    pop r15
    mov [r12+r15*8], r8
    pop r15
    ; mov [r12+r15*8], r9

    jmp out
madd_regimm:

    push r8
    push r14
    push qword [r12 + r8*8]
    call madd
    pop r8
    pop r14
    pop r15
    mov [r12+r15*8], r8

    jmp out
madd_out:
    mov r15, r13
    and r15, 0b100000000
    cmp r15, 0
    je msub_out
    mov r15, r13
    and r15, 0b1000000000
    cmp r15, 0
    jne msub_regimm

    push r9
    push r8
    push qword [r12 + r9*8]
    push qword [r12 + r8*8]
    call msub
    pop r8
    pop r9
    pop r15
    mov [r12+r15*8], r8
    pop r15
    ; mov [r12+r15*8], r9

    jmp out
msub_regimm:

    push r8
    push r14
    push qword [r12+r8*8]
    call msub
    pop r8
    pop r14
    pop r15
    mov [r12+r15*8], r8

    jmp out
msub_out:

    mov r15, r13
    and r15, 0b1000000000000
    cmp r15, 0
    je mxor_out
    mov r15, r13
    and r15, 0b10000000000000
    cmp r15, 0
    jne mxor_regimm

    push r9
    push r8
    push qword [r12 + r9*8]
    push qword [r12 + r8*8]
    call mxor
    pop r8
    pop r9
    pop r15
    mov [r12+r15*8], r8
    pop r15
    ; mov [r12+r15*8], r9

    jmp out
mxor_regimm:

    push r8
    push r14
    push qword [r12 + r8*8]
    call mxor
    pop r8
    pop r14
    pop r15
    mov [r12+r15*8], r8

    jmp out
mxor_out:

    mov r15, r13
    and r15, 0b10000000000000000
    cmp r15, 0
    je mmov_out
    mov r15, r13
    and r15, 0b100000000000000000
    cmp r15, 0
    jne mmov_regimm
    mov r15, r13
    and r15, 0b1000000000000000000
    cmp r15, 0
    jne mmov_regregreg
    mov r15, r13
    and r15, 0b10000000000000000000
    cmp r15, 0
    jne mmov_regregimm

    push r9
    push r8
    push qword [r12 + r9*8]
    push qword [r12 + r8*8]
    call mmov
    pop r8
    pop r9
    pop r15
    mov [r12+r15*8], r8
    pop r15
    ; mov [r12+r15*8], r9

    jmp out
mmov_regimm:

    push r8
    push r14
    push qword [r12 + r8*8]
    call mmov
    pop r8
    pop r14
    pop r15
    mov [r12+r15*8], r8

    jmp out
mmov_regregreg: ; r14 is supplemental register

    push r14
    push r9
    push r8
    push qword [r12 + r14*8]
    push qword [r12 + r9*8]
    push qword [r12 + r8*8]
    call mmov_reg
    pop r8
    pop r9
    pop r14
    pop r15
    mov [r12+r15*8], r8
    pop r15
    mov [r12+r15*8], r9
    pop r15
    mov [r12+r15*8], r14

    jmp out
mmov_regregimm:

    push r9
    push r8
    push r14
    push qword [r12 + r9*8]
    push qword [r12 + r8*8]
    call mmov_reg
    pop r8
    pop r9
    pop r14
    pop r15
    mov [r12+r15*8], r8
    pop r15
    mov [r12+r15*8], r9

    jmp out
mmov_out:

    mov r15, r13
    and r15, 0b100000000000000000000
    cmp r15, 0
    je minc_out
    
    push r8
    push qword [r12 + r9*8]
    push qword [r12 + r8*8]
    call minc
    pop r8
    pop r9
    pop r15
    mov [r12+r15*8], r8

    jmp out
minc_out:

    mov r15, r13
    and r15, 0b1000000000000000000000000
    cmp r15, 0
    je mdec_out

    push r8
    push qword [r12+r9*8]
    push qword [r12+r8*8]
    call mdec
    pop r8
    pop r9
    pop r15
    mov [r12+r15*8], r8

    jmp out
mdec_out:

    mov r15, r13
    and r15, 0b10000000000000000000000000000
    cmp r15, 0
    je mcmp_out
    mov r15, r13
    and r15, 0b100000000000000000000000000000
    jne mcmp_regimm

    mov r10, [r12+0xA*8]
    push qword [r12+r9*8]
    push qword [r12+r8*8]
    call mcmp
    pop r8
    pop r9
    mov [r12+0xA*8], r10

    jmp out

mcmp_regimm:

    mov r10, [r12+0xA*8]
    push r14
    push qword [r12+r8*8]
    call mcmp
    pop r8
    pop r14
    mov [r12+0xA*8],r10

    jmp out
mcmp_out:

    push r13
    mov r15, r13
    xor r13, r13
    inc r13
    shl r13, 32
    and r15, r13
    pop r13
    cmp r15, 0
    je mjne_out

    mov r10, [r12+0xA*8]
    push r14
    push r8
    call mjne
    pop r8
    pop r14
    mov [r12+0xA*8],r10

    jmp out
mjne_out:

    push r13
    mov r15, r13
    xor r13, r13
    inc r13
    shl r13, 36
    and r15, r13
    pop r13
    cmp r15, 0
    je mret_out

    push r14
    push r8
    call mret
    mov [r12 + 7*8], rbp
    pop r8
    pop r14

    jmp out
mret_out:

    push r13
    mov r15, r13
    xor r13, r13
    inc r13
    shl r13, 40
    and r15, r13
    pop r13
    cmp r15, 0
    je mcall_out

    push r14
    push r8
    call mcall
    mov [r12 + 7*8], rbp
    pop r8
    pop r14

    jmp out
mcall_out:

    push r13
    mov r15, r13
    xor r13, r13
    inc r13
    shl r13, 44
    and r15, r13
    pop r13
    cmp r15, 0
    je msyscall_out
    
    ; save and furnish call regs
    push rax
    push rdi
    push rsi
    push rdx

    mov rax, [r12+1*8]
    mov rdi, [r12+6*8]
    mov rsi, [r12+5*8]
    mov rdx, [r12+4*8]

    push r9
    push r8

    call msyscall

    pop r8
    pop r9

    pop rdx
    pop rsi
    pop rdi
    pop rax

    mov [r12+1*8], r8

    jmp out
msyscall_out:

    push r13
    mov r15, r13
    xor r13, r13
    inc r13
    shl r13, 48
    and r15, r13
    pop r13
    cmp r15, 0
    je mmov_regimmrhs_out

    push r9
    push r8
    push r14
    push qword [r12 + r9*8]
    push qword [r12 + r8*8]
    call mmov_regimmrhs
    pop r8
    pop r9
    pop r14
    pop r15
    mov [r12+ r15*8], r8
    pop r15
    mov [r12+ r15*8], r9

    jmp out

mmov_regimmrhs_out:

    push r13
    mov r15, r13
    xor r13, r13
    inc r13
    shl r13, 52
    and r15, r13
    pop r13
    cmp r15, 0
    je mand_out
    push r13
    mov r15, r13
    xor r13, r13
    inc r13
    shl r13, 53
    and r15, r13
    pop r13
    cmp r15, 0
    jne mand_regimm

    push r9
    push r8
    push qword [r12 + r9*8]
    push qword [r12 + r8*8]
    call mand
    pop r8
    pop r9
    pop r15
    mov [r12 + r15*8], r8
    pop r15
    ; mov [r12 + r15*8], r9

    jmp out
mand_regimm:

    push r8
    push r14
    push qword [r12 + r8*8]
    call mand
    pop r8
    pop r14
    pop r15
    mov [r12 + r15*8], r8

    jmp out

mand_out:
    ; mpush
    push r13
    mov r15, r13
    xor r13, r13
    inc r13
    shl r13, 56
    and r15, r13
    pop r13
    cmp r15, 0
    je mpop_out

    push r9
    push r8
    push qword [r12 + r9*8]
    push qword [r12 + r8*8]
    call mpop
    mov [r12 + 7*8], rbp
    pop r8
    pop r9
    pop r15
    mov [r12+r15*8], r8
    pop r15
    ; mov [r12+r15*8], r9

    jmp out
mpop_out:

    ; unsupported opcode
    int 3
out:
    jmp mcpu_loop

section .data

; You can define any necessary data in the .data section if needed.

section .bss

; You can define uninitialized data in the .bss section if needed.