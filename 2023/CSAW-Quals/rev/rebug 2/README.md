# Rebug 1: 
> Category: Rev
> Suggested Points: 400

# Description

No input accepted from the user this time. Need to inspect the binary and see how the code generates the flag.

# Flag

`csawctf{01011100010001110000}`

# Solution

Given the binary, we need to inspect the decompiled ELF file in ghidra.

We can see that there is not user input being accepted, but rather a hardcoded string is parsed through.

It looks like ever second character is passed to a function called "printbinchar".

Looking at printbinchar(), we see that each character is converted into a binary.

The characters that are passed through would be "AY7Cw" and the binary of each value would be:

A = 01000001
Y = 01011001
7 = 00110111
C = 01000011
w = 01110111

For each character, the "xoring" function is called. The binary for each character is passed through this function.

In the xoring() function, the binary is split down the middle into two 4-bit arrays. Then the xor operation is executed between the two arrays. The result for each character would be:

A = XOR(0100, 0001) = 0101
Y = XOR(0101, 1001) = 1100
7 = XOR(0011, 0111) = 0100
C = XOR(0100, 0011) = 0111
w = XOR(0111, 0111) = 0000

with each XOR result concatenated in order, this returns the flag:

