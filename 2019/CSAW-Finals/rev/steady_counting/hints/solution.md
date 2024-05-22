Here is the solution to this CTF:

- Disassemble the starting part of `main` function in the `counting` binary using radare2
- See that the flag is loaded at address `0x60f0e0`
- Check the references of successive bytes from 0x60f0e0 to see how the bytes are checked
- Filter out the `sub cl` functions used to check each byte and reconstruct the flag from the subtracted value
