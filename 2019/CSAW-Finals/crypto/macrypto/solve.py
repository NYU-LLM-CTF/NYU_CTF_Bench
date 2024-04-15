#!/usr/bin/env python2
import time
import string
import random

from pwn import *

def main():
    p = process(["./macrypto"])
    flag = "".join("{:02x}".format(ord(c)) for c in "flag")

    while True:
        p.sendline("A" * (250 * 2))
        result = p.recvline()
        print(result)
        if flag in result:
            print(result)
            break
        time.sleep(1)

    return 0


if __name__ == "__main__":
    exit(main())
