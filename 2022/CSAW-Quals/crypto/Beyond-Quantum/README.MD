# Beyond Quantum

The original iteration of this challenge was created by N4T_20. 

Their challenge ultimately demonstrated the malleability of the NTRU algorithm, based on an implementation by Jedrzej Krause 
(https://github.com/jkrauze/ntru) with his permission. Credit offered in the flag.

### Iteration Current 
The challenge was changed before CSAW to test a very rudimentary understanding of NTRU; basically the following two things. 
1. NTRU is a cipher based on Truncated Polynomial Rings (modular arithmetic of polynomials)
2. The encrpytion NTRU function is ``ciphertext = rand * pub_key + message (mod q)``


The challenge is designed as follows: 
1. The player interacts with a server and gets the `server.py` file. They also get the contents of the `cipher` folder, which is Krause's implementation of the NTRU algorithm. 
2. Interacting with the server they can get polynomial versions of the public key and ciphertext.
3. As you see in the encrpytion formula above, the `rand` value is required for entropy, else the message can be derived from modular polynomial arithmetic
4. The cipher code is broken, and does not include this randomness
6. Interacting with the server the player submits the plaintext to get the flag

Here's one way to beat the challenge:
1. Understand the NTRU encryption function  ``ciphertext = rand * pub_key + message (mod q)``
2. Since there is no randomness, just subtract: ``message (modq) = ciphertext - pub_key``
3. Use the helper functions in the code to perform the modular polynomial arithmetic and get the message from the broken cipher

#### HINTS:
##### HINT_1: Shouldn't the encrypt function introduce some randomness? This is NTRU afterall...?
##### HINT_2: Yikes! going from polynomials to bytes is hard! Maybe the developer's left some helper functions for this in the code ... 

#### NTRU learning:
https://ideaexchange.uakron.edu/cgi/viewcontent.cgi?article=1880&context=honors_research_projects

#### Observations:
- runs on port 5000

#### Authors:
* N4T_20
* rollingcoconut
