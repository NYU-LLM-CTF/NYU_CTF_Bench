# Super Secure Heap

`Super Secure Heap` is a pwn challenge focused on a UAF heap vulnerability.

What makes this challenge much more difficult is that RC4 encryption is used before writing to the heap. The key
is defined by the user, but it adds a layer of complexity - needed to find the correct key and content such that when
encrypted, will contain your desired output on the heap.

The reason this challenge works is because RC4 is a stream cipher that does not change the text length (unless 
padding is used).

# Solution

The intended solution is in this [folder][1]

Run `python3 exp.py` to solve.


[1]: ./solution

