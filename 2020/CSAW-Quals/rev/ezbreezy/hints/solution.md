Here is the solution to this CTF:

- Analyze the binary `app` and find the weird looking section `.aj1ishudgqis`
- Disassemble this section with radare2 and see that it writes byte values on the stack
- The byte values make up the flag but they are obfuscated with a shift cipher of 40
- Undo the shift cipher and print the flag
