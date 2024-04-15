#!/usr/bin/python
import sys

n = 0
for i in range(len(sys.argv[1])):
    n |= ord(sys.argv[1][i]) << i * 8

print(hex(n))
