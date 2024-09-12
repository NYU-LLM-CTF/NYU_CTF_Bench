# Archaeology

> Category rev
> Medium/Hard

# Description

Ancient Egyptian themed. Find the input that generates the exact sequence of hieroglyphs as the provided message file. The input would be the flag. Requires understanding of basic crypto operations (XOR, rotational shifts, substitution boxes), and ability to read C code for reversing VM operations, and scripting for automated decryption.

# Flag

`csawctf{w41t_1_54w_7h353_5ymb0l5_47_7h3_m3t_71m3_70_r34d_b00k_0f_7h3_d34d}`

# Deployment

Not needed. Files that would be provided:

- `hieroglyphs.txt` (256 total hieroglyphs used by the program to output the final stream of hieroglyphs)
- `message.txt` (encrypted message)
- `chal` (ELF binary. Takes in a data to encrypt as argument, outputs hieroglyphs. Usage: Usage: ./chal <data-to-encrypt>)

# Solution

The input data to `chal` is first scrambled using a custom `washing_machine` function that applies a series of XORs, where each character is XORed with the previous character and immediately updating itself in its position in the array with the XOR result. After that's done, the entire array is reversed.

`main` then initializes the VM environment, and processes input data using VM instructions. Output from the VM is then scrambled again using `washing_machine`, and the scrambled output data is mapped to hieroglyphs using `hieroglyphs.txt` and printed out, by treating the output byte values as indices into the file. 

### VM Stuff

Only 2 registers used. The encryption transformation consists of 10 rounds of ROTR, SBOX, XOR and ROTL, and transforms the initial scrambled input, one byte at a time. Let's call this the `target_byte`. 

Before each transformation round, a key byte is loaded into register R0. `key_index` is calculated using a modulo operation to cycle through the key array. 
There are 5 XOR keys `0xAA, 0xBB, 0xCC, 0xDD, 0xEE`.

`target_byte` is loaded into register R1.

Transformation Steps:

- bits in R1 rotated to the right by 3 bits
- apply an S-box transformation to the byte in R1, substituting it with another byte based on a predefined lookup table
- byte in R1 is XORed with the key byte in R0
- after the XOR, bits in R1 are rotated left by 3 bits
- after all transformations for a single byte are complete, the `STORE` instruction saves the transformed byte from R1 back into a specific memory location, in this case, indexed by i.

### To reverse

- map the hieroglyphs back to indices
- apply the inverse of the final scramble on the indices (shuffle and XOR) and store in `encrypted_data`
- reverse order of XOR keys used in the VM
- looping 10 times, for each byte of `encrypted_data`, perform these in order: ROTL 5, XOR with key, apply inverse S-box, ROTR 5. Then store the results
- apply the inverse of the initial scramble on the results
- get decrypted flag
