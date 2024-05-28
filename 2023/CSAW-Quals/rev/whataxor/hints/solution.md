Here is the solution to this CTF:

- Decompile the main function from the `whataxor` binary
- Identify the array containing the obfuscated flag and extract its contents
- XOR the entire array with 0xAA to obtain the flag
