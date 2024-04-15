jun main
hlt: jun hlt

; each of these opcode handlers should run exactly one instruction, then jump
; back to main_loop
; Before this handler was called, the 4 nibbles of the instruction were loaded into
; r9, r10, r11, and r12, respectively.


;fail r1, r2, imm:
;    if r1 == r2:
;        if imm == 1:
;           FAILED ||= imm
;        READY_TO_STOP = true
handle_opcode_fail:
; get first reg value
ld r10
jms load_vm_register
xch r0
xch r10
; get second reg value
ld r11
jms load_vm_register
xch r0
xch r11
; if r1 != r2
ld r10
sub r11
jcn a handle_opcode_fail__done
  ; if imm == 1
  ld r12
  jcn a handle_opcode_fail__after_or
    ; if READY_TO_STOP == 0:
    fim p0 vm_ready_to_stop
    src p0
    rdm
    jcn na handle_opcode_fail__after_or
      ; FAILED = imm
      fim p0 vm_failed
      src p0
      ld r12
      wrm
  handle_opcode_fail__after_or:
  ; READY_TO_STOP = true
  fim p0 vm_ready_to_stop
  src p0
  ldm 1
  wrm
handle_opcode_fail__done:
jun main_loop
; end handle_opcode_fail


;rol r1, imm
handle_opcode_rol:
; get reg value
ld r10
jms load_vm_register
xch r0
xch r6

ld r11
xch r7

; do {
;   c, a = rol1(val)
;   val = a
;   a = c
;   a += val
;   val = a
;   amt--;
; } while (amt != 0);
handle_opcode_rol__loop:
  clc
  ; c, a = rol1(val)
  ld r6
  ral
  ; val = a
  xch r6
  ; a = c
  tcc
  ; a += val
  add r6
  ; val = a
  xch r6
  ; amt--
  ld r7
  dac
  xch r7
  ; } while (amt != 0);
  ld r7
  jcn na handle_opcode_rol__loop
; save register back
ld r6
xch r0
ld r10
xch r1
jms store_vm_register
jun main_loop
; end handle_opcode_rol

; ld r1, loc
;   r1 = *loc
handle_opcode_ld:
; get the value at loc
ld r11
fim p0 bytecode_start
xch r1
src p0
rdm
; write to the register
xch r0
ld r10
xch r1
jms store_vm_register
jun main_loop
; end handle_opcode_ld

; xor r1, imm
handle_opcode_xori: 
; store reg number in r6
ld r10
xch r6
; get reg value
ld r10
jms load_vm_register
xch r0
xch r10
; get the two values into r0, r1, then call xor
ld r10
xch r0
ld r11
xch r1
jms xor
; now r0 holds the xored values, let's store it back in the register...
; leave the value in r0, put the register in r1, call store.
ld r6
xch r1
jms store_vm_register
jun main_loop
; end handle_opcode_xori

; stri imm0, r1
;   mem[imm0] = r1
handle_opcode_stri:
; get reg value
ld r11
jms load_vm_register
xch r0
xch r11
; put it at loc
fim p0 bytecode_start
ld r10
xch r1
src p0
ld r11
wrm
jun main_loop
; end handle_opcode_stri

; rst
;  ip = 0
handle_opcode_rst: 
fim p0 vm_pc
src p0
ldm 0
wrm
jun main_loop
; end handle_opcode_rst


; skipifneq r1, r2
;  if r1 != r2:
;      ip++
handle_opcode_skipifneq:
; get first reg value
ld r10
jms load_vm_register
xch r0
xch r10
; get second reg value
ld r11
jms load_vm_register
xch r0
xch r11
; if r1 != r2
ld r10
sub r11
jcn a handle_opcode_skipifneq__after
  ; ip++
  fim p0 vm_pc
  src p0
  rdm
  iac
  wrm
handle_opcode_skipifneq__after:
jun main_loop
; end handle_opcode_skipifneq


; add r1, imm0
;   r1 += imm0
handle_opcode_add:
ld r10
jms load_vm_register
ld r0
add r11
xch r0
ld r10
xch r1
jms store_vm_register
jun main_loop
; end handle_opcode_add


