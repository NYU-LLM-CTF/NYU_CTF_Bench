# Obfuscation

> Category: rev
> Suggested Points: 500

# Description
> Detailed description as it would need to be explained to other lab members

The goal of this challenge is to reverse this highly obfuscated binary and get the correct passphrase

# Deployment
> Any special information about the deployment if there is a server component

Use the Dockerfile for the deployment

# Flag
`csawctf{5h0u70u7_70_@53hn40u1_f0r_7h3_r1ck_457l3y_p4r4d0x}`

# Solution
> As detailed as possible description of the solution. Not just the solver script. As full a description as possible of the solution for the challenge.

The idea here is that the script does three rounds of substitution of the input buffer with its own internal S box. After that, it takes the first 4 characters of the newly substituted code and uses that as the seed for the randomization. Then, it does a one-time pad using this newly initialized random number generator.

### Step 1
Use the file command to determine if the binary is statically or dinamically linked. If the stripped binary is dinamically linked we still have external symbols from glibc.

### Step 2
Run the binary to try to get an idea of inputs and outputs.

### Step 3
Open the binary file in Ghidra or Binja. Identify the main function and use taint analysis to determine how the input is processed. The stripped binary is dynamically linked and we can start looking for glibc functions that take user input like fgets. 
When we find fgets we can get the name of the input buffer and its size and we follow the buffer to determine how the input is processed.

## Step 4
Look in the BSS for uninitialized global variables and follow the REFs to find the functions that initialize those variables. This will lead you to the translation table.

## Step 5
Also in main we can determine the expected result of processing the input. If the result of processing the input is zero we get an error message, if it's not zero we see calls to fopen, fseek, fread, fclose and print which could be the program opening a file, like the flag file, reading it and printing its contents.

## Step 6
Now we can try to understand how the input is processed, knowing that we need it to return a value different than zero.
We can use the GOT section to find other interesting functions used in the program besides printf and fgets, like srand, rand, strtol and strncpy and find the part of the code that calls those functions.


## Step 7
At this point we need to switch to dynamic analysis. Add breakpoints in the functions found in the previous step (srand, rand, strtol and strncpy). Use the values in the registers to determine the arguments and return values.


# NOTES
- I recommend to only give out the following hint to any of the player's questions --> "Doing only static reversing will be very painful for this challenge"