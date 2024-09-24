This is the solution for this CTF:

- Decompile the `main`, `printbinchar`, and `xoring` functions
- Find the char array represented as two numbers
- Reconstruct the char array from these numbers
- Replicate the `printbinchar` function and run it on the char array
- Replicate the `xoring` function and run it on the result
- The binary output obtained is the flag
