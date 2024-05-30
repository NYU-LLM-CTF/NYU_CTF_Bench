format ELF64 executable
segment readable executable

entry _start

use64
_start:
  jmp actual_start;
clear_regs:
  xor rax, rax;
  xor rbx, rbx;
  xor rcx, rcx;
  xor rdx, rdx;
  xor rsi, rsi;
  xor rdi, rdi;
  xor rbp, rbp;
  xor r8, r8;
  xor r9, r9;
  xor r10, r10;
  xor r11, r11;
  xor r12, r12;
  xor r13, r13;
  xor r14, r14;
  xor r15, r15;
  ret;
print_yeet:
  mov rcx, 0x0a74656579
  push rcx;
  push rsp;
  pop rsi;
  mov edi, 1;
  or dx, 5;
  xor al, 1;
  syscall;
  pop rax;
  pop rax;
  add rax, 3;
  jmp rax;
  
actual_start:
  call clear_regs;
  push rsp;
  pop rdi;
  not rax;
  mov al, 0;
  mov ah, 0xF1;
  and rdi, rax;
  mov rax, 0;
  or al, 0xa;
  mov si, 0x1000;
  mov edx, 7;
  push rdi;
  syscall;
  call clear_regs;
  call $+5
  test rax, rax;
  jz print_yeet;
  pop rdi;
  mov rcx, 0x1000;
  mov al, 0;
  rep stosb;
  call $+5
  pop rax;
  add rax, 0xa;
  test rbx, rbx;
  jz push_stage;
  jmp rsp;
push_stage:
; pushing shellcode
  mov rbx, 0xff31480c0cc03148;
  push rbx;
  mov rbx, 0x050f;
  push rbx; //syscall this will get the program break
  
  jmp rax;
exit:
  mov rax, 60
  xor  rsi, rsi;
  syscall;

