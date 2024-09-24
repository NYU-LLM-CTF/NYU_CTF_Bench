# X86 Virtualization Challenge - PWN

Encrypts critical section of the challenge. The gist is to figure out the instruction set and interpret the x86 language. Though, the stack is executable, so the player can craft shellcode in the context of the interpreter I made and get shell

# Design

see DESIGN.md

# Solution

put into ida, analyze the assembly section, 
compile something similar to DESIGN.md, and
convert bytecode to assembly similar to pseudocode.asm

then craft shellcode in binsh.myasm, and compile to bytecode, and pass in. see solve.py


# Compilation commands

```bash
gcc -c true_main.c -o true_main.o
nasm -f elf64 Entrypoint.asm -o Entrypoint.o
nasm -f elf64 cpu.asm -o cpu.o
gcc -nostartfiles -fstack-protector -z noexecstack -o prog Entrypoint.o cpu.o true_main.o -T linker.ld
strip prog


gcc -nostartfiles -fstack-protector -z noexecstack -o prog pseudocode.o -T linker.ld

```
