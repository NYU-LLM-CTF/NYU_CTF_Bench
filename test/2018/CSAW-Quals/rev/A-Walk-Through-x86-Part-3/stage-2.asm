bits 16
org 0x6000

hlt
                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
main:
  .a_20:
    in al, 0x92
    or al, 2
    out 0x92, al

  .init:
    xor ax, ax
    ; Set up segment registers.
    mov ss, ax
    ; Set up stack so that it starts below Main.
    mov sp, main

    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    cld

    mov edi, 0
    jmp SwitchToLongMode

%define PAGE_PRESENT    (1 << 0)
%define PAGE_WRITE      (1 << 1)

%define CODE_SEG     0x0008
%define DATA_SEG     0x0010

ALIGN 4
; Interupt Descriptor Table
IDT:
  .Length       dw 0
  .Base         dd 0

SwitchToLongMode:
  ; Zero out the 16KiB buffer.
  ; Since we are doing a rep stosd, count should be bytes/4.   
  push di                           ; REP STOSD alters DI.
    mov ecx, 0x1000
    xor eax, eax
    cld
    rep stosd
  pop di                            ; Get DI back.

  ; Build the Page Map Level 4.
  ; es:di points to the Page Map Level 4 table.
  lea eax, [es:di + 0x1000]         ; Put the address of the Page Directory Pointer Table in to EAX.
  or eax, PAGE_PRESENT | PAGE_WRITE ; Or EAX with the flags - present flag, writable flag.
  mov [es:di], eax                  ; Store the value of EAX as the first PML4E.

  ; Build the Page Directory Pointer Table.
  lea eax, [es:di + 0x2000]         ; Put the address of the Page Directory in to EAX.
  or eax, PAGE_PRESENT | PAGE_WRITE ; Or EAX with the flags - present flag, writable flag.
  mov [es:di + 0x1000], eax         ; Store the value of EAX as the first PDPTE.

  ; Build the Page Directory.
  lea eax, [es:di + 0x3000]         ; Put the address of the Page Table in to EAX.
  or eax, PAGE_PRESENT | PAGE_WRITE ; Or EAX with the flags - present flag, writeable flag.
  mov [es:di + 0x2000], eax         ; Store to value of EAX as the first PDE.

  push di                           ; Save DI for the time being.
  lea di, [di + 0x3000]             ; Point DI to the page table.
  mov eax, PAGE_PRESENT | PAGE_WRITE    ; Move the flags into EAX - and point it to 0x0000.

  ; Build the Page Table.
  .LoopPageTable:
    mov [es:di], eax
    add eax, 0x1000
    add di, 8
    cmp eax, 0x200000                 ; If we did all 2MiB, end.
    jb .LoopPageTable

  pop di                            ; Restore DI.

  ; Disable IRQs
  mov al, 0xFF                      ; Out 0xFF to 0xA1 and 0x21 to disable all IRQs.
  out 0xA1, al
  out 0x21, al
 
  nop
  nop

  lidt [IDT]                        ; Load a zero length IDT so that any NMI causes a triple fault.

  ; Enter long mode.
  mov eax, 10100000b                ; Set the PAE and PGE bit.
  mov cr4, eax

  mov edx, edi                      ; Point CR3 at the PML4.
  mov cr3, edx

  mov ecx, 0xC0000080               ; Read from the EFER MSR. 
  rdmsr
  or eax, 0x00000100                ; Set the LME bit.
  wrmsr

  mov ebx, cr0                      ; Activate long mode
  or ebx,0x80000001                 ; - by enabling paging and protection simultaneously.
  mov cr0, ebx

  lgdt [GDT.Pointer]                ; Load GDT.Pointer defined below.

  jmp CODE_SEG:LongMode             ; Load CS with 64 bit segment and flush the instruction cache

; Global Descriptor Table
GDT:
.Null:
  dq 0x0000000000000000             ; Null Descriptor - should be present.
.Code:
  dq 0x00209A0000000000             ; 64-bit code descriptor (exec/read).
  dq 0x0000920000000000             ; 64-bit data descriptor (read/write).
ALIGN 4
  dw 0                              ; Padding to make the "address of the GDT" field aligned on a 4-byte boundary
.Pointer:
  dw $ - GDT - 1                    ; 16-bit Size (Limit) of GDT.
  dd GDT                            ; 32-bit Base Address of GDT. (CPU will zero extend to 64-bit)

flag:
  db 0xa5, 0x1f, 0xb1, 0x1f, 0xab, 0x1f, 0xa7, 0x1f, 0x9f, 0x1f, 0x9, 0x1f, 0xb5, 0x1f, 0xa3, 0x1f, 0xd7, 0x1f, 0x8f, 0x1f, 0xb3, 0x1f, 0x1, 0x1f, 0xb, 0x1f, 0xb, 0x1f, 0xd7, 0x1f, 0xfd, 0x1f, 0xf3, 0x1f, 0xc9, 0x1f, 0xd7, 0x1f, 0xa5, 0x1f, 0xb7, 0x1f, 0x8d, 0x1f, 0xd7, 0x1f, 0x99, 0x1f, 0x19, 0x1f, 0x5, 0x1f, 0xd7, 0x1f, 0xb7, 0x1f, 0xb5, 0x1f, 0xf, 0x1f, 0xd7, 0x1f, 0xb3, 0x1f, 0x1, 0x1f, 0x8f, 0x1f, 0x8f, 0x1f, 0xb, 0x1f, 0x85, 0x1f, 0xa3, 0x1f, 0xd7, 0x1f, 0xb, 0x1f, 0xa3, 0x1f, 0xab, 0x1f, 0x89, 0x1f, 0xd7, 0x1f, 0x1, 0x1f, 0xd7, 0x1f, 0xdb, 0x1f, 0x9, 0x1f, 0xc3, 0x1f, 0x93, 0x1f
  dd 0x00  ; Allign with 8 bytes
  dq 0x00  ; Null-quadword terminated string because why tf not

bits 64
LongMode:
  mov ax, DATA_SEG
  mov ds, ax
  mov es, ax
  mov fs, ax
  mov gs, ax
  mov ss, ax

  ; Blank out the screen to a blue color.
  mov edi, 0xB8000
  mov rcx, 500                      ; Since we are clearing uint64_t over here, we put the count as Count/4.
  mov rax, 0x1F201F201F201F20       ; Set the value to set the screen to: Blue background, white foreground, blank spaces.
  rep stosq                         ; Clear the entire screen. 

  mov edi, 0x00b8000 ; Graphics Buffer

  xor rax, rax
  xor rbx, rbx
  xor rcx, rcx
  xor rdx, rdx

  mov dl, 'E'
  or  dl, 'l'
  mov dh, 'y'
  or  dh, 'k'
  and dl, dh
  mov dh, 0

  mov rsi, flag
  .print_loop:
    cmp qword [rsi+rax], 0
    je .end

    mov rcx, 4
    .dec_loop:
      mov bl, [rsi+rax]
      xor bl, dl
      shr bl, 1
      mov [rsi+rax], bl
      add rax, 2
    loop .dec_loop
    sub rax, 8

    mov rcx, [rsi+rax]
    mov [rdi+rax], rcx

    add rax, 8
    jmp .print_loop

  .end:
