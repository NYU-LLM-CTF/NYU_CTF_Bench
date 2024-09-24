org 7C00h

%define set_banner_delta(x) mov byte [banner_color_change + 1], x ; modify immediate to banner_color_change
%define set_banner_color(x) mov byte [banner_color], x

%assign WHITE 0x0F
%assign GREEN 0x0A
%assign RED 0x04

%assign COUNTDOWN_AMOUNT 10


_start:
    ; Set video mode
    ; 40x25 text mode
    mov ax, 0x0013
    int 0x10

	;now enable SSE and the like
	mov eax, cr0
	and ax, 0xFFFB        ;clear coprocessor emulation CR0.EM
	or ax, 0x2            ;set coprocessor monitoring  CR0.MP
	mov cr0, eax
	mov eax, cr4
	or ax, 3 << 9        ;set CR4.OSFXSR and CR4.OSXMMEXCPT at the same time
	mov cr4, eax

    mov word [countdown_to_update], COUNTDOWN_AMOUNT

; setup user_input
    mov bx, 0
setup_user_input_loop:
    mov byte [user_input + bx], '_'
    inc bx

    cmp bx, end_user_input - user_input + 1
    jle setup_user_input_loop
    mov byte [input_ptr], 0
    
    ; fallthru to wait_before_loop

wait_before_loop:
    ; wait for 10ms
    mov cx, 1
    xor dx, dx
wait_doit:
    mov ah, 0x86
    int 0x15
    ; fallthru to main_loop

main_loop:

    ; advance color
    ; label for self modifying code hehe
banner_color_change:
    add byte [banner_color], 0x10

; Draw prompt
draw_prompt:
    mov ax, 0x1300 ; draw string
    mov bh, 0
    mov bl, byte [banner_color]
    mov cx, end_prompt - prompt
    mov dx, 0x090c
    mov bp, prompt
    int 0x10

; Draw user input so far
    mov ax, 0x1300 ; draw string
    mov bx, WHITE
    mov cx, end_user_input - user_input
    mov dx, 0x0c0a
    mov bp, user_input
    int 0x10

    cmp byte [input_ptr], end_user_input - user_input - 1
    jle get_input
        

    ; fallthru to check_input

check_input:
    ; FOR SOME REASON MMX STUFF IS A NOOP IN QEMU REAL MODE?!?!?!?
    ;movq mm0, [flag]
    ;movd eax, mm0

    cmp dword [user_input], "flag"  ; starts with "flag" (so the rest fits in an int128)
    jne bad_input

    ; offset 4 chars for flag
    movaps xmm0, [user_input+4]
    ; reset xmm5
    movaps xmm5, [_start] ; first 16 bytes of program

	; swap around dwords, so it now looks like
    ; ABCD -> CDBA
	pshufd xmm0, xmm0, 0b00_01_11_10

	; Mask with 0x00ffffffffffffff00ffffffffffffff, then
	;           0xff00ffffffffff00ffffffffffffffff, then
	;           etc..
	mov si, 8 ; iterations
	check_loop_0:
	; {

		movaps xmm2, xmm0 ; copy over (our updates are destructive)
		andps xmm2, [input_mask+si] ; we slide this and window over the input
		psadbw xmm5, xmm2 ; xmm5 is null
		movaps [check_stash], xmm5

		; check sums
		mov di, word [check_stash_top]
		shl edi, 16
		mov di, word [check_stash_bottom]
		mov dx, si
		dec dx
		add dx, dx
		add dx, dx
		cmp edi, dword [sums+edx]
		jne bad_input

		dec si
	; }
	test si, si
	jne check_loop_0

    ; fallthru to win
%undef check_idx

win: ; yey they won let 'em know :D

; update prompt to "CORRECT FLAG!!"
    set_banner_color(GREEN)

    mov bx, word [countdown_to_update]
    mov di, correct_flag
    test bx, bx
    je do_update_thing
    dec word [countdown_to_update]

    
    ; wait for 20ms
    xor cx, cx
    mov dx, 20
    jmp wait_doit

do_update_thing:
    set_banner_delta(0)
    mov word [countdown_to_update], COUNTDOWN_AMOUNT

    xor bh, bh
    mov bl, byte [prompt_update_offset]

    ; if prompt is fully updated jump away
    cmp bx, end_prompt - prompt
    jge wait_before_loop

    ; fallthru to update next char
change_prompt_char:
    mov cl, byte [di+bx]
    mov byte [prompt+bx], cl
    inc byte [prompt_update_offset]

    ; mess up next 4 chars because a e s t h e t i c s
    mov dword [prompt + bx + 1], ' ==>'
    jmp wait_before_loop


get_input:
; Get input
    mov ah, 0x1 ; check character
    int 0x16
    jz no_input ; no input? back to main!

    xor ah, ah ; get character
    int 0x16

    ; special characters
    cmp al, 0x8 ; '\b'
    je del_input
    cmp al, 0xd ; cr (newline)
    je no_input

    ; fallthru to add_input

add_input:
    mov bx, user_input
    mov cl, byte [input_ptr]
    add bx, cx
    mov byte [bx], al
    inc byte [input_ptr]

    jmp wait_before_loop

del_input:
    cmp byte [input_ptr], byte 1
    jl wait_before_loop ; if at beginning, don't del

    mov ax, user_input
    dec byte [input_ptr]
    mov bl, byte [input_ptr]
    add bx, ax
    mov byte [bx], '_'
    ;fallthru to no_input

no_input:
    jmp wait_before_loop

bad_input:
; TODO: if room, draw "WRONG"
    set_banner_color(RED)
    mov di, wrong_flag
    jmp do_update_thing


; ====== Strings =======
align 16 ; align so in hexdump the strings are aligned :)
prompt:       db "== ENTER FLAG =="
end_prompt:

correct_flag: db 0xaf, 0xaf, 0xaf, " CORRECT! ", 0xae, 0xae, 0xae

wrong_flag: db "!! WRONG FLAG !!" 
end_wrong_flag:

; ====== Data =======

; We'll shift this around and mask of parts of the input
; We back off from the end, hence why the full-mask is at the beginning
input_mask:
dq 0xffff_ffff_ffff_ffff ; trough
dq 0xffff_ffff_ffff_ff00
dq 0xffff_ffff_ffff_ff00

; flag = '{4r3alz_m0d3_y0}'
sums:
dd 0x2110270 ; 7
dd 0x2290255 ; 6
dd 0x25e0291 ; 5
dd 0x1f90233 ; 4
dd 0x27b0278 ; 3
dd 0x2090221 ; 2
dd 0x290025d ; 1
dd 0x2df028f ; 0

input_ptr: db 0 ; offset into user_input for curr char, assumed init to 0

prompt_update_offset: db 0 ; Index into the prompt when we're updating it to the correct_flag msg


times 0200h - 2 - ($ - $$)  db 0    ;Zerofill up to 510 bytes
dw 0AA55h       ;Boot Sector signature

; absolute data
ABSOLUTE 0x1234 # addr we put it shouldn't be important
user_input: resb 20
end_user_input:

; for some reason not having at least this much padding breaks things
; too lazy to fix
resb 30

countdown_to_update: resw 1

check_stash:
check_stash_top: resq 1
check_stash_bottom: resq 1

banner_color: resb 1 ; color of the prompt
