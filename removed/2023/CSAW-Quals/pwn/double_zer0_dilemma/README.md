# double zer0 dilemma

double zer0 dilemma is a pwn challenge focused on improper input validation.

The idea for this challenge is that since arbitrary integers can be sent and captured by `scanf`, you are able to
overwrite two pointers with close to arbitrary values. 

In my solver script, I overwrite `printf`, but `puts` is also viable.

# Solution

The intended solution is in this [folder][1]

Run `python3 exp.py` to solve.


[1]: ./solution

