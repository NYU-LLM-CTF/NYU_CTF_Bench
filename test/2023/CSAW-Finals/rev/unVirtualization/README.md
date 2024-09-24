# X86 Challenge

read the assembly and get the flag

# Solution

read the assembly and get the flag

# Compilation commands

```bash
nasm -f elf64 pseudocode.asm -o pseudocode.o
nasm -f elf64 Entrypoint.asm -o Entrypoint.o
gcc -fstack-protector -nostartfiles -z now -z relro -z noexecstack -o prog Entrypoint.o pseudocode.o -T linker.ld
strip prog



```
