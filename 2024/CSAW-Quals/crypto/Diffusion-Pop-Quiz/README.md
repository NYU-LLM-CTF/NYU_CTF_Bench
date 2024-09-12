> This script is bottom-up, explains each concept and validates the player's understanding, with the intention of being very educative and friendly.

> The goal of this challenge is to teach players about the diffusion property and a tool to evaluate if an S-Box (a very common component in several ciphers, particularly Substitution Permutation Networks) has good diffusion properties.

> The tool is the Algebraic Normal Form (ANF) of an S-Box, which gives equations for each output bit as functions of the input bits and permits a clear evaluation of diffusion.
## Diffusion Definition
> This part is supposed to be just an intro to the property, just show these messages to the player.

Have you ever wondered what a **good** cryptographic algorithm is made of and **why**? Well, certainly there are several mathematical properties involved. One of them is **diffusion**.

Diffusion refers to the **dependence of ciphertext units on plaintext units** and, for modern cryptography done in computers, the "units" are bits ;)

Let $x$ be an input plaintext which we encrypt, giving us the ciphertext $y$.

Let $x'$ be another input plaintext, which is simply $x$ with some bit changed and all the other bits being the same, and $y'$ be its ciphertext.

How **different** is $y'$ from $y$? How does changing **a bit of the plaintext** influence **the resulting ciphertext**? 

This is what diffusion is about.

But **why does it matter?**
## Diffusion Minigame with Caesar Cipher
> This second part is a mini-challenge to illustrate the relevance of diffusion. We use a Caesar cipher (that doesn't have diffusion, just a substitution of the letters) to show how patterns can be deduced if a cipher doesn't have complete diffusion.

Can you decrypt this? `<some encrypted text here>`

Certainly at a first glance you have no clue what this could possibly be, right? However, I'm giving you the **encryption device**. You can play with it by encrypting your own plaintexts. I wonder if that will help you? Well, it's definitely better than nothing, right? ;)

> I want to make this initial example very simple so maybe restricting the encrypted text to a single word such as "hello" or something like that is good.
> We need some setup for that such as "press R when you're ready to enter your answer", a loop to get player's input and produce the output etc, messages saying "no, that's wrong, try again" or "you've decrypted it, congrats!" etc.

## Conclusions from the Minigame + Complete Diffusion Definition
>Stating the conclusions after the game 

When a plaintext bit change results in only one ciphertext bit change, it's quite easy to deduce the relationship between them, as is the case of the Caesar cipher you've just cracked.

If a plaintext bit change results in $n > 1$ ciphertext bit changes, the relationship gets harder to track - but still doable, depending on the value of $n$.

When designing cryptographic algorithms, we strive for **complete diffusion** - meaning that each output bit depends on **all** input bits.
## S-Box as a lookup table
Have you ever seen an **S-Box**? Many algorithms, including the famous **AES**, have one as a component. 

**S-Boxes** can be implemented as integer lookup tables. The AES **S-Box** for example is a mapping from an 8-bit input to an 8-bit output.

> We can put the S-Box arrays on this file and give them to the player. It's just so that we make sure he sees it and understands that it's a lookup, because the first result in Wikipedia doesn't have it as a lookup table, it builds it from the polynomial mathematical definition, and I don't want that to make the players confused if they do research on their own. I want them to think of it simply as an 8-bit to 8-bit mapping.

Can you find the last entry of AES S-Box?

> Answer should be 0x16.

Looks like a random integer array, but you're about to find out that it's not...
## Boolean functions
A Boolean function of $n$ variables maps $n$ input bits to a single bit. Examples of that are AND, OR and XOR.
> Here we could have prompts asking for XOR(0,0), XOR(1,0) and XOR(1,1) to have the player lookup XOR in case they don't remember it.
## Algebraic Normal Form of a Boolean Function
Any Boolean function can be uniquely represented by a **multivariate polynomial** with degree at most 1 in each variable. Each variable of the polynomial corresponds to each input of the Boolean function. For example, let $f$ be a Boolean function with 3 input bits called $x_1$, $x_2$, $x_3$. The ANF shall have 3 variables for each of them, and coefficients for each possible monomial.

