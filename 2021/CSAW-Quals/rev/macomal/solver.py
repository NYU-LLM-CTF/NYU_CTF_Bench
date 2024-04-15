#!/usr/bin/env python3
"""
solver.py

    Semi-automatic solver for machomal

    This doesn't do any manual reversing, although a Binary Ninja/IDA
    plugin could help in patching the opaque predicates.

    WORKFLOW:

    1. Recover the string in the Swift-based Mach-O

    kinda_close_i_guess___

    2. Figure out there's a Golang-based `runtime.dylib` dependency 
    that needs to be reversed

    3. Patch opaque predicates (always false)

    4. Recover the byte inputs

    5. XOR against the Swift string
"""

swift_string = bytes("kinda_close_i_guess___".encode("utf-8"))
recovered_bytes = bytearray("\x0D\x05\x0F\x03\x1A\x2A\x3C\x0B\x5F\x07\x3A\x32\x5A\x00\x09\x45\x12\x2C\x1B\x2A\x37\x22".encode("utf-8"))

for a, b in zip(swift_string, recovered_bytes):
    print(chr(a ^ b), end="")