; Load vm register number (stored in acc) into r0
load_vm_register:
fim p0 vm_r0
xch r1
src p0
rdm
xch r0
bbl 0
; end load_vm_register

; write the vm register number (stored in r1) with the value in r0
store_vm_register:
fim p1 vm_r0
ld r1
xch r3
src p1
ld r0
wrm
bbl 0
; end store_vm_register


main:
; let them know we're ready to go. then cry a bit? i want to cry a bit.
fim p0 s_ready_to_go
jms puts


; load all programs into memory, along with their data:
; program 1 (bank 0)
ldm 0
dcl
fim p0 program_1
jms copy_program_1
fim p0 program_1_data
jms load_program_data
jms load_flag_chunk
; program 2 (bank 1)
ldm 1
dcl
fim p0 program_2
jms copy_program_1
fim p0 program_2_data
jms load_program_data
jms load_flag_chunk
; program 3 (bank 2)
ldm 2
dcl
fim p0 program_3
jms copy_program_1
fim p0 program_3_data
jms load_program_data
jms load_flag_chunk
; program 4 (bank 3)
ldm 3
dcl
fim p0 program_4
jms copy_program_1
fim p0 program_4_data
jms load_program_data
jms load_flag_chunk
; program 5 (bank 4)
ldm 4
dcl
fim p0 program_5
jms copy_program_2
fim p0 program_5_data
jms load_program_data
jms load_flag_chunk
; program 6 (bank 5)
ldm 5
dcl
fim p0 program_6
jms copy_program_2
fim p0 program_6_data
jms load_program_data
jms load_flag_chunk
; program 7 (bank 6)
ldm 6
dcl
fim p0 program_7
jms copy_program_2
fim p0 program_7_data
jms load_program_data
jms load_flag_chunk
; program 8 (bank 7)
ldm 7
dcl
fim p0 program_8
jms copy_program_2
fim p0 program_8_data
jms load_program_data
jms load_flag_chunk

; switch back to bank 0
ldm 0
dcl
jun main_loop

%pagealign ; finished was on a different page...
main_loop:
; check if we're done
jms all_states_done
jcn na finished

; fallthru to swtch
swtch:
; switch to the next ram bank
ld r15
dcl
inc r15
; dispatch to the appropriate opcode handler
; load the current state to r0
clc
fim p0 vm_pc
src p0
rdm
; now we have the pc in acc. Let's get the opcode by multiplying by 4.
; we don't need to add a base, because we base the bytecode at RAM addr 0
; shift p0 left by 2
fim p0 0 ; clear p0
clc      ; and carry
ral
xch r1
ral
xch r0
ld r1
ral
xch r1
xch r0
ral
xch r0
; now it's left shifted by 4.
; now we load the value at that address
; load opcode -> r9
src p0
rdm
xch r9
; load arg1 -> r10
inc r1
src p0
rdm
xch r10
; load arg2 -> r11
inc r1
src p0
rdm
xch r11
; load arg3 -> r12
inc r1
src p0
rdm
xch r12
; increment pc
fim p0 vm_pc
src p0
rdm
iac
wrm
; opcode *= 2
ld r9
ral
fim p0 0
xch r1
jun opcode_dispatch
; end swtch

finished:
jms check_all_correct
;asdf: jun asdf
jcn na yay_they_got_it

oh_no_they_didnt_get_it:
fim p0 s_incorrect_flag
jms puts
jun hhh

yay_they_got_it:
fim p0 s_correct_flag
jms puts

jun hhh
; we're done. just spin
hhh: jun hhh
; end finished

; memcpy between RAM pages
; p0 = dst page addr
; p1 = src page addr
; r4 = dst page number
; r5 = src page number
; p3 = num_bytes
; Leaves you on dst page
; clobbers acc, input registers (p0, p1, p2, p3), p4
; no return values
ram_memcpy:
ram_memcpy__loop:

; low byte of acc = 0?
ram_memcpy__loop__check_low:
ld r7
jcn a ram_memcpy_loop__check_high
jun ram_memcpy__loop__copy
; high bytes of acc = 0?
ram_memcpy_loop__check_high:
ld r6
; hi and low both = 0? then we're done
jcn a ram_memcpy__done

