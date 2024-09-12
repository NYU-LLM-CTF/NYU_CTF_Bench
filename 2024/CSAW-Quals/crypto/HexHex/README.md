# HexHex

> Category: crypto
> Suggested Points: 250

# Description

> Detailed description as it would need to be explained to other lab members

This challenge covers the technique of cryptography and use of Twin-Hex cipher to make the players find Twin hex among multiple random Hex encoded texts with multiple delimiters.

# Files

> Any files that is provided

Just the chall.txt file

# Flag

`csawctf{hex3d_i7_w3l7_innit_hehe}`

# Solution

> As detailed as possible description of the solution. Not just the solver script. As full a description as possible of the solution for the challenge.

The players are expected to differentiate between the random dummy hex with multiple delimiters and the twin hex cipher . It will be a challenge for them to research and find about twin hex cipher themselves and I am sure that some might find it too.

- The solution will require the players to first differentiate the twin hex which can be easily got from the txt file as it's kinda unique than others.
- Then , they can just use Twin hex cipher decoders online such as : https://www.calcresult.com/misc/cyphers/twin-hex.html#google_vignette or https://www.dcode.fr/chiffre-twin-hex
- After the decryption ; the flag can be obtained.

**Another way : **

- As the players know the flag format , they can just encode "_csawctf_" string using twin hex cipher
- Then they can just run `cat chall.txt | grep "{twin_hex_encoded_value_of_csawctf}"` which will return the line containing the flag
- Then the player can decode the whole encoded flag and get the flag.
