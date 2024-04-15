## The Challenge
A rough schematic. In actuality, the implementation has no separate modules and it's not really about imitating hardware with it's hardware-y consideration, but just some light hearted reversing and shellcoding. <br>
<img src="https://github.com/osirislab/CSAW-CTF-2021-Quals/blob/main/rev/ncore/score.png?raw=true" width="500" /> <br>
User sends byte data, we run sim, send out the results. It's a tiny cpu, hooked up to a ram and a safe-rom, with a key that is initialized per each run, they send us the ram contents and their program gets executed. The idea is that they must bruteforce the key in the ISA of this tiny cpu. As it is a made-up ISA, you have to do the plumbing yourself and assemble together your shellcode. <br>
We can only give them the compiled version, it _might_ be a bit too hard, but it's (the VVP format) really a fairly simple textual format with documentation on ICARUS and they can piece together what's happening. We _can_ give them the verilog file, but it might be _too easy_ then. Also we must rate-limit somehow, I guess. <br>
The main challenge is that the memory ops only support _direct_ accessing, so imagine you have a for loop to read bytes, "R0 <- MEM(i)" looping over i, you cannot put i in a regsiter and increment because in a move instructions you have to specify the address explicitly, i.e. "R0 <- MEM(0)" where the 0 is encoded into the instructions. The solution to this challenge is that well, as it is in Von Neumann architecture, data and instructions live in harmony and well you can have self-modifying code: make a "R0 <- MEM(0)" instruction and then overwrite that 0 with 1, 2,.. as much as you want to loop. <br>
## Icarus Verilog
see here: http://iverilog.icarus.com/
compile and run like this (the flag is for SystemVeriog support):
```bash
iverilog -g2012 -o nco ncore_tb.v
vvp nco
```
## ISA
It's SUPER tiny, so you can just see the code and get what's happening, but here we go: every instruction is 2 bytes. There are 4 32bit registers. There is a 256 byte ram and program execution starts from address 0. <br>
ADD/SUB/AND/OR (only AND, SUB actually implemented): < OPCODE(3:0) | OP1(5:4) | OP2(7:6) > | < OP3(1:0) > <br>
OPi are registers. These instructions do: OP1 <- OP2 op OP3 <br>
MOVF/MOVT, (MOVE FROM/TO MEMORY): < OPCODE(3:0) | OP1(5:4) > | < ADDR(7:0) > <br>
OP1 is the destination register, OP1 <- MEM(ADDR) <br>
## Example Solution
The ram file includes a solution, the code is like this: <br>
| ENT | JEQ R3,R0,8 | INC R0 | JMP 0 | MOVF R1, 0xBF | MOVFS R0, 0 | MOVT R0, 0xBF | INC R3 | INC R1 | MOVT R1, 9 | MOVT R3, 0xB | JMP 0xA |
## Remarks For a Sequel
1. If this works out, it can very easily be used to make a sequel. I already have an idea for making a SPECTRE-type challenge, where they exploit speculative execution in the most tinyest of cores that can be prone to such thing, would be cool given all the hype and clout around SPECTRE!
2. A simple tweak: make it so that on failed ENT we can _know_ whether our key was bigger or smaller than the hw key, and then lower the simulation time: so that they need to have an implementation that doesn't just mindlessly brute-force, but needs to do a binary search to be finished in time. Would make the shellcode harder.
**I am very bad at score estimation** : my guess is 150 for this version and from source, 250 if we give them the VVP file and not the source, and 300 with addition of (2).   
## TODO
1. How many bits to have for the key? If it is too much, it would take longer time to brute-force it, and higher load on us, if it is too small, well I don't know. 
2. Deployment: do we need some sort of rate-limiting? Or kill process if it's running and new submission comes by the same team? Also: we need a python wrapper + dockerfile. 

## TO TEST
make sure the hard-coded code is actually changing, the timing is ok (the bruteforce code cracks it, but not too soon), connection doesn't have a problem.

## challenge.json
files: we can give them "https://github.com/osirislab/CSAW-CTF-2021-Quals/blob/main/rev/ncore/ncore_tb.v" or only the vvp file. With vvp file would make things harder, maybe too much harder. </br>
descr: "We have a very safe core with a very safe enclave."

Specific questions: 1. server.py: I assume "WELLCOME" is a typo right? We want to get rid of one of the L's, correct? I want to make sure we don't need eight letters there for some reason. 2. The Dockerfile has a lot of overhead, using Ubuntu 18.04 and installing lots of packages. Is it necessary for the challenge? If so that's fine. 3. Can you still make a sequel at some point in the future if we give out the Verilog code? 4. The Docker container isn't building for me. I'm getting the following:

```
Step 3/9 : WORKDIR /home/
 ---> Running in 112bdc2c84c5
Removing intermediate container 112bdc2c84c5
 ---> cfc06cc31cc4
Step 4/9 : COPY flag.hex .
 ---> c823d01f88dd
Step 5/9 : COPY server.py .
 ---> 4ba164cf9024
Step 6/9 : COPY nco .
 ---> faab1605ba03
Step 7/9 : USER nobody
 ---> Running in d2a4048085a6
Removing intermediate container d2a4048085a6
 ---> a1340771abe5
Step 8/9 : RUN chmod -w -R /home/
 ---> Running in b1d75f5240bf
chmod: changing permissions of '/home/': Operation not permitted
chmod: changing permissions of '/home/nco': Operation not permitted
chmod: changing permissions of '/home/server.py': Operation not permitted
chmod: changing permissions of '/home/flag.hex': Operation not permitted
The command '/bin/sh -c chmod -w -R /home/' returned a non-zero code: 1
```

5. Would you be willing to treat me as super uninformed about this challenge and give me a set of terminal commands that will interact with the Docker container, use the `ram.hex` file somehow and spit back the flag? Basically a simple solver script. We'll need it to test against the server, and also to field player questions durin the CTF.

6. In the `readme.md` file you mention three things to do under "TO TEST" ("make sure the hard-coded code is actually changing, the timing is ok (the bruteforce code cracks it, but not too soon), connection doesn't have a problem"). Right now our testers are new people and would not know how to do this. How much effort would it take for you to do these three things? Thanks very much! Once the `Dockerfile` is working properly...
