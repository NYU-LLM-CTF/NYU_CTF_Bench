#!/usr/bin/env python3
"""
solver.py

    Recovers program using capstone, which must then be manually reversed :(
"""
import binascii
from capstone import *

def main():
    with open("program.txt", "r") as fd:
        contents = fd.read().replace(",", "").strip().split(" ")

    # parse out ints into hex string
    code = "  ".join([str(hex(int(b))) for b in contents])
    print(code)
    code = bytes(code.replace("0x", "\\x").replace(" ", ""), "utf-8")

    # print instructions
    md = Cs(CS_ARCH_X86, CS_MODE_64)
    for i in md.disasm(code, 0x1000):
        print("0x%x:\t%s\t%s" %(i.address, i.mnemonic, i.op_str))


if __name__ == "__main__":
    exit(main())
