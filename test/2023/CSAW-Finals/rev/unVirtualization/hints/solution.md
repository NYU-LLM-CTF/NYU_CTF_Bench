Here is the solution to this CTF:

- Disassemble the `prog` binary using radare2
- Identify that the input is being XORed with a constant and compared with another constant
- Extract the two constant arrays and XOR them to obtain the flag
