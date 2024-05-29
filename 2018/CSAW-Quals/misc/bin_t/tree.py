#!/usr/bin/env python2

import sys
from pyavltree import AVLTree
from flag import flag
import random

def gen_nums(n):
    for i in range(n):
        yield random.randint(0, 100)

nums = list(gen_nums(100))

print 'Add these numbers to a AVL Binary Tree, then send them back in the preorder traversal!'

print ','.join(str(i) for i in nums)
tree = AVLTree(nums)

sys.stdout.flush()

res = raw_input('Send the preorder traversal in a comma sperated list.\n')

if res == ','.join(str(i) for i in tree.preorder(tree.rootNode)):
    print 'you got it!'
    print flag
else:
    print 'sorry that wasnt it :('
