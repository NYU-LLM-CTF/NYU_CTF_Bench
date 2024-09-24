# Textbook RSA

> Category: crypto
> Suggested Points: ?

# Description
> Detailed description as it would need to be explained to other computer engineers

Find the flag by decrypting the given challenge ciphertext. You will have to communicate with our decryption oracle in order to retrieve the plaintext.
Our decryption oracle accepts any byte array input but the values 0,1 or the given ciphertext. It outputs a byte array. 
The public parameters associated with the decryption oracle (public key (e), modulus (n)) and the challenge ciphertext (c) can be found in param.py.

# Flag
`csawctf{D0n't_us3_t3xtb00k_RsA1t_w1tH_N0_apPr0pr1at3_pAdd1n6}`

# Solution
> As detailed as possible description of the solution. Not just the solver script. As full a description as possible of the solution for the challenge.

To do as a challenger:
1. The first step is to correctly identify the padding used by the decryption oracle, so that it can be used later for encryption
    - Encrypt a message m of your choice using textbook RSA encryption. Output: c (byte array)
    - Ask the decryption oracle to decrypt it for you. Output: m' (byte array)
    - m and m' are not equal. 
    - Identify the mask used by the decryption oracle by xoring m and m'.
    - The mask should have at least the same size as the message it is xor'ed to: the challenger might need to repeat for different length m's to learn the full mask.
    - the mask will be used as a padding during encryption and decryption by xoring it to the plaintext
2. Modification of the encryption function 
    - Include the padding which consists of xoring the plaintext with the mask before the actual textbook RSA encryption operation.
3. Recognize that the padding scheme used is deterministic and is therefore vulnerable to, for example, malleability attacks.
   Attack the algorithm by using the malleability of the scheme. As an example, the best way to do this is as follows:
    - Create a modified version (c') of the given challenge ciphertext (c).
    - For example: c' = (2**e)*c % n 
    - Submit this modified ciphertext (c') to the decryption oracle.
    - The output of the decryption oracle after decrypting (c') is: m'=((2*(m xor mask))xor mask).
4. Retrieve m by operating on m'
    - First xor m' with the mask found in step 1, this gives you: m' xor mask = 2*(m xor mask)
    - Then divide by 2* by using a right shift ' >> 1', this gives you: (m' xor mask) >> 1 = (m xor mask)
    - Finally compute another xor with the mask, this gives you: ((m' xor mask) >> 1) xor mask = m
6. Identify the flag
	- The flag is the string of the recovered plaintext m.

The script to solve this is in `solve.py`.