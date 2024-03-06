# Mental Poker

> Category: crypto
> Suggested Points: 300

# Description
> Detailed description as it would need to be explained to other lab members

The goal of this challenge is to use break the PRNG scheme involved and beat the machine at poker

# Deployment
> Any special information about the deployment if there is a server component

Use the Dockerfile for the deployment

# Flag
`csawctf{m3n74l_p0k3r_15_4n_1n73r3571n6_pr0bl3m.5h0u70u7_70_numb3rph1l3}`

# Solution
> As detailed as possible description of the solution. Not just the solver script. As full a description as possible of the solution for the challenge.

The code uses Mersenne Twister PRNG with a slight modification about how the states are used to create the number. In the initial state creation, there is a flaw (line 15 of the code). If you have too many bits in the seed compared to the range of numbers you care about, then the seed is brute-forcible. The math works like follows: (using the pseudo-code notation of Mersenne Twister given here --> https://en.wikipedia.org/wiki/Mersenne_Twister#Pseudocode)
```
MT[i] = (f*(MT[i-1] xor (MT[i-2] >> (w-2))) + i+1)% (2^w)
MT[i] = (((f)%(2^w) * (MT[i-1] xor (MT[i-2]>>(w-2)))%(2^w))%(2^w) + (i+1)%(2^w))%(2^w) = ((f * (MT[i-1] xor (MT[i-2]>>(w-2)))%(2^w))%(2^w) + i+1)%(2^w) [Assuming that f<(2^w) and i+1<(2^w)]
```
This means that MT[i] is dependent on the values of MT[i-1] and MT[i-2]. Looking at the XOR equation, we see the following happening for the case of i=1 (MT[0]=MT[-1]=seed and seed is a n-bit number): 
```
    x_n    x_(n-1)    ...    x_(n-w+2)    x_(n-w+1)    ...    x_(w-1)        x_(w-2)        ...    x_1        x_0
XOR 0    0        ...    x_n            x_(n-1)        ...    x_(2w-3)    x_(2w-4)    ...    x_(w-1)    x_(w-2)
=  [x_n    x_(n-1)    ...    y_(n-w+2)    y_(n-w+1)    ...    y_(w-1)        y_(w-2)        ...    y_1        y_0] % (2^w)
```
This implies that only `y_(w-1) to y_0` of the equation goes through. Those are determined by `x_(2w-3) to x_0` seed bits.

In the challenge's case for w=6, only `x_9 to x_0` bits of the seed matter. This implies that only the last 10 bits of the seed matter for the calculation and therefore, the seed is brute-forcible. You only need to test the range of 0-1023 as the seed values and check to see which seed gives you the correct sequence for the shuffle. With the right seed, you can extract the encryption and decryption keys for the server and get the flag.

Video that inspired the challenge --> https://youtu.be/mthPiiCS24A?si=BKtdk_mJu_yiTyTH

The script to solve this is in `solve.py`.