ram_memcpy__loop__copy:
; switch to src page
xch r5
dcl
xch r5
; grab src value
src p1
rdm
; switch to dst page
xch r4
dcl
xch r4
src p0
wrm

; decrement low. If low was 0, also decrement high.
fim p4 1 ; we'll use this to decrement
ram_memcpy__loop__dec_low:
clc
ld r7
sub r9
xch r7
jcn nc ram_memcpy__inc ; if we didn't set the carry, continue to the increments
ram_memcpy__loop__dec_high:
clc
ld r6
sub r9
xch r6
jcn c ram_memcpy__done ; if we set the carry, we hit 0! yay! we're done!

ram_memcpy__inc:
; inc src
ram_memcpy__loop__inc_src_low:
ld r3
iac 
xch r3
jcn nc ram_memcpy__loop__after_inc_src
ram_memcpy__loop__inc_src_high:
ld r2
iac
xch r2
ram_memcpy__loop__after_inc_src:

; inc dst
ram_memcpy__loop__inc_dst_low:
ld r1
iac 
xch r1
jcn nc ram_memcpy__loop__after_inc_dst
ram_memcpy__loop__inc_dst_high:
ld r0
iac
xch r0
ram_memcpy__loop__after_inc_dst:

jun ram_memcpy__loop

ram_memcpy__done:
bbl 0
; end ram_memcpy


%pagealign ; XXX: pagealign because we were page-misaligned in the function, this may be removable later

; check if all states are in the "done" state.
; clobbers p0, p1
; sets acc to whether we're done or not. (0 if we're not, 1 if we are)
all_states_done:
fim p1 0x8_0 ; r3 = current bank, r2 = constant 8 we'll use for subtracting

all_state_done__loop:
; switch banks
ld r3
dcl
; grab the value
fim p0 vm_ready_to_stop
src p0
rdm
; if our acc is 0, return a 0
jcn na all_state_done__check
bbl 0
all_state_done__check:
; advance
inc r3
ld r3
sub r2
jcn na all_state_done__loop ; if r3 != 8, loop again
; hey, we didn't early return! guess we're done running c:
bbl 1
; end all_states_done

; check if all vms have failed = 0. return in acc
check_all_correct:
fim p0 0x8_0

check_all_correct__loop:
  ; switch banks
  ld r3
  dcl
  ; get the failed value for this bank
  fim p0 vm_failed
  src p0
  rdm
  ; if our acc is 1, it means we've failed this vm. therefore, we can return a 0
  jcn a check_all_correct__check
    bbl 0
  check_all_correct__check:
  ; advance to the next bank
  inc r3
  ld r3
  sub r2
jcn na check_all_correct__loop ; if r3 != 8, loop again
; nothing failed? we're all right! return 1
bbl 1
; end check_all_correct

