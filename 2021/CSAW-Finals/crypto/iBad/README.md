# iBad

## Author

CryptoHack (Robin_Jadoul and jack)

## Description

We only ever use the best technology for the job, so when something new comes out, we take the upgrade!

## Distribution to players

- run `make_dist.sh` and provide `dist.zip` --> md5: d9878b58bee764683e0cd959a5d571b8
- network connection to the running challenge (web, so reverse proxy for tcp/hostname can be done)

## Deploying

See `Dockerfile`

## Solution overview

Ignoring the wonderfully designed website, let's abstract what we have as a few oracle calls.
We can:

- Encrypt `username || "|regular|" || flag` with a fixed key under AES-GCM, where we fully control `username`
- Determine if a ciphertext is well-formed, and whether it contains `"|admin|"`, the ciphertext can be interpreted as either
    - AES-CBC
    - AES-GCM

  both using the same key

We observe that the GCM decryption properly checks the authentication tag, well it's unlikely we can
find an attack that doesn't violate the IND-CCA2 security here.
So let's focus on what we can do with our CBC oracle for GCM ciphertexts.

Let's further also consider the CBC case with a single ciphertext block, and an IV.
Recall that `D(IV || c) = AES-DEC(c) ^ IV`, so (assuming padding is correct) we can gain
information about the decryption of `c` and malleate the IV.
In particular, we want to construct a situation where `D(IV || c)` contains the string `"|admin|"`,
so we can use it to verify whether a single guessed byte is correct for the flag or not.
We also recall that the encryption part of GCM is simply CTR mode, so we have that
`c = AES-ENC(ctr) ^ m`.
Now, we can start malleating.

Consider that we have some guess for the message (or a single block of the message) `m`, denote it `m'`.
We then wish to validate whether `c == AES-ENC(ctr) ^ m'`, where we note that `ctr` is a known value
from the given ciphertext and the known offset of our block in the total message.
Now we wish to construct two blocks: the IV and the ciphertext to feed into our CBC oracle.
If we set `IV = pad("|admin|") ^ ctr` and `c = c_GCM ^ m'`, then
`D(IV || c) = pad("|admin|")' ^ ctr ^ AES-DEC(AES-ENC(ctr) ^ m ^ m')`
where everything nicely cancels out if our guess is correct, and we don't get `"|admin|"`
with high probability otherwise.

With these building blocks in place, we can now apply the classical ECB oracle approach to slide
a single unknown byte into the block under attack by extending our username and then bruteforcing
the correct value for it with our oracle.
This technique is implemented in [exploit.py](exploit.py).


This challenge was inspired by [One Bad Apple: Backwards Compatibility Attacks on State-of-the-Art Cryptography](https://www.ndss-symposium.org/wp-content/uploads/2017/09/10_4_0.pdf).
