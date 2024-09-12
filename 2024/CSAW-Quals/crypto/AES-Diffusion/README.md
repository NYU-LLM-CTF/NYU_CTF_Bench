> In Challenge 1, the player learns what diffusion is and why it matters for a cipher. He also learns what an S-Box is and how to evaluate if it achieves complete diffusion or not. For Challenge 2, I want to expand the diffusion analysis for a whole cipher, because the S-Box is just one of the components. To do that, I explain to them how complete diffusion is achieved by AES.

## Interacting with AES to understand byte-level diffusion

You've certainly heard of AES, the most widely used block cipher in the world.

The AES state is commonly represented as a 4x4 matrix of **bytes**. The algorithm has 10, 12 or 14 **rounds** (iterations) depending on the variant (AES-128, AES-192 or AES-256 respectively). Each round comprises steps called `AddRoundKey`, `SubBytes`, `ShiftRows`, `MixColumns`.

The following pseudocode represents AES:
```
x = plaintext
x = AddRoundKey(x, k0)
for r from 1 to nr - 1 do
	x = SubBytes(x)
	x = ShiftRows(x)
	x = MixColumns(x)
	x = AddRoundKey(x)

// Last round doesn't have MixColumns
x = SubBytes(x)
x = ShiftRows(x)
x = AddRoundKey(x, knr)
return x
```

> We can give the player my `aes_simulator.py` code.

Let's focus on the interaction between `ShiftRows` and `MixColumns` for now. For that, let's assume the other operations don't exist and reduce AES to this:
```
x = plaintext
for r from 1 to nr do
	x = ShiftRows(x)
	x = MixColumns(x)
return x
```

Assume you have the following `x` state before a `ShiftRows` execution:
```
state = [["x0", "x4", "x8", "x12"],
         ["x1", "x5", "x9", "x13"],
         ["x2", "x6", "x10", "x14"],
         ["x3", "x7", "x11", "x15"]]
```
What will the `ShiftRows` output be?
> Answer:
```
[['x0', 'x4', 'x8', 'x12'], ['x5', 'x9', 'x13', 'x1'], ['x10', 'x14', 'x2', 'x6'], ['x15', 'x3', 'x7', 'x11']]
```
What about after `MixColumns`?
> Answer:
```
['2*x0 + 3*x5 + 1*x10 + 1*x15', '2*x4 + 3*x9 + 1*x14 + 1*x3', '2*x8 + 3*x13 + 1*x2 + 1*x7', '2*x12 + 3*x1 + 1*x6 + 1*x11']
['1*x0 + 2*x5 + 3*x10 + 1*x15', '1*x4 + 2*x9 + 3*x14 + 1*x3', '1*x8 + 2*x13 + 3*x2 + 1*x7', '1*x12 + 2*x1 + 3*x6 + 1*x11']
['1*x0 + 1*x5 + 2*x10 + 3*x15', '1*x4 + 1*x9 + 2*x14 + 3*x3', '1*x8 + 1*x13 + 2*x2 + 3*x7', '1*x12 + 1*x1 + 2*x6 + 3*x11']
['3*x0 + 1*x5 + 1*x10 + 2*x15', '3*x4 + 1*x9 + 1*x14 + 2*x3', '3*x8 + 1*x13 + 1*x2 + 2*x7', '3*x12 + 1*x1 + 1*x6 + 2*x11']
```

Which old bytes influence the new `x0` byte?
> Answer should be `x0`,`x5`,`x10`,`x15`.

Which old bytes influence the new `x11` byte?
> Answer should be `x8`,`x13`,`x2`,`x7`.

Has complete diffusion been achieved?
> No.

How many plaintext bytes are not influencing the new `x0` byte?
> Answer should be 16 - 4 = 12.

Let's denote as `xi:r` the byte `xi` of the state after round `r`. In other words, new `x0` can be denoted as `x0:1` as it is the new `x0` after one round of our special AES has been performed, whereas old `x0` would be `x0:0`. 

For the second round, the input is the output of the first round - i.e. the state matrix made of the `xi:1` bytes.

What bytes from the first round output (`xi:1` type of bytes) influence `x0:2`?
> The answer should be simply `x0:1`,`x5:1`,`x10:1`,`x15:1`, because we're just doing the same thing.

You know which `xi:0` bytes influence which `xi:1` bytes. Thus, which `xi:0` bytes influence `x0:2`?
> Here the answer should already include all 16 bytes.

## Why we need ShiftRows and MixColumns to be together
If we reduce the algorithm to this form:
```
x = plaintext
for r from 1 to nr do
	x = ShiftRows(x)
return x
```
What is `x0:10`?
> Answer can be obtained by running `aes_simulator.py` with `rounds = 10` and should be just a single `xi` symbol, not a list like the previous answers.

What about this form?
```
x = plaintext
for r from 1 to nr do
	x = MixColumns(x)
return x
```
What is `x0:2`?
> Answer can be obtained running `aes_simulator.py` equivalently.

Do we ever achieve complete diffusion?
> No.
> And the player can test this with arbitrary values of `rounds` if they like.
## Conclusion
As you could observe, AES only achieves complete diffusion in its bytes if `ShiftRows` and `MixColumns` are employed together.
