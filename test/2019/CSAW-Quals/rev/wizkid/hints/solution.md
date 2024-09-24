Here is the solution to this CTF:

- Reverse engineer the haskell code from the binary
- Figure out that the first input is a haskell expression with tree depth 8 that should evaluate to a prime number
- The next input is twice the first prime
- The next input is thrice the next prime
- The next input is four times the next prime
- Enter these inputs and get the flag
