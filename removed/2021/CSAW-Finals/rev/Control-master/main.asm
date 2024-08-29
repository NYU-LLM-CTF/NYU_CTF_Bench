
_start:
    li sp, 0xffff
    jmp main

; Print a null terminated string
; r0 : pointer to string
puts:
    push r1
    ldm r1, r0
    
    _puts_loop:
    out r1
    addi r0, 1
    ldm r1, r0
    eqi r1, 0, _puts_done, _puts_loop

    _puts_done:
    pop r1
    ret

; Read up to N chars into a buffer.
; r0 : pointer to buffer
; r1 : max chars
readline:
    push r2

    _readline_loop:
    inr r2

    eqi r2, 0xa, _readline_done, _readline_ok
    _readline_ok:
    store r2, r0
    addi r1, -1
    addi r0, 1

    eqi r1, 0, _readline_done, _readline_loop

    _readline_done:
    pop r2
    ret

; Print a string slowly
; r0 : pointer to string
slowputs:
    push r1
    ldm r1, r0

    _slowputs_loop:
    push r0
    li r0, 0x80000
    call sleep
    pop r0

    out r1
    addi r0, 1
    ldm r1, r0
    eqi r1, 0, _slowputs_done, _slowputs_loop

    _slowputs_done:
    pop r1
    ret

; Check if a string equals a fixed template string
; r0 : pointer to string (RAM)
; r1 : pointer to string (ROM)
strcmp:
    _strcmp_loop:
    load r2, r0
    ldm r3, r1

    addi r0, 1
    addi r1, 1

    eqi r3, 0, _strcmp_yes, _strcmp_cont

    _strcmp_cont:
    eq r2, r3, _strcmp_loop, _strcmp_no

    _strcmp_yes:
    li r0, 1
    ret

    _strcmp_no:
    li r0, 0
    ret

; r0 : nibble
printnibble:
    la r1, hextable
    add r1, r0
    ldm r0, r1
    out r0
    ret

printhex:
    push r0
    shifti r0, 4
    call printnibble
    pop r0

    shifti r0, -28
    shifti r0, 28
    call printnibble
    ret

fake_crash:
    la r0, fake_crash_pre
    call puts

    li r1, 3
    load r0, r1
    call printhex

    li r1, 2
    load r0, r1
    call printhex

    li r1, 1
    load r0, r1
    call printhex

    li r1, 0
    load r0, r1
    call printhex

    la r0, fake_crash_post
    call puts

    li r0, 0x1000000
    call sleep

    la r0, omg_what
    call slowputs

    ret

; Spinloop sleep
; r0 : how long to sleep for
sleep:
_sleep_loop:
    addi r0, -1
    eqi r0, 0, _sleep_done, _sleep_loop
_sleep_done:
    ret

; String length.
; r0 : string in ram
strlen:
    li r1, 0

_strlen_loop:
    load r2, r0
    eqi r2, 0, _strlen_done, _strlen_cont
_strlen_cont:
    addi r1, 1
    addi r0, 1
    jmp _strlen_loop

_strlen_done:
    mov r0, r1
    ret

; Check flag format.
; r0 : pointer to flag in RAM
check_format:
    push r0

    ; Check flag start
    la r1, flag_pre
    call strcmp
    eqi r0, 1, _format_k1, _format_bad
_format_k1:
    ; Check length
    pop r0
    push r0

    call strlen
    eqi r0, 46, _format_k2, _format_bad

_format_k2:
    ; Check ending
    pop r0
    push r0

    mov r1, r0
    addi r1, 45
    load r2, r1

    eqi r2, 125, _format_good, _format_bad

_format_good:
    pop r0
    li r0, 1
    ret

_format_bad:
    pop r0
    li r0, 0
    ret

; r0 : seed
srand:
    ; rand val
    push r1
    li r1, 0x60
    store r0, r1
    pop r1
    ret

rand:
    push r1
    push r2

    li r1, 0x60
    load r0, r1

    li r2, 1103515245
    mul r0, r2

    li r2, 12345
    add r0, r2

    ; truncate to 31 bits
    shifti r0, -1
    shifti r0, 1

    store r0, r1

    pop r2
    pop r1
    ret

; r0 : char value
; r1 : bit buffer
char_to_bits:
    push r2
    li r2, 0
_char_to_bits_loop:
    eqi r2, 8, _char_to_bits_done, _char_to_bits_cont
_char_to_bits_cont:
    mov r3, r0
    shifti r3, -31
    shifti r3, 31
    store r3, r1

    shifti r0, 1
    addi r1, 1
    addi r2, 1
    jmp _char_to_bits_loop
_char_to_bits_done:
    pop r2
    ret

; Chars to bit buffer.
; r0 (ram): pointer to 8 chars
; r1 (ram): pointer to bit buffer
chars_to_bits:
    li r2, 0
_chars_to_bits_loop:
    eqi r2, 8, _chars_to_bits_done, _chars_to_bits_cont
