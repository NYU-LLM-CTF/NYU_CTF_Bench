format ELF64 executable

segment readable executable

use32
    jmp 0x33:0x34706d6a

use64
fun:
    mov	    r9, rdi
    mov	    r10, rsi

    mov	    rcx, r9
    and	    rcx, 0xff00	    ; get second lowest byte for write length
    shr	    rcx, 8
    xor	    rdx, rdx
    mov	    rax, rcx
    mov	    rcx, pass_len+1
    div	    rcx

    xor	    r11, r11
    mov	    rcx, r9
    and	    rcx, 0xff0000
    shr	    rcx, 16
    movsx   rcx, cl
    movzx   r8, byte [r10+rcx]
    add	    r11, r8

    mov	    rcx, r9
    mov	    r12, 0xff000000
    and	    rcx, r12
    shr	    rcx, 24
    movsx   rcx, cl
    movzx   r8, byte [r10+rcx]
    add	    r11, r8

    mov	    rcx, r9
    mov	    r12, 0xff00000000
    and	    rcx, r12
    shr	    rcx, 32
    movsx   rcx, cl
    movzx   r8, byte [r10+rcx]
    add	    r11, r8

    mov	    rcx, r9
    mov	    r12, 0xff0000000000
    and	    rcx, r12
    shr	    rcx, 40
    movsx   rcx, cl
    movzx   r8, byte [r10+rcx]
    add	    r11, r8

    mov	    rcx, r9
    mov	    r12, 0xff000000000000
    and	    rcx, r12
    shr	    rcx, 48
    movsx   rcx, cl
    movzx   r8, byte [r10+rcx]
    add	    r11, r8

    mov	    rcx, r9
    and	    rcx, 0xff	    ; get lowest byte for rip offset
    movzx   r8, byte [r10+rcx]
    and	    r8, 0x08
    cmp	    r8, 0x08
    jne	    .odd
    .even:
	mov	rax, 0x1
	jmp	.setup
    .odd:
	mov	rax, 0x6

    .setup:
	mov	rdi, stdout
    	mov	rsi, 0x356e6f63 ; move passphrase into rsi for write syscall

    cmp	    r11, 0x1f2
    jne	    .thirtytwo
    .sixtyfour:
	syscall
	jmp .done
    .thirtytwo:
	int	0x80

    .done:
	ret


get_ip:
    mov	    rax, [rsp]
    ret

; get_input:
;     sub	    rsp, 20
;     xor	    rax, rax
;     mov	    rdi, stdin
;     mov	    rsi, rsp
;     mov	    rdx, 19
;     syscall
;     mov	    byte[rsp+19], 0x0
;     mov	    rax, rsp
;     add	    rsp, 20
;     ret

; atoi:
;     xor	    rax, rax
;     .top:
; 	movzx	    rcx, byte [rdi]
;     	inc	    rdi
;     	cmp	    rcx, 0x30
; 	jb	    .done
; 	cmp	    rcx, 0x39
; 	ja	    .done
; 	sub	    rcx, 0x30
; 	imul	    rax, 10
; 	add	    rax, rcx
; 	jmp	    .top
; 	
;     .done:
; 	ret

; exit:
;     xor	    rax, rax	    ; clear rax
;     add	    al, 60	    ; exit syscall number
;     syscall		    ; do exit

start:
;     xor	    rax, rax	    ; clear rax
;     add	    al, 0x1	    ; move write syscall number
;     mov	    rdi, stdout	    ; write to stdout
;     mov	    rsi, greeting   ; write greeting
;     mov	    rdx, greet_len  ; write greeting length bytes
;     syscall		    ; do write
;     
;     call    get_input	    ; get number from user
; 
;     mov	    rdi, rax	    ; convert user num and save in rcx
;     call    atoi
;     mov	    r12, rax
; 
;     xor	    rax, rax	    ; tell user str is in rsi
;     add	    al, 0x1
;     mov	    rdi, stdout
;     mov	    rsi, strmoved
;     mov	    rdx, moved_len
;     syscall
;     mov	    rdi, r12	    ; move user input back into rdi
    mov     rdi, QWORD [ebp-0x40]
    call    get_ip
    mov	    rsi, rax
    call    fun
    db      0x2e, 0x48, 0xff, 0x2c, 0x25, 0x6a, 0x6d, 0x70, 0x35 ;jmp FWORD cs:jmp5 to lastcheck

use32
reeeee:
    db      0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90 ;jmp FWORD cs:jmp5 to lastcheck
    db      0x90, 0x90, 0x90, 0x90, 0x90     

segment readable writable

yote:
    db "yote", 10
passphrase  db	0xa, "phrase_2_secret_pass", 0x21, 0xa, 0
pass_len    =	$-passphrase
stdin	    =	0
stdout	    =	1
stderr	    =	2
