#!/usr/bin/python


from pwn import *
from pyavltree import AVLTree as Tree


def solve():
    conn = remote('misc.chal.csaw.io', 9001)
    print conn.recvline()
    nums = conn.recvline()
    nums = list(int(i) for i in nums.strip().split(','))
    t = Tree(nums)
    conn.sendline(','.join(str(i) for i in t.preorder(t.rootNode)))
    conn.interactive()

solve()
