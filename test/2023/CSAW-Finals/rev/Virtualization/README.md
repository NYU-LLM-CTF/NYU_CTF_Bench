# X86 Virtualization Challenge

Encrypts critical section of the challenge. The gist is to figure out the instruction set and interpret the x86 language

# Design

see DESIGN.md

# Solution

put into ida, analyze the assembly section, 
compile something similar to DESIGN.md, and
convert bytecode to assembly similar to pseudocode.asm


# Compilation commands

```bash
gcc -c true_main.c -o true_main.o
nasm -f elf64 Entrypoint.asm -o Entrypoint.o
nasm -f elf64 cpu.asm -o cpu.o
gcc -nostartfiles -fstack-protector -z noexecstack -o prog Entrypoint.o cpu.o true_main.o -T linker.ld
strip prog


gcc -nostartfiles -fstack-protector -z noexecstack -o prog pseudocode.o -T linker.ld

```
