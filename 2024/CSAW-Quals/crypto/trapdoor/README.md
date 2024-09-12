# Trapdoor

> csawctf{n0_p0lyn0m1al_t1m3_f4ct0r1ng_n33d3d_t0_0p3n_th1s_tr4pd00r!}

## Description

This is a Textbook RSA Challenge. The goal of this challenge is to find the vulnerability in the public keys and decrypt flag.
The player receives two public keys and two ciphertexts. It is straightforward to identify that the messages were encrypted using RSA.

Vulnerability: the public keys have a common factor. 

The math is simple, if n1 = p * q1 and n2 = p * q2
Then the common factor `p` can be obtained with the GDC of n1 and n2.

Once you have one of the prime factors of n1 and n2 you can obtain the private keys.

The challenge was inspired by this paper: https://dl.acm.org/doi/pdf/10.1145/2987443.2987486


## Tools

To solve the challange the player needs python and a crypto library like pycryptodome.


## Installation

No instalation required. To generate new public keys and new ciphertexts run trapdoor.py

```bash
./trapdoor.py
```

## Solution

### Step 1
Open the public key files and the encrypted messages and identify the cryptographic algorithm used. 

### Step 2
Find the vulnerability in the public keys.

### Step 3
Once the player has discovered that the moduli have a common factor, they can obtain that factor using the GCD of the two moduli.
Obtaining the other factor is just an integer division of the modulus and the factor.

## Step 4
At this point the player has all the information necessary to recreate the private keys and decrypt the messages.


```bash
./solution.py
```
