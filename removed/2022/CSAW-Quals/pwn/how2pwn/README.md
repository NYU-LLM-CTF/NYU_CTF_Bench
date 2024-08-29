# how2pwn

Author: Xiang

Tester: Jordi


how2pwn is a series of educational challenges(4 stages). I write this challenge for people have little experience on pwn. If you are new to pwn, don't hesitate to start from this challenge. And there would be many hints in the challenge, I am pretty sure most people, who have learned OS&C Language, could solve it. If you don't have an enviroment to start, please use mine: 

`docker push n132/pwn:22.04`


# Public

```
MD5(./bin/all/chal1)= 964e696c9991ff89e63a64374569a109
MD5(./bin/all/chal2)= c564776f402c9d7354bd417500b4780d
MD5(./bin/all/chal3)= 8a7396d19119843eebb91026bef53db5
MD5(./bin/all/chal4)= f6857f7e5bbcb68e92a6a7a9c6857fd3
MD5(./public.zip)= baf4664f3927a2f2d5da38ec25f9c7e7

```

This folder would be shown to the public, including the source code and binary. You can run the setup.py script to renew the file in pub.

`python3 ./setup.py release`

# Docker

I wrote a script to build the challenge. It opens 4 docker containers.


Usage:
```python
cd ./Dockerize
./setup clean
./setup build
./setup up
# ./setup down
# ./setup clean
```

# write-up

All solvers are in this [folder][1]

## challenge 1

Folks should fill the script with the syscall number of execve and hex value of '/bin/sh'.

## challenge 2

People should fill the short script with shellcode to read longer shellcode.

There is an example:
```s
mov rdx,0x100
syscall
```

And uncomment this line to send longer shellcode.

```python
p.send(b"\x90"*len(shellcode)+asm(shellcraft.sh()))
```

## challenge 3

Basically, people are supposed to fill the script and ret to x86 mode.
After that, they are able to run orw(open read write) with x86 shellcode.

You can check my exploit [here][2].

## challenge 4

Players need to fill the script to exploit.
The corresponding c code is at the 0x05 section of this [page][3].



You can check my exploit [here][4].


[1]: ./solution
[2]: ./solution/exp3.py
[3]: https://n132.github.io/2022/07/04/S2.html
[4]: ./solution/exp4.py

