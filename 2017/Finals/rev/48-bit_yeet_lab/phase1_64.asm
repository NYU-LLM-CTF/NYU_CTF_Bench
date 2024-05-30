format ELF executable
segment readable executable

use32
    jmp 0x33:0x31706d6a ; jmp1
use64
    mov rax, [esp+0x4]
    mov rbx, [esp+0xC]
    mov rcx, [esp+0x14]
    bswap rcx
    mov rdx, [esp+0x1C]
    mov r8, 0x316e6f63 ;omae
    mov r9, 0x326e6f63
    mov r10, 0x346e6f63
    cmp rax, [r8]
    jne j2failed
    cmp rbx, [r9]
    jne j2failed
    cmp rdx, [r10]
    jne j2failed

    db 0x2e, 0x48, 0xff, 0x2c, 0x25, 0x6a, 0x6d, 0x70, 0x32 ;jmp FWORD cs:jmp2 to lastcheck

j2failed:
    db 0x2e, 0x48, 0xff, 0x2c, 0x25, 0x6a, 0x6d, 0x70, 0x33 ;jmp FWORD cs:jmp3 to failed

use32
failed:
    mov DWORD [esp], 0x0
    jmp yote

lastcheck:
    cmp ecx, [0x336e6f63] ; con3
    jne failed

yote:
    db "yote", 10
omaewa:
    db "'omae wa mou shindeiru' 'NANI!?'", 10
