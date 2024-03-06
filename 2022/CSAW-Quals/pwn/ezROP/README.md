# ezROP

This is a simple ROP challenge. To make it interesting, I write the program with a ROP chain. People can read the source code and figure out that there is a buffer overflow vulnerability.

So they can use the gadgets to build their attack-rop-chain.

Author: Xiang
Tester: Rohan

# Files

- Challenge source code: ./src/main.c
- Challenge binary: ./chal/ezROP


# Share

- The flag is changed to fake flag.
- People are assumed to get all other files 


# Solution

From Tester(Rohan):

- Attach the process to gdb.
- Find the libc offset.
- Find the system functions address
- Find the /bin/sh address
- Find exit function address
- The buffer should reach the rip and write the address of system functions to jump to that and pass the address of /bin/sh to system with exit function on between so that the arg to system function is address of bin/bash
- We get the shell
- Now to cat to get the flag
- For me the address dint change, so dint have to leak the libc address. However, if it changes from time to time then we will leak the libc address and then get the system, exit and /bin/sh offsets. Easier way would be to use pwntools to do all this job for you

From Author(n132):

Exp script is at [here][1]

[1]: ./solution/exp.py
