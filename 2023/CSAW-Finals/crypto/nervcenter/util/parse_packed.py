#!/usr/bin/env python3

import sys
import zlib

def parse_packed(filename):
    f = open(filename, 'rb')
    while True:
        data = f.read(256)
        if not data: break
        name = data.split(b'\0', 1)[0]
        data = f.read(8)
        if not data: break
        size = int.from_bytes(data, 'little')
        data = f.read(size)
        assert len(data) == size
        out = zlib.decompress(data)
        print(name, size, len(out))
        if b'Sandalphon' in name:
            sys.stderr.buffer.write(out)
    f.close()

if __name__ == '__main__':
    parse_packed(sys.argv[1])
