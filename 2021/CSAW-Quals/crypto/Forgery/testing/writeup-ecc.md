


# CSAW - Forgery 

![challenge_json](https://github.com/osirislab/CSAW-CTF-2021-Quals/blob/main/crypto/Forgery/testing/writeup-files/challenge_json.JPG)

In this challenge we are interacting with a server which gives us a public key of some cryptography scheme. We are given the public key`(p,g,y)` and a question `Who do you think is the tech wizard: Felicity or Cisco or both? Please answer it with your signnature (r,s)`. Our target is to find a tuple `(r,s)` such that it will be verified for a message that containes one of the items in `["Felicity","Cisco","both"]`

### Challenge's Solution Path

First thing we have to do is to find out the signature scheme that being used here. The source code of the server is given, so lets check it out. The implementation of the verify function contains the verification process of a signature in `ElGamal Signature Scheme` :

![verify_func](https://github.com/osirislab/CSAW-CTF-2021-Quals/blob/main/crypto/Forgery/testing/writeup-files/verify_func.JPG)

```
g^m = (y^r * r^s) mod p
```

Now we now that we are dealing with `ElGamal Signature Scheme`. Lets move on and take a look at the main function of the server:

![main_func](https://github.com/osirislab/CSAW-CTF-2021-Quals/blob/main/crypto/Forgery/testing/writeup-files/main_func.JPG)

The main function revealing an interesting thing:
```
answer_bytes = bytes.fromhex(answer)

if b'Felicity' not in answer_bytes and b'Cisco' not in answer_bytes and b'both' not in answer_bytes:
		print("Error: the answer is not valid!")
elif verify(answer, r, s, y):
	# print flag
```
It's basically tell us that the message just need to **contains** the bytes that represents one of the items in `["Felicity","Cisco","both"]` and not just the items themselves. For example: given a signature `(r,s)` for the message `Bazinga! both`, challenge is being solved. However, we can't just create a signature for a selective message because we are missing the private key (obviously!).
What can we do? We can use a vulnerability in the scheme which happaned beacuse of the fact that the sign process has been done on `m` and not on `H(m)` (the hashed message). 

![sign_func](https://github.com/osirislab/CSAW-CTF-2021-Quals/blob/main/crypto/Forgery/testing/writeup-files/sign_func.JPG)

Scrolling down the `ElGamal signature scheme` page in wikipedia will lead us to an attack called `Existential forgery`. 

![exist_attack](https://github.com/osirislab/CSAW-CTF-2021-Quals/blob/main/crypto/Forgery/testing/writeup-files/exist_attack.JPG)

The attack produces us a valid sign for some message. We need to analyze the server's source code a bit more to understand how it can help us. Let's get back to the verify function:

```
def verify(answer: str, r: int, s: int, y: int):
	m = int(answer, 16) & MASK
	if any([x <= 0 or x >= p-1 for x in [m,r,s]]):
		return False
	return pow(g, m, p) == (pow(y, r, p) * pow(r, s, p)) % p
```
Read carefully between the lines, there is a masking going on there! `MASK` is set to `1024` in the head of the code. What are the consequences of such an operation? Basically I can provide any given length of message to the server (in that case a string of its long value) but the verification will be done just on the first `1024` bits because of the bitwise AND. Now ill explain the final solution.

```
# Elgamal existantial forgery attack to produce message and valid signature
e = randint(1, p-1)
r = y*pow(g,e,p) % p
s = -r % (p - 1)
m = (e*s) % (p-1)

# make a "concat" payload
payload = bytes_to_long(b'both')  
m += payload << 1024
```
We have been taking here two steps:
1. Produce a valid signature for some random message
2. Concat a payload which is length > 1024 bits (by pushing zeros from right - shifting)

```
example: bytes_to_long(b'both') = 1651471464 = 1100010011011110111010001101000
m is random

what we done is basically creating this message:

**********************************|*******************************|
| 0..............................0|               m               |     =    m
************ 31 bits *************|*********** 1024 bits *********|

+

**********************************|*******************************|
| 1100010011011110111010001101000 | 0............................0|     =  payload
************ 31 bits *************|*********** 1024 bits *********|

=

**********************************|*******************************|
| 1100010011011110111010001101000 |               m               |     =  m + payload
************ 31 bits *************|*********** 1024 bits *********|

```
The bitwise & will cut the first 1024 bits (our m)! So it will do the verification process on the message that we found a signature for in the previous step using the existential forgery attack. We basically ignored our extra bits (the payload) in the process of the verification but used that payload to pass the filter of the server that checks for a specific string being contained within the message provided. Moreover, any shifting above 1024 will do the job (In multiplies of 8 to preserve the values of the string "both"  when converting from hex to bytes, so we still be able to pass the initial filter).

All we left to do is run the attack to obtain the flag:

![flag](https://github.com/osirislab/CSAW-CTF-2021-Quals/blob/main/crypto/Forgery/testing/writeup-files/flag.JPG)

`flag{7h3_4rr0wv3r53_15_4w350M3!}`


## Notes For Developers
1.  Was it fun? It was great. The combination of the masking with the actual attack being used is very creative and I liked it. 
    
2.  Does it teach a useful skill? Yes! It teaches about ElGamal cryptosystem. Without reading about it there is no way one can solve the challenge. 
    
3.  Does the difficulty seem to match the author's posited point value? I'm not sure. I think this challenge given the source code is pretty simple but take some time to analyze. I would probably leave it as its current value.
    
4.  Is there a clear path to the solution (regardless of difficulty) so that the player doesn't get frustrated by trying to figure out how the challenge author wanted the player to think? Definitely. The server source code is given, so there is no way one would stuck, as long as he really understand it.
    
5.  Are there ways to "break" the challenge (alternate paths to the solution that are easier than intended? Not that I found.
    
6.  Is the README.md file comprehensive enough that a moderator can read and understand the solution when fielding questions about the challenge? I think the solution should be a bit more detailed. The masking was a big part of the solution and it's not mentioned in the readme of the challenge.
    
7.  Is it Dockerized and ready to deploy? It is. I built the image, ran it in detached mode while exposed port 5000, and then interact with it over localhost:5000.
    
8.  Does the flag in the challenge match the flag in the  `challenge.json`  file? The flag in the  `challenge.json`  file matches with the flag that the server pulls from the file  `flag.txt`.