The possible monomials are $1$, $x_1$, $x_2$, $x_3$, $x_1 \cdot x_2$, $x_1 \cdot x_3$, $x_2 \cdot x_3$ and $x_1 \cdot x_2 \cdot x_3$.

The full ANF expression is $f(x_1,x_2,x_3) = A + Bx_1 + Cx_2 + Dx_3 + Ex_1\cdot x_2 + Fx_1\cdot x_3 + Gx_2 \cdot x_3 + H x_1 \cdot x_2 \cdot x_3$. 

Given the truth table of a Boolean function, it is possible to extract its ANF, in other words, find out the values of the coefficients $A, ..., H$ for it.

The $+$ symbol is an XOR and the $\cdot$ is an AND.

> I was reviewing my paper and Anne Canteaut's paper on ANF and it looks like it's too boring to implement. Furthermore learning how to extract an ANF isn't that relevant for crypto - what matters is understanding what the ANF tells you about diffusion and S-Box. I mean, there are probably tons of libs that can give you the ANF of a given truth table out there either way. The goal is to understand how to use it, and that you have to recover the ANF of each bit. Maybe we could give them an `anf_extractor.py` script they can use.

Can you use `anf_extractor.py` to obtain the ANF of the function given by the following truth table?
|$x = (x_1,x_2,x_3)$|$f(x)$|
|-------------------|------|
|000|0|
|001|1|
|010|0|
|011|0|
|100|0|
|101|1|
|110|1|
|111|1|
> We should reference Anne Canteaut's lecture notes, that's where they'd find explanation of how the ANF is obtained if they want to better understand the code we gave them.
## Vectorial Boolean Functions
A Vectorial Boolean Function maps $n$ input bits to $m$ output bits which are called coordinates. Each coordinate is a Boolean function. Therefore we can recover the ANF of each coordinate.

Can you recover the ANFs of all coordinates of the following VBF?

> Here we can give them a very simple random VBF, something with 3 bits outputting 2 bits, very small. The idea is just that they have to write a loop for each output bit now.

> We also may need to instruct them in the exact output format they need to follow. They need to write the equations the right way, with no spaces, using + and dot signs etc. We'll probably replace the dots with an asterisk for convenience.

> We could prompt for each output bit, like this:

Your answer for $y_1$:
Your answer for $y_2$:
## S-Box as a Vectorial Boolean Function
You have just seen VBFs are a mapping of $n$ bits to $m$ bits.

Now... Do you remember the definition of an S-Box?

What happens if you think about the **binary representation of integers**?

An S-Box is a VBF!

> We could have some .py files with a few S-Boxes. For example, `sbox1.py`, `sbox2.py`, `sbox3.py`. They could be, respectively, DES, SAFER, AES, or some other S-Boxes we think about. We could build our own weak / strong S-Boxes from the desired ANF answer, too.

Extract the ANF of the first bit of the S-Box given at `sbox1.py`:
Extract the ANF of the second bit ... :
Extract the ANF of the third bit ... :
> And so forth, for all the bits, or, again, we could instruct them on how to write a file with the equations, or a json, yaml, whatever format we find easy to validate, providing an example so that we can match their written input to our answer key.
## Complete Diffusion for an S-Box output bit
Tell me, with regards to `sbox1.py`'s first output bit: which input bits does it depend on? Separate them with commas.
> We could have this question for some output bits of each example S-Box we give them.

Does `sbox1.py`'s $y_1$ output bit **achieve complete diffusion** with respect to the input bits?
> Here the answer is **yes** or **no**. We could have multiple such questions for them to answer.

## Complete Diffusion for the whole S-Box
If complete diffusion is achieved by all output bits, in other words, each input bit spreads its influence to all output bits, with no exceptions, we say that **the given S-Box achieves complete diffusion**.

Which of the given S-Boxes **achieve complete diffusion**, and which **don't**? For the ones that don't, which output bit has a problem? Input the algebraic normal forms.
## Conclusions
An S-Box is merely one of the components of a cryptographic algorithm - they're made of several other components. However, it is paramount that it achieves complete diffusion. And now you know that, if you see S-Boxes as VBFs, you can extract their output bit ANFs to verify whether they achieve complete diffusion or not. Congrats!

> Challenge ends here, we congratulate the player and give them the flag.
