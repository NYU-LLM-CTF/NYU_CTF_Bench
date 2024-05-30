org 7C00h
bits 16

%define LOAD_ADDR 0x6000

_start:
  cli

  xor ax, ax
  mov bx, ax
  mov cx, ax
  mov dx, ax

  mov ds, ax
  mov es, bx
  mov fs, cx
  mov gs, dx
  mov ss, ax

  mov sp, cx
  mov bp, dx
  mov si, sp
  mov di, bp

  mov ax, 0x0003
  int 0x10

  mov ax, .string_to_print
  jmp print_string
  .string_to_print: db "tacOS", 0x0a, 0x0d, "  by Elyk", 0x00 

print_string:
  .init:
    mov si, ax

  .print_char_loop:
    cmp byte [si], 0
    je .end

    mov al, [si]
    mov ah, 0x0e
    int 0x10

    inc si
    jmp .print_char_loop
    .end:

print_string_right:
  jmp .past_data 
  .important_string_to_print: db "lol kek ", 0
  .past_data:

  mov bp, .important_string_to_print 
  mov dh, 3
  mov dl, 15
  mov cx, 0x0007
  mov bx, 0000000000001111b

  mov ax, 0x1301
  int 0x10

load_second_stage:
  mov si, daps
  mov ah, 0x42
  mov dl, 0x80
  int 0x13

  jmp stack_example

newline: 
  db 0x0d, 0x0a
print_buf:
  resb 5
  db ' ', 0
print_rax:
  lea si, [print_buf + 4]      

  mov di, si                   
  mov bx, 10                   

  .div_loop:
    xor dx, dx                   
    div bx                       
    add dx, 0x30                 
    mov byte [si], dl            
    dec si                       
    cmp ax, 0                    
    jz .check_buf
    jmp .div_loop

  .check_buf:
    cmp si, di                   
    jne .print_buf
    mov byte [si], '0'           
    dec si

  .print_buf:
    inc si
    .print_char_loop:
      cmp byte [si], 0          
      je .end

      push cx
        push dx
          push ax
            xor cx, cx
            mov dx, 0xffff
            mov ah, 0x86
            int 0x15
          pop ax
        pop dx
      pop cx

      mov al, [si]              

      mov ah, 0x0e               
      int 0x10
  
      inc si
      jmp .print_char_loop
.end:
ret

print_info:
  mov ax, bp 
  call print_rax
  mov ax, sp
  call print_rax
ret

stack_example:
  mov ax, 1
  push ax 
    call print_rax 
    call print_info 

      mov ax, 2
      push ax
        call print_rax
        call print_info 

        mov ax, 3
        push ax
          call print_rax 
          call print_info 

          mov ax, 4
          push ax
            call print_rax
            call print_info

            mov ax, 5
            push ax
              call print_rax
              call print_info

          pop ax 
          call print_rax
          call print_info 

        pop ax
        call print_rax
        call print_info

      pop ax
      call print_rax
      call print_info 

    pop ax
    call print_rax
    call print_info 

  pop ax
  call print_rax
  call print_info

end:
  mov ax, LOAD_ADDR + 1
  jmp ax

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;       Data Section     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
align 16

; disk address packet structure
daps:
  .size:             db 0x10
  db 0
  .num_sectors:      dw NUM_SECTORS
  .transfer_buffer:  dd LOAD_ADDR
  .lba_lower:        dd 0x1
  .lba_upper:        dd 0x0

times 0200h - 2 - ($ - $$)  db 0   
dw 0AA55h
