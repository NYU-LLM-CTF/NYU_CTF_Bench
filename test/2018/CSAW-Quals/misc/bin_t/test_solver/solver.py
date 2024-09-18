#!/usr/bin/python


from pwn import *
from pyavltree import AVLTree as Tree


def solve():
    conn = remote('misc.chal.csaw.io', 8000)
    #conn = remote('localhost', 8000)
    print (conn.recvline())
    nums = conn.recvline()
    nums = list(int(i) for i in nums.strip().split(b','))
    t = Tree(nums)
    conn.sendline(','.join(str(i) for i in t.preorder(t.rootNode)))
    #conn.interactive()
    conn.sendline(b"cat flag.txt\n")
    conn.recvuntil("}")
    conn.close()
    exit(0)

solve()
