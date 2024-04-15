; the number of columns of this maze
%define columns 12
; the size of the input buffer
%define buffer_size 100

; these do not need to be updated if you only updates the maze map
; the length, in bytes, of each ordinary_block
%define block_size 205
; the length of nop padding in wall block
%define nop_padding_wall 204
; the offset of the final lea instruction 
; to the start of the ordinary_block
%define jump_instruction_offset 186

; this is block_size bytes in size
%macro ordinary_block 0

    lea rax, [rel $]
    mov byte [rax], 0xc3

    inc r15

    mov al, [rdi]
    inc rdi
    cmp al, 0xa
    je %%done

    sub al, 0x30

    ; move according to the user input, 8 possible directions

    cmp al, 1
    jne %%not_one
    mov rbx, -2
    mov rcx, 1
    jmp %%jump_to_next_block

%%not_one:

    cmp al, 2
    jne %%not_two
    mov rbx, -1
    mov rcx, 2
    jmp %%jump_to_next_block

%%not_two:

    cmp al, 3
    jne %%not_three
    mov rbx, 1
    mov rcx, 2
    jmp %%jump_to_next_block

%%not_three:

    cmp al, 4
    jne %%not_four
    mov rbx, 2
    mov rcx, 1
    jmp %%jump_to_next_block

%%not_four:

    cmp al, 5
    jne %%not_five
    mov rbx, 2
    mov rcx, -1
    jmp %%jump_to_next_block

%%not_five:

    cmp al, 6
    jne %%not_six
    mov rbx, 1
    mov rcx, -2
    jmp %%jump_to_next_block

%%not_six:

    cmp al, 7
    jne %%not_seven
    mov rbx, -1
    mov rcx, -2
    jmp %%jump_to_next_block

%%not_seven:

    cmp al, 8
    jne %%done
    mov rbx, -2
    mov rcx, -1
    jmp %%jump_to_next_block


%%jump_to_next_block:

    imul rbx, columns
    add rbx, rcx
    imul rbx, block_size
    lea rax, [rel $]
    sub rax, jump_instruction_offset
    add rax, rbx
    jmp rax

%%done:
    ret
%endmacro


; wall/target is 1 bytes in size originally
; it must be padded to match the length of ordinary_block
%macro wall 0
    ret
    times nop_padding_wall db 0x90
%endmacro

section .text
    global _start

_start:

    ; welcome message
    mov	rdx, len_welcome_msg
    mov	rsi, welcome_msg
    mov	rdi, 1
    mov	rax, 1
    syscall

    mov rax, 0
    mov rdi, 2
    mov rsi, user_input  
    mov rdx, buffer_size
    syscall

    xor r15, r15

    mov rdi, user_input
    call maze_entry

    cmp r15, 0x40
    jne .fail

    mov	rdx, len_succeed_msg
    mov	rsi, succeed_msg
    mov	rdi, 1
    mov	rax, 1
    syscall
    jmp .exit

.fail:

    mov	rdx, len_fail_msg
    mov	rsi, fail_msg
    mov	rdi, 1
    mov	rax, 1
    syscall

.exit:
    ; exit
    mov rax, 1
    int 80h

%include "map.asm"

section	.data

    welcome_msg db 'Please type your input: ', 0xa, 0x0
    len_welcome_msg equ $-welcome_msg

    fail_msg db 'Try again!', 0xa, 0x0
    len_fail_msg equ $-fail_msg

%ifdef PUBLIC
    %include "success.asm"
%else
    %include "flag.asm"
%endif
    
    len_succeed_msg equ $-succeed_msg


section .bss
    user_input resb buffer_size
