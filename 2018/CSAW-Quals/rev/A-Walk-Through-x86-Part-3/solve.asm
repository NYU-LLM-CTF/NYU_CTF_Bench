bits 64

mov edi, 0x00b8000 ; Graphics Buffer

call get_ip
mov rsi, rax
add rsi, 2

xor rax, rax
mov rbx, 0x001f001f001f001f
xor rdx, rdx
print_loop:
  cmp rax, rbx
  je .end

  mov r15, working_buf
  mov rcx, 4
  
  .fill_buf:
    mov al, [rsi]
    mov byte [r15], al
    inc r15
    mov byte [r15], 0x1f
    inc r15
    inc rsi
    loop .fill_buf

  mov r15, working_buf
  mov rax, [r15]
  mov [rdi], rax
  add rdi, 8

  jmp print_loop

.end:
  jmp .end

working_buf:
  dq 0; Flag Buffer

get_ip:
  call next_line
  next_line:
  pop rax
ret

; This complies to:
; bf00800b00e85f0000004889c64883c6024831c048bb1f001f001f001f004831d24839d8743949bf3762000000000000b9040000008a0641880749ffc741c6071f49ffc748ffc6e2ec49bf3762000000000000498b074889074883c708ebc2ebfe0000000000000000e80000000058c3
