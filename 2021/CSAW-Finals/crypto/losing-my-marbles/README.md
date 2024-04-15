# Losing my marbles

## Author

CryptoHack (Robin_Jadoul)

## Description

I tried going down the rabbit hole, but now I think I'm just going mad.

*Note:* You'll have to wrap the flag in `flag{}` yourself.

## Distribution to players

- The `losing_my_marbles` binary; to be extracted from the docker image with `docker run --rm losing_my_marbles base64 /app/losing_my_marbles | base64 -d > losing_my_marbles` --> md5: 75a398bbf2b90bc043e4920a3e4873d6
- network connection to the running challenge

## Deploying

See `Dockerfile`

## Solution overview

When analysing the binary, we can observe that there are a lot of functions, but most of them
are very similar to each other.
In particular, we can distinguish roughly four different repeated functions, which we can
find out to be the implementation of `AND`, `XOR` and `INV` gates in a garbled circuit,
as well as function reading the input.
The binary takes the garbling of a fixed circuit as input, provides its own secret inputs
corresponding to the flag and evaluates it.
For every output bit of the circuit, it adds a `1` or a `0` to an output string, *if it
matches the corresponding provided output label*.
This output string, then finally, is AES-encrypted and provided back to the user.

Our first step is to extract the garbled circuit topology from the binary, which can be done
by e.g. parsing `objdump` output, or using any sort of scriptable disassembler or decompiler.
A reference implementation using the binary ninja api can be found in [this file](./extraction_binary_ninja_snippet.py).
An implementation relying on [rizin](https://rizin.re) and the python wrapper `rzpipe`,
that is far slower, can be found [here](./extraction_rzpipe.py).
Upon closer inspection of this extracted circuit, we can look at the number of `AND` gates,
which is the quantity that's generally of interested when looking at boolean or arithmetic circuits
in a cryptographic context.
We find that there are 6400 `AND` gates, and combining this with `garbled circuit` in a google search
leads us to the assumption that this circuit implements the AES-128 block cipher.

From here, either through experimentation or by finding [the actually used circuit](https://homes.esat.kuleuven.be/~nsmart/MPC/aes_128.txt),
the correct format (order and endianness) of the input (key and plaintext) can be found.
The server provides the flag as input, while using the key provided by the user.
This means that if we're able to figure out the output of the circuit, without the second layer
of AES encryption with a fresh random key, we can decrypt it and finally obtain the flag.

To achieve this goal, we go back to an observation we made earlier about the output of the circuit:
if neither of the output labels matches, no character is added to the output string.
We can use this to our advantage to strategically send the wrong output label for a single bit.
If we send the wrong output label for bit index 0, value 0, and we make sure that the length of the
output string ends up being either 0 or 15 (mod 16), we can determine the value of bit index 0
simply by observing the length (the number of blocks) of the encrypted version of the output string.
Repeating this for every single bit index eventually gives us the entire encrypted flag, under a key 
we control, and hence, the actual flag.

An implementation of the garbling and further exploitation can be found [here](./solve.py).
