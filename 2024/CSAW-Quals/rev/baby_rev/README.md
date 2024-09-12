# Baby Rev

> csawctf{1s_n3v3r_w1s3_t0_pr073c7_s3ns171v3_1nf0rm4710n_w1th_3nc0d1ng_#3nc0d1ng_1s_n0t_3ncryp710n!}

## Description

In this simple reversing challenge the player has to decompile the binary and inspect the code to find the base64 encoded flag. 
 

## Tools

To solve the challange the player needs a decompiler like Ghidra or Binja and python.


## Installation

No instalation required. To generate the binary run the script generate_binary.sh

```bash
./generate_binary.sh
```

## Solution

### Step 1
Open the binary file in Ghidra or Binja

### Step 2
Open the main function in the Decompiler window and try to get an initial understanding of what the program does.

### Step 3
Open the init function and figure out where the global variable flag is initialized.

## Step 4
Run the program and input the string found in the previous step to verify that it is the correct flag.

### Step 5
The string ends in `==` which should hint that it is base64 encoded. The final step is decoding the base64 encoded string to get the flag. 


```bash
./solution.py
```