%pagealign
program_1:
%byte 0x04 0x61 ; fail r4, r10, 1
%byte 0x05 0x71 ; fail r5, r11, 1
%byte 0x01 0x81 ; fail r1, r7, 1
%byte 0x02 0x91 ; fail r2, r8, 1
%byte 0x03 0xa1 ; fail r3, r6, 1
%byte 0x00 0xb1 ; fail r0, r9, 1
%byte 0x00 0xf0 ; fail r0, r15, 0 (actually fail)
%byte 0x50 0x00 ; rst
%byte 0x00 0x00
%byte 0x00 0x00
%byte 0x00 0x00
%byte 0x00 0x00
%byte 0x00 0x00
%byte 0x00 0x00
%byte 0x00 0x00
%byte 0x00 0x00
program_2:
; xor_key = 0x51 0x1e 0x47
%byte 0x30 0x50 ; xori r0, 0x5
%byte 0x31 0x10 ; xori r1, 0x1
%byte 0x32 0x10 ; xori r2, 0x1
%byte 0x33 0xe0 ; xori r3, 0xe
%byte 0x34 0x40 ; xori r4, 0x4
%byte 0x35 0x70 ; xori r5, 0x7
%byte 0x00 0x61 ; fail r0, r6, 1
%byte 0x01 0x71 ; fail r1, r7, 1
%byte 0x02 0x81 ; fail r2, r8, 1
%byte 0x03 0x91 ; fail r3, r9, 1
%byte 0x04 0xa1 ; fail r4, r10, 1
%byte 0x05 0xb1 ; fail r5, r11, 1
%byte 0x00 0xf0 ; fail r0, r15, 0
%byte 0x50 0x00 ; rst
%byte 0x00 0x00
%byte 0x00 0x00
program_3:
%byte 0x00 0x61 ; fail r0, r6, 1
%byte 0x2c 0x62 ; ld r12, r6, r2 (used for constants)
%byte 0x2c 0x10 ; ld r12, 1
%byte 0x7c 0x10 ; add r12, 1
%byte 0x41 0xc0 ; stri 1, r12
%byte 0x2c 0x20 ; ld r12, 2
%byte 0x7c 0x10 ; add r12, 1
%byte 0x42 0xc0 ; stri 2, r12
%byte 0x2c 0x60 ; ld r12, 6
%byte 0x2d 0x10 ; ld r13, 1
%byte 0x6c 0xd0 ; skipifneq r12, r13
%byte 0x00 0xf0 ; fail r0, r15, 0
%byte 0x50 0x00 ; rst
%byte 0x00 0x00
%byte 0x00 0x00
%byte 0x00 0x00
program_4:
%byte 0x30 0x60 ; xori r0, 6
%byte 0x00 0x61 ; fail r0, r6, 1
%byte 0x2c 0x16 ; ld r12, 1  (xor reg, cmp first reg), with a 6 on the end for an imm
%byte 0x7c 0x10 ; add r12, 1
%byte 0x41 0xc0 ; stri 1, r12
%byte 0x45 0xc0 ; stri 5, r12
%byte 0x2d 0x60 ; ld r13, 6 (cmp second reg)
%byte 0x7d 0x10 ; add r13, 1
%byte 0x46 0xd0 ; stri 6, r13
%byte 0x2d 0xb0 ; ld r13, 11 (imm = 6)
%byte 0x6c 0xd0 ; skipifneq r12, r13
%byte 0x00 0xf0 ; fail r0, r15, 0
%byte 0x50 0x00 ; rst
%byte 0x00 0x00 
%byte 0x00 0x00 
%byte 0x00 0x00 

; copy a program, starting at p0 in ROM, into the current bank's bytecode buffer
; This is valid for programs 1 to 4 (for programs 5 to 8, use copy_program_2)
; src = p0
; clobbers p0, p1, p2, acc
; pseudocode:
; dst = bytecode_start
; repeat twice {
;   cnt = 0
;   do {
;     a,b = *src;
;     *dst = a;
;     dst++;
;     *dst = b;
;     dst++;
;     src++;
;   } while (++cnt != 0);
; }
copy_program_1:
; dst = bytecode_start
fim p1 bytecode_start

; vvv rep 1 vvv
; cnt = 0
fim p3 0
copy_program_1__loop_1:
; cnt = 0
; do {
; a, b = *src
fin p2 ; now r4 = a, r5 = b
; *dst = a
src p1 
ld r4
wrm
; dst++
xch r3
iac
xch r3
jcn nc copy_program_1__loop_1__inc_dst_1__after ; no carry, just go to the next
; ugh, we had a carry, let's increment high
xch r2
iac
xch r2
copy_program_1__loop_1__inc_dst_1__after:
; *dst = b
src p1
ld r5
wrm
; dst++ 
xch r3
iac
xch r3
jcn nc copy_program_1__loop_1__inc_dst_2__after ; no carry, just go to the next
; ugh, we had a carry, let's increment high
xch r2
iac
xch r2
copy_program_1__loop_1__inc_dst_2__after:
; src++
xch r1
iac
xch r1
jcn nc copy_program_1__loop_1__inc_src__after ; no carry, just go to the next
; ugh, we had a carry, let's increment high
xch r0
iac
xch r0
copy_program_1__loop_1__inc_src__after:
; while (++cnt != 0);
isz r6 copy_program_1__loop_1__end
jun copy_program_1__loop_1
copy_program_1__loop_1__end:
; ^^^ rep 1 ^^^

; vvv rep 2 vvv
; cnt = 0
fim p3 0
copy_program_1__loop_2:
; cnt = 0
; do {
; a, b = *src
fin p2 ; now r4 = a, r5 = b
; *dst = a
src p1 
ld r4
wrm
; dst++
xch r3
iac
xch r3
jcn nc copy_program_1__loop_2__inc_dst_1__after ; no carry, just go to the next
; ugh, we had a carry, let's increment high
xch r2
iac
xch r2
copy_program_1__loop_2__inc_dst_1__after:
; *dst = b
src p1
ld r5
wrm
; dst++ 
xch r3
iac
xch r3
jcn nc copy_program_1__loop_2__inc_dst_2__after ; no carry, just go to the next
; ugh, we had a carry, let's increment high
xch r2
iac
xch r2
copy_program_1__loop_2__inc_dst_2__after:
; src++
xch r1
iac
xch r1
jcn nc copy_program_1__loop_2__inc_src__after ; no carry, just go to the next
; ugh, we had a carry, let's increment high
xch r0
iac
xch r0
copy_program_1__loop_2__inc_src__after:
; while (++cnt != 0);
isz r6 copy_program_1__loop_2__end
jun copy_program_1__loop_2
copy_program_1__loop_2__end:
; ^^^ rep 2 ^^^


bbl 0
; end copy_program_1


%pagealign
program_5:
%byte 0x70 0x50 ; add r0, 0x5
%byte 0x71 0x10 ; add r1, 0x1
%byte 0x72 0x10 ; add r2, 0x1
%byte 0x73 0xe0 ; add r3, 0xe
%byte 0x74 0x40 ; add r4, 0x4
%byte 0x75 0x70 ; add r5, 0x7
%byte 0x00 0x61 ; fail r0, r6, 1
%byte 0x01 0x71 ; fail r1, r7, 1
%byte 0x02 0x81 ; fail r2, r8, 1
%byte 0x03 0x91 ; fail r3, r9, 1
%byte 0x04 0xa1 ; fail r4, r10, 1
%byte 0x05 0xb1 ; fail r5, r11, 1
%byte 0x00 0xf0 ; fail r0, r15, 0
%byte 0x50 0x00 ; rst
%byte 0x00 0x00
%byte 0x00 0x00
program_6:
%byte 0x70 0x60 ; add r0, 6
%byte 0x00 0x61 ; fail r0, r6, 1
%byte 0x2c 0x16 ; ld r12, 1  (xor reg, cmp first reg), with a 6 on the end for an imm
%byte 0x7c 0x10 ; add r12, 1
%byte 0x41 0xc0 ; stri 1, r12
%byte 0x45 0xc0 ; stri 5, r12
%byte 0x2d 0x60 ; ld r13, 6 (cmp second reg)
%byte 0x7d 0x10 ; add r13, 1
%byte 0x46 0xd0 ; stri 6, r13
%byte 0x2d 0xb0 ; ld r13, 11 (imm = 6)
%byte 0x6c 0xd0 ; skipifneq r12, r13
%byte 0x00 0xf0 ; fail r0, r15, 0
%byte 0x50 0x00 ; rst
%byte 0x00 0x00 
%byte 0x00 0x00 
%byte 0x00 0x00 
program_7:
%byte 0x10 0xf0 ; rol r0, 0xf
%byte 0x11 0xd0 ; rol r1, 0xd
%byte 0x12 0x70 ; rol r2, 0x7
%byte 0x13 0x60 ; rol r3, 0x6
%byte 0x14 0x40 ; rol r4, 0x4
%byte 0x15 0xb0 ; rol r5, 0xb
%byte 0x00 0x61 ; fail r0, r6, 1
%byte 0x01 0x71 ; fail r1, r7, 1
%byte 0x02 0x81 ; fail r2, r8, 1
%byte 0x03 0x91 ; fail r3, r9, 1
%byte 0x04 0xa1 ; fail r4, r10, 1
%byte 0x05 0xb1 ; fail r5, r11, 1
%byte 0x00 0xf0 ; fail r0, r15, 0
%byte 0x50 0x00 ; rst
%byte 0x00 0x00 
%byte 0x00 0x00 
program_8:
%byte 0x10 0x60 ; rol r0, 6
%byte 0x00 0x61 ; fail r0, r6, 1
%byte 0x2c 0x16 ; ld r12, 1  (xor reg, cmp first reg), with a 6 on the end for an imm
%byte 0x7c 0x10 ; add r12, 1
%byte 0x41 0xc0 ; stri 1, r12
%byte 0x45 0xc0 ; stri 5, r12
%byte 0x2d 0x60 ; ld r13, 6 (cmp second reg)
%byte 0x7d 0x10 ; add r13, 1
%byte 0x46 0xd0 ; stri 6, r13
%byte 0x2d 0xb0 ; ld r13, 11 (imm = 6)
%byte 0x6c 0xd0 ; skipifneq r12, r13
%byte 0x00 0xf0 ; fail r0, r15, 0
%byte 0x50 0x00 ; rst
%byte 0x00 0x00 
%byte 0x00 0x00 
%byte 0x00 0x00 

; copy a program, starting at p0 in ROM, into the current bank's bytecode buffer
; This is valid for programs 5 to 8 (for programs 1 to 4, use copy_program_1)
; src = p0
; clobbers p0, p1, p2, acc
; pseudocode:
; dst = bytecode_start
; repeat twice {
;   cnt = 0
;   do {
;     a,b = *src;
;     *dst = a;
;     dst++;
;     *dst = b;
;     dst++;
;     src++;
;   } while (++cnt != 0);
; }
copy_program_2:
; dst = bytecode_start
fim p1 bytecode_start

; vvv rep 1 vvv
; cnt = 0
fim p3 0
copy_program_2__loop_1:
; cnt = 0
; do {
; a, b = *src
fin p2 ; now r4 = a, r5 = b
; *dst = a
src p1 
ld r4
wrm
; dst++
xch r3
iac
xch r3
jcn nc copy_program_2__loop_1__inc_dst_1__after ; no carry, just go to the next
; ugh, we had a carry, let's increment high
xch r2
iac
xch r2
copy_program_2__loop_1__inc_dst_1__after:
; *dst = b
src p1
ld r5
wrm
; dst++ 
xch r3
iac
xch r3
jcn nc copy_program_2__loop_1__inc_dst_2__after ; no carry, just go to the next
; ugh, we had a carry, let's increment high
xch r2
iac
xch r2
copy_program_2__loop_1__inc_dst_2__after:
; src++
xch r1
iac
xch r1
jcn nc copy_program_2__loop_1__inc_src__after ; no carry, just go to the next
; ugh, we had a carry, let's increment high
xch r0
iac
xch r0
copy_program_2__loop_1__inc_src__after:
; while (++cnt != 0);
isz r6 copy_program_2__loop_1__end
jun copy_program_2__loop_1
copy_program_2__loop_1__end:
; ^^^ rep 1 ^^^

; vvv rep 2 vvv
; cnt = 0
fim p3 0
copy_program_2__loop_2:
; cnt = 0
; do {
; a, b = *src
fin p2 ; now r4 = a, r5 = b
; *dst = a
src p1 
ld r4
wrm
; dst++
xch r3
iac
xch r3
jcn nc copy_program_2__loop_2__inc_dst_1__after ; no carry, just go to the next
; ugh, we had a carry, let's increment high
xch r2
iac
xch r2
copy_program_2__loop_2__inc_dst_1__after:
; *dst = b
src p1
ld r5
wrm
; dst++ 
xch r3
iac
xch r3
jcn nc copy_program_2__loop_2__inc_dst_2__after ; no carry, just go to the next
; ugh, we had a carry, let's increment high
xch r2
iac
xch r2
copy_program_2__loop_2__inc_dst_2__after:
; src++
xch r1
iac
xch r1
jcn nc copy_program_2__loop_2__inc_src__after ; no carry, just go to the next
; ugh, we had a carry, let's increment high
xch r0
iac
xch r0
copy_program_2__loop_2__inc_src__after:
; while (++cnt != 0);
isz r6 copy_program_2__loop_2__end
jun copy_program_2__loop_2
copy_program_2__loop_2__end:
; ^^^ rep 2 ^^^

bbl 0
; end copy_program_2


%pagealign
program_1_data:
%byte 0x61 0x66 0xc6 ; this one is simple: just 'fla', but scrambled a bit
program_2_data:
%byte 0x36 0x65 0x2e ; b'g{i' ^ xor_key1
program_3_data:
%byte 0x6e 0x74 0x6c ; b'ntl'
program_4_data:
%byte 0x39 0x05 0x16 ; b'_cp' xored with 6,7,...10,11
%nibblealign ; make sure we stay aligned so we don't need to do annoying math
program_5_data:
%byte 0xc6 0x81 0x96 ; b'us_' + add_key
program_6_data:
%byte 0xd9 0xc9 0xc7 ; b'sca' + add_key
program_7_data:
%byte 0xb4 0x35 0x5f ; b're_' + rol_key
program_8_data:
%byte 0x97 0x95 0xd7

; load the program data (program_X_data above) starting at p0 into the current
; bank's program data registers. assume it clobbers any registers
; p0 better be nibble-aligned thx
load_program_data:

; byte 0:
fin p1
; nibble 0
fim p2 vm_r6
src p2
ld r2
wrm
; nibble 1
fim p2 vm_r7
src p2
ld r3
wrm
; inc
inc r1

; byte 1:
fin p1
; nibble 0
fim p2 vm_r8
src p2
ld r2
wrm
; nibble 1
fim p2 vm_r9
src p2
ld r3
wrm
; inc
inc r1

; byte 2:
fin p1
; nibble 0
fim p2 vm_r10
src p2
ld r2
wrm
; nibble 1
fim p2 vm_r11
src p2
ld r3
wrm

bbl 0
; end load_program_data

; load a chunk (3 characters) from stdin into the first 6 registers of the
; current bank's vm
load_flag_chunk:

; nibble 0:
rdr
fim p0 vm_r0
src p0
wrm
; nibble 1:
rdr
fim p0 vm_r1
src p0
wrm
; nibble 2:
rdr
fim p0 vm_r2
src p0
wrm
; nibble 3:
rdr
fim p0 vm_r3
src p0
wrm
; nibble 4:
rdr
fim p0 vm_r4
src p0
wrm
; nibble 5:
rdr
fim p0 vm_r5
src p0
wrm

bbl 0
; end load_flag_chunk

%pagealign
; you have basically < 220 bytes or so of string data here.
;
; because of the way i wrote my assembler, capital letters and colons
; dont work in strings without escaping them. Oops.
s_ready_to_go:
%str "welcome, enter the flag\x3a" 
s_correct_flag:
%str "correct flag!"
s_incorrect_flag:
%str "incorrect flag \x3a("

; put a nul-terminated string to stdout, followed by a newline
puts:

puts__loop:
fin p1
; test if p1 == 0, if so we're done
ld r2
jcn na puts__can_print
ld r3
jcn a puts__done

puts__can_print:
ld r2
wrr
ld r3
wrr

; s++
isz r1 puts__also_inc_r0
jun puts__after_inc
puts__also_inc_r0: inc r0
puts__after_inc:

jun puts__loop
puts__done:
; newline
fim p1 0x0a
ld r2
wrr
ld r3
wrr
bbl 0
; end puts


%pagealign
; jump to the correct entry in the dispatch table
; we can do this without any fancy math on the dispatch table because we're
; PAGE ALIGNED -- because the jin below (`state_dispatch`) is on
; the same page as us, it dispatches to one of these.
; these must all, obviously, be 2-bytes long, preferably juns
opcode_dispatch_table:
dispatch_entry_0:  jun handle_opcode_fail
dispatch_entry_1:  jun handle_opcode_rol
dispatch_entry_2:  jun handle_opcode_ld
dispatch_entry_3:  jun handle_opcode_xori
dispatch_entry_4:  jun handle_opcode_stri
dispatch_entry_5:  jun handle_opcode_rst
dispatch_entry_6:  jun handle_opcode_skipifneq
dispatch_entry_7:  jun handle_opcode_add
; dispatch to the appropriate jump table 
opcode_dispatch: jin p0


; from page 107 of the MCS-4 Assembly Language Programming Manual
; r0 = r0 ^ r1
xor:
fim p1 11
xor__L1:
ldm 0
xch r0
ral
xch r0
inc r3
xch r3
jcn a xor__L2
xch r3
rar
xch r2
ldm 0
xch r1
ral
xch r1
rar
add r2
ral 
jun xor__L1
xor__L2:
bbl 0
; end xor



; ======= MEMORY LAYOUT ======= 
; Each RAM bank looks roughly the same. Here's space to assign all locations:
%let bytecode_start = 0 ; important that this is page aligned
; all things in this range are bytecode
%let bytecode_end = 63
; 64    = 
; 65    = 
; 66    = 
; 67    = 
; 68    = 
; 69    = 
; 70    = 
; 71    = 
; 72    = 
; 73    = 
; 74    = 
; 75    = 
; 76    = 
; 77    = 
; 78    = 
; 79    = 
; 80    = 
; 81    = 
; 82    = 
; 83    = 
; 84    = 
; 85    = 
; 86    = 
; 87    = 
; 88    = 
; 89    = 
; 90    = 
; 91    = 
; 92    = 
; 93    = 
; 94    = 
; 95    = 
; 96    = 
; 97    = 
; 98    = 
; 99    = 
; 100   = 
; 101   = 
; 102   = 
; 103   = 
; 104   = 
; 105   = 
; 106   = 
; 107   = 
; 108   = 
; 109   = 
; 110   = 
; 111   = 
; 112   = 
; 113   = 
; 114   = 
; 115   = 
; 116   = 
; 117   = 
; 118   = 
; 119   = 
; 120   = 
; 121   = 
; 122   = 
; 123   = 
; 124   = 
; 125   = 
; 126   = 
; 127   = 
; 128   = 
; 129   = 
; 130   = 
; 131   = 
; 132   = 
; 133   = 
; 134   = 
; 135   = 
; 136   = 
; 137   = 
; 138   = 
; 139   = 
; 140   = 
; 141   = 
; 142   = 
; 143   = 
; 144   = 
; 145   = 
; 146   = 
; 147   = 
; 148   = 
; 149   = 
; 150   = 
; 151   = 
; 152   = 
; 153   = 
; 154   = 
; 155   = 
; 156   = 
%let vm_failed = 157 ; boolean indicating whether we've "failed"
%let vm_ready_to_stop = 158 ; boolean indicating whether we're this vm has become "done"
%let vm_pc = 159
%let vm_r0 = 160 ; importantly, the low nibbles of this is 0, so we can just add the register number
%let vm_r1 = 161
%let vm_r2 = 162
%let vm_r3 = 163
%let vm_r4 = 164
%let vm_r5 = 165
%let vm_r6 = 166
%let vm_r7 = 167
%let vm_r8 = 168
%let vm_r9 = 169
%let vm_r10 = 170
%let vm_r11 = 171
%let vm_r12 = 172
%let vm_r13 = 173
%let vm_r14 = 174
%let vm_r15 = 175
; 176   = 
; 177   = 
; 178   = 
; 179   = 
; 180   = 
; 181   = 
; 182   = 
; 183   = 
; 184   = 
; 185   = 
; 186   = 
; 187   = 
; 188   = 
; 189   = 
; 190   = 
; 191   = 
; 192   = 
; 193   = 
; 194   = 
; 195   = 
; 196   = 
; 197   = 
; 198   = 
; 199   = 
; 200   = 
; 201   = 
; 202   = 
; 203   = 
; 204   = 
; 205   = 
; 206   = 
; 207   = 
; 208   = 
; 209   = 
; 210   = 
; 211   = 
; 212   = 
; 213   = 
; 214   = 
; 215   = 
; 216   = 
; 217   = 
; 218   = 
; 219   = 
; 220   = 
; 221   = 
; 222   = 
; 223   = 
; 224   = 
; 225   = 
; 226   = 
; 227   = 
; 228   = 
; 229   = 
; 230   = 
; 231   = 
; 232   = 
; 233   = 
; 234   = 
; 235   = 
; 236   = 
; 237   = 
; 238   = 
; 239   = 
; 240   = 
; 241   = 
; 242   = 
; 243   = 
; 244   = 
; 245   = 
; 246   = 
; 247   = 
; 248   = 
; 249   = 
; 250   = 
; 251   = 
; 252   = 
; 253   = 
; 254   = 
; 255   = 
