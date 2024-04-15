# Hardskull I
By: theKidOfArcrania

This challenge is actually written in a compiler that I designed from the ground
up for a graduate class project. I based my design off of the haskell runtime
(as used in the ghc).

(Note from the OSIRIS Lab: the `.hc` file provided for this release therefore 
doesn't compile with `ghc` because it uses a custom compiler. To compile it,
use The Kid of Arcrania's compiler once he has finished writing it! Otherwise
just work with the compiled binary directly to solve this challenge.)


The whole premise of this challenge is that the program reads in the flag,
checks for the format flag{...}, then takes the flag body four characters at a
time, computing (257(257(257(c0) + c1) + c2) + c3) (+) 0xdeadbeef, and then
checks for equality with some internal value.

Code used to generate everything:
```python
flag = 'flag{INSERT_FLAG_HERRE}'
def tostr(num):
    series = []
    for b in bin(num)[2:][::-1]:
        series.append('b' + b)
    series.append('bz')
    return ' $ '.join(series)

xornum = tostr(0xdeadbeef)
print(f'#define XORKEY ({xornum})')

res = '('
for i in range(5, len(flag) - 1, 4):
    x = 0
    for c in flag[i:i+4]:
        x *= 257
        x += ord(c)
    num = tostr(x ^ 0xdeadbeef)
    print(f'#define CHK_{i} ({num})')
    res += f'CHK_{i} @. '
res += 'Nil)'
print(res)
```

## Compiler Theory
Of course this straight forward computation is complicated by the complexity of
how functional languages are mapped onto imperative languages. I utilized [this
paper][1], which explains the process of how haskell converts high-level
functional code into something that's compilable. Feel free to skip this section
if you are not interested in the actual compiler theory behind this language.

How haskell compiles its functional language onto some assembly, the first step
is usually desugaring and then converting it into a STG (Spineless, Tagless
G-machine) code. This essentially turns any nested applications into separate
"thunks" (aka procedures/"functions" with no arguments) ("spineless"). In
addition, any constructors (which we actually did not have any for this language
subset) would be fully saturated ("tagless"). For example, this is
how the following code would be converted into STG form:

```haskell
foldl :: (b -> a -> b) -> b -> [a] -> b
foldl _ init [] = init
foldl fn init (x:xs) = foldl fn (fn init x) xs

length :: [a] -> Int
length = foldl ((+) 1) 0

# STG form
foldl fn init lst =
  case lst of
    [] -> init
    x:xs -> let thnk1 = fn init x
             in foldl fn thnk1 xs

length :: [a] -> Int
length = let thnk1 = (+) 1
          in foldl thnk1 0
```

Essentially, STG requires that all arguments applied to functions be _atoms_,
(i.e. either a literal or a variable). By removing these nested applications,
the conversion to some imperative language becomes more straight-forward, as
this gives us more freedom to not need to immediately evaluate the arguments of
a function at the call-time, but rather, evaluate on a need-basis (lazy
evaluation).

Then each of these thunks and functions get converted into individual closures
with vtables to the code. This compiler uses the eval-apply model, described as
in the [above paper][1], see the small-step operational semantics on page 8.

The result is what you love and know as haskell in assembly form. Then, in order
to reverse engineer this code, one would simply walk through each individual
closure one by one, and reconstruct the lambdas, slowly rebuilding the codebase.

## A Dabble of Lambda Calculus
Once one recovers the original lambda code, you would then start to understand
what the lambda functions are doing. Here I implemented a mish-mash of a ton of
lambda calculus encodings, most of them adopted from Church's encodings Of
course, it won't be complete until I also implement numbers in lambda
calculus. The hardskull runtime has one primary numeric system baked in using
Church's Encoding for numbers. It also uses a primitive internal numeric
representation when needing to print out characters not accessible in user code.
On top of that, I also implemented a binary number structure as well in order to
make fast(er) computations than the slow Church encoding for numbers.

Here I create psuedo-data constructors that are actually just functions, (though
in my original source language, I had the compiler create such functions for
some simple cases).

This thus concludes this walkthrough of my challenge, if you would like to see
the original source code, [here it is][2]. The compiler comes with this will be
released in the future very soon!

[1]: https://www.microsoft.com/en-us/research/wp-content/uploads/2016/07/eval-apply.pdf
[2]: https://gist.github.com/theKidOfArcrania/491ec7d4813a99d10d8a04639f0ecefc
