
# Control

Developed for CSAW CTF Finals 2021 by hgarrereyn.

## Overview

This is a VM-style challenge: `control` runs bytecode specified in `control.bin`. The catch is that there are no opcodes, bits in the instructions map 1:1 onto cpu control lines (write register to bus, read register from bus, write RAM, read RAM, etc...).

Run `make` to build the challenge and `make release` to build the `release` directory.

## Architecture

The VM is a simple, harvard architecture with 4 x general purpose 32-bit registers, one 32-bit stack register and an integer ALU. Each memory index addresses a 32-bit word (not a byte).

There are no predefined instructions, rather, the assembler emits an array of control flags which in turn act as instructions. For example, the `add` psuedo-instruction is implemented in three clock cycles with the following control flags:

```py
(REG_{dst}_W_DATA | ALU_R_X | IP_ADD_1),
(REG_{dst2}_W_DATA | ALU_R_Y | IP_ADD_1),
(ALU_ADD | REG_{dst}_R_DATA | IP_ADD_1)
```

1. Load register A into ALU_X
2. Load register B into ALU_Y
3. Write back ALU result into register A

Reversing this architecture requires reconstructing the high-level operations from the array of micro-ops.

## Implementation

The VM is implemented in `control.c` and the assembler is implemented in `assembler.py`. The main flag-checker program is written in assembly language in `main.asm`.

## Flag program

The flag-checker program reads in the flag, does some basic flag format checks (length, prefix, suffix). Then it checks each consecutive 8-byte inside the `flag{}` wrapper and performs a some simple hand-rolled bitwise cipher to compare it to a static "encoded flag". This cipher can be reversed with z3 and a reference solution is provided in `solve.py`.