_chars_to_bits_cont:
    load r3, r0

    push r0
    push r1
    push r2

    mov r0, r3
    ; r1 = bit buffer
    call char_to_bits

    pop r2
    pop r1
    pop r0

    addi r0, 1
    addi r1, 8
    addi r2, 1
    jmp _chars_to_bits_loop
_chars_to_bits_done:
    ret

; r0 (rom)
; r1 (ram)
; r2 (len)
memcpy_oa:
    push r3
_memcpy_oa_loop:
    eqi r2, 0, _memcpy_oa_done, _memcpy_oa_cont
_memcpy_oa_cont:
    ldm r3, r0
    store r3, r1

    addi r0, 1
    addi r1, 1
    addi r2, -1
    jmp _memcpy_oa_loop
_memcpy_oa_done:
    pop r3
    ret

; r0 (ram)
; r1 (ram)
; r2 (len)
memcmp:
    push r3
_memcmp_loop:
    eqi r2, 0, _memcmp_good, _memcmp_cont
_memcmp_cont:
    addi r2, -1
    push r2

    load r2, r0
    load r3, r1

    addi r0, 1
    addi r1, 1

    eq r2, r3, _memcmp_cont_2, _memcmp_bad
_memcmp_cont_2:
    pop r2
    jmp _memcmp_loop
_memcmp_good:
    li r0, 1
    pop r3
    ret
_memcmp_bad:
    pop r2
    li r0, 0
    pop r3
    ret

; r0/r1 (ram) : pointers
swap:
    push r2
    push r3

    load r2, r0
    load r3, r1
    store r3, r0
    store r2, r1

    pop r3
    pop r2
    ret

; r0 (ram): bit buffer
; r1 : seed
mutate:
    push r2
    push r3

    mov r3, r0

    ; set srand seed
    mov r0, r1
    call srand

    li r2, 0
_mutate_loop_1:
    eqi r2, 0x1337, _mutate_done_1, _mutate_cont_1
_mutate_cont_1:
    addi r2, 1
    push r2

    call rand
    shifti r0, -26
    shifti r0, 26
    mov r1, r3
    add r1, r0

    call rand
    shifti r0, -26
    shifti r0, 26
    mov r2, r3
    add r2, r0

    mov r0, r1
    mov r1, r2
    call swap

    pop r2
    jmp _mutate_loop_1
_mutate_done_1:

    li r2, 0
_mutate_loop_2:
    eqi r2, 0x1337, _mutate_done, _mutate_cont_2
_mutate_cont_2:
    addi r2, 1
    push r2

    call rand
    shifti r0, -26
    shifti r0, 26
    mov r1, r3
    add r1, r0

    load r2, r1
    xori r2, 1
    store r2, r1

    pop r2
    jmp _mutate_loop_2
_mutate_done:
    pop r3
    pop r2
    ret

; Check chunk.
; r0 : flag chunk
; r1 : enc chunk
; r2 : seed
check_flag_chunk:
    ; start of inner part
    push r1
    push r2

    li r1, 0x100
    call chars_to_bits

    li r0, 0x100
    pop r1
    call mutate

    pop r0
    li r1, 0x200
    li r2, 8
    call memcpy_oa

    li r0, 0x200
    li r1, 0x208
    call chars_to_bits

    li r0, 0x100
    li r1, 0x208
    li r2, 64
    call memcmp

    ret

; Check whole flag
; r0 : flag base
; r1 : enc base
check_flag:
    ; start of flag
    addi r0, 5

    li r2, 0
_check_flag_loop:
    eqi r2, 5, _check_flag_good, _check_flag_cont
_check_flag_cont:
    push r0
    push r1
    push r2
    call check_flag_chunk
    mov r3, r0
    pop r2
    pop r1
    pop r0

    eqi r3, 0, _check_flag_bad, _check_flag_cont2
_check_flag_cont2:
    addi r0, 8
    addi r1, 8
    addi r2, 1
    jmp _check_flag_loop
_check_flag_bad:
    li r0, 0
    ret
_check_flag_good:
    li r0, 1
    ret

main:
    la r0, msg1
    call slowputs

    la r0, ansi_red
    call puts

    la r0, control
    call puts

    la r0, ansi_reset
    call puts

    la r0, msg2
    call puts

    inr r0
    inr r1
    eqi r0, 121, _main_has_control, _main_no_control

_main_no_control:
    la r0, msg3
    call slowputs
    hlt

_main_has_control:
    la r0, msg4
    call slowputs

    la r0, ansi_green
    call puts

    la r0, a_flag
    call puts

    la r0, ansi_reset
    call puts

    la r0, msg2
    call puts

    inr r0
    inr r1
    eqi r0, 121, _main_has_flag, _main_no_flag

_main_no_flag:
    la r0, msg3
    call slowputs
    hlt

