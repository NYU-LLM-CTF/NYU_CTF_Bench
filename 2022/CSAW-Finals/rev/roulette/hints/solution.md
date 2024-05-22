Here is the solution to this CTF:

- Decompile the provided `chall.class` java file to obtain the source code
- Figure out that the java Random class is used for random number generation
- Implement the random number generator in your script
- Use it to find the random seed from the initial player IP values
- Figure out the amount of expenditure required to get to 20 green rolls
- Implement the script to send the correct values and get the flag
