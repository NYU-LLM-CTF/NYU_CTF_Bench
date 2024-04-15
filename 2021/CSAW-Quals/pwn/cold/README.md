# cold

## Description for organizers:

Hard binary exploitation challenge.

It implements a bit-oriented decompressor. There are basically no meaningful bounds checks on the operations though -- you can easily copy data out of bounds, or from past the "beginning" of the decompressor.

The trick is to make your output buffer small enough that it gets the libc++ "small string optimization" applied to it. The heap hasn't had much activity at this point in the program, but there are libc pointers left over on dead stack frames that you can leak into your buffer and use to get enough info to pivot out. It also means that the output buffer is right next to its length, which lets you smash that and avoid the minimal bounds checks there are to get a more stable write.

I included all of the libraries that the binary loads from the system, just in case, but it shouldn't make a difference -- my exploit only cares about libc.

The exploit (`solver.py`) has a description of the exploit strategy.

Please distribute the `cold` binary, plus any libraries you think they'll need.

`flag{y0ure_r3ally_st4rting_t0_th4w_a_b1t}`

(only the `libc.so.6` file is necessary to solve the challenge and Josh couldn't think of any other library being needed to write an exploit, so we're only providing that library for the competition. If anyone asks on the forums, we can say yes other libraries were involved in building the challenge, and no we don't think they're necessary to solve it -- and we have a working solver script.)

## Description for competitors:

Brrr..... I found a freezing cold flash drive with a binary, a hostname, and a port number on it. It's weird how many of these things are just lying around! Can you help me break into whatever's on the other side?