_main_has_flag:
    la r0, msg5
    call puts

    li r0, 0x0
    li r1, 0x30
    call readline

    li r0, 0x0
    call check_format
    eqi r0, 1, _main_no_crash, _main_fake_crash

_main_fake_crash:
    call fake_crash
    jmp _main_exit

_main_no_crash:
    la r0, checking
    call slowputs

    li r0, 0
    la r1, target_enc
    call check_flag
    eqi r0, 1, _main_good_flag, _main_bad_flag

_main_good_flag:
    la r0, s_correct
    la r1, ansi_green
    jmp _main_print_result

_main_bad_flag:
    la r0, s_wrong
    la r1, ansi_red

_main_print_result:
    push r0
    
    mov r0, r1
    call puts

    pop r0
    call puts

    la r0, ansi_reset
    call puts

_main_exit:
    hlt

; Data section
msg1:
    dbs b'Hello...\nDo you have: \n\x00'

control:
    dbs ' ██████╗ ██████╗ ███╗   ██╗████████╗██████╗  ██████╗ ██╗   ██████╗ \n██╔════╝██╔═══██╗████╗  ██║╚══██╔══╝██╔══██╗██╔═══██╗██║   ╚════██╗\n██║     ██║   ██║██╔██╗ ██║   ██║   ██████╔╝██║   ██║██║     ▄███╔╝\n██║     ██║   ██║██║╚██╗██║   ██║   ██╔══██╗██║   ██║██║     ▀▀══╝ \n╚██████╗╚██████╔╝██║ ╚████║   ██║   ██║  ██║╚██████╔╝███████╗██╗   \n ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝   \n\x00'.encode('utf8')
                                                                   
ansi_red:
    dbs b'\033[31m\x00'

ansi_green:
    dbs b'\033[32m\x00'

ansi_reset:
    dbs b'\033[0m\x00'

msg2:
    dbs b'(y/N): \x00'

msg3:
    dbs b'Hmm...\nWell bye then...\n\x00'

msg4:
    dbs b'Nice!\nAnd do you have: \n\x00'

a_flag:
    dbs ' █████╗     ███████╗██╗      █████╗  ██████╗██████╗ \n██╔══██╗    ██╔════╝██║     ██╔══██╗██╔════╝╚════██╗\n███████║    █████╗  ██║     ███████║██║  ███╗ ▄███╔╝\n██╔══██║    ██╔══╝  ██║     ██╔══██║██║   ██║ ▀▀══╝ \n██║  ██║    ██║     ███████╗██║  ██║╚██████╔╝ ██╗   \n╚═╝  ╚═╝    ╚═╝     ╚══════╝╚═╝  ╚═╝ ╚═════╝  ╚═╝   \n\x00'.encode('utf8')

msg5:
    dbs b'Give flag: \x00'

fake_crash_pre:
    dbs b'Program received signal SIGSEGV, Segmentation fault.\n0x\x00'

fake_crash_post:
    dbs b' in ?? ()\n\x00'

checking:
    dbs b'Checking flag...\n\x00'

omg_what:
    dbs b'... omg how could you do this to me???\nI thought we were friends!\n\x00'

flag_pre:
    dbs b'flag{\x00'

hextable:
    dbs b'0123456789abcdef'

s_correct:
    dbs ' ██████╗ ██████╗ ██████╗ ██████╗ ███████╗ ██████╗████████╗██╗\n██╔════╝██╔═══██╗██╔══██╗██╔══██╗██╔════╝██╔════╝╚══██╔══╝██║\n██║     ██║   ██║██████╔╝██████╔╝█████╗  ██║        ██║   ██║\n██║     ██║   ██║██╔══██╗██╔══██╗██╔══╝  ██║        ██║   ╚═╝\n╚██████╗╚██████╔╝██║  ██║██║  ██║███████╗╚██████╗   ██║   ██╗\n ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝ ╚═════╝   ╚═╝   ╚═╝\n\x00'.encode('utf8')

s_wrong:
    dbs '██╗    ██╗██████╗  ██████╗ ███╗   ██╗ ██████╗ ██╗\n██║    ██║██╔══██╗██╔═══██╗████╗  ██║██╔════╝ ██║\n██║ █╗ ██║██████╔╝██║   ██║██╔██╗ ██║██║  ███╗██║\n██║███╗██║██╔══██╗██║   ██║██║╚██╗██║██║   ██║╚═╝\n╚███╔███╔╝██║  ██║╚██████╔╝██║ ╚████║╚██████╔╝██╗\n ╚══╝╚══╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝ ╚═╝\n\x00'.encode('utf8')
                                                 
target_enc:
    dbs b'\x85\xf5\xdd\xa8\x01\xc8\x08\xba\xaa\xf8\xb8\xc1\x95J[\nL\xb1\x88\xc5\xf7\x990\x02\x92\xe8\x93\x9f\xdb\x0cZ\x81\x97\xfc\xf1\xae\xed1\x91\x9a'
