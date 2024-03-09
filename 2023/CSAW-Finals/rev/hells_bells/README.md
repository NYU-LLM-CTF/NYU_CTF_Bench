# Hells Bells

## Overview

This challenge's theme is the band **ACDC** and their song **Hells Bells**. It is meant to simulate real-life malware.
Many of the concepts used in this challenge are borrowed and modified from the Flare-On challenges.

Please find the program architecture bellow:

![hellsbells.png](images%2Fhellsbells.png)


## Reversing

As previously mentioned, this challenge is mostly built in Rust to the shellcode is fairly terrible to work with. 
In order to make this challenge feasible, we compile with `opt-level = 0` (see [.cargo/config](.cargo%2Fconfig)).

### Steps



## Solution

![solution.png](images%2Fsolution.png)

1. `set UNLOCK_ME=AyeCdC`
2. `WTB1X0dvdF9tM19yMW5nMW5nX0gzbGxzX2JlTGw1` (base64 string of `Y0u_Got_m3_r1ng1ng_H3lls_beLl5`)
3. `:` (`0x3A`, for walking ROTR32 and walking the PEB)
4. `r_0_L_l_1_n_g_-_t_H_u_n_d_3_r_r_` for first shellcode challenge.

```
hells_bells.exe

MD5: a2d2d042064ba74987131d1d1c45d45f
SHA1: 3f8e0ca998440cf3468b1b46217dd7630f306cd1
```