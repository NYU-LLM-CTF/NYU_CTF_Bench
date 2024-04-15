# Callsite

> Recommended Categories: reversing

Challenge for redirecting execution based on using function pointer to indirect call site. Attacker will need to either use some type of dynamic analysis or decompilation in order to determine function pointer and correct plaintext in order to invoke `win`.

## Setup

```
$ gcc -O3 -static -s binary.c -o call_site -lcrypt
```

## The Challenge

TODO

## The Solution

Determine function pointer to `win`, figure out functionality of the hash function, and determine plaintext key.


