# wrangly

> Suggested Category: rev

Binary that implements quirky functions `memfrob` and `strfry`, which obfuscate a string input, but can easily be reversed.

## The Challenge

* Reverse functionality of `memfrob` and `strfry`
* Determine how many iterations each function runs, and how we can change that

## Setup

```
$ gcc unwrangle_me.c -o unwrangle_me
```

## The Solution

```
WRANGLE_CYCLE=1 ./unwrangle_me
```

Take output, then run `memfrob` on it. Manually or automatically (bruteforce ?) decipher flag anagram created by `strfry`.
