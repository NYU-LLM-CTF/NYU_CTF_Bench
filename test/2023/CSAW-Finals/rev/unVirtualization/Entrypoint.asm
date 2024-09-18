section .text

global pivot
global main
extern _main

pivot:
    ; Call the true_main function
    jmp _main
    ret

main:
    ; Jump to the pivot function
    jmp pivot

section .data

; You can define any necessary data in the .data section if needed.

section .bss

; You can define uninitialized data in the .bss section if needed.