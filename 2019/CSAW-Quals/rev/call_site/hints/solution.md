Here is the solution to this CTF:

- Decompile the main function to understand the function pointer input
- Search the strings in the binary and see where "flag.txt" is referenced
- This is the `win` function, this address needs to be passed in the <addr> argument
- To find the key, see that the linux `crypt` function is used to hash the input password with salt "aa"
- Use John-the-ripper tool to crack the password hash and obtain the plaintext password
- Send the address and password arguments to the server and get the flag
