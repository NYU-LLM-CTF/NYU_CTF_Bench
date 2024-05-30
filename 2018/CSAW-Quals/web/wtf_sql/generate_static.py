import os
import zlib
import struct
from binascii import hexlify


def compress(data):
    """ compress compatible with mysql's compress() and uncompress() """
    p32 = lambda x: struct.pack("<I", x)
    return hexlify(p32(len(data)) + zlib.compress(data))


statics = {}
for path, _, filenames in os.walk("static"):
    for fn in filenames:
        fullpath = os.path.join(path, fn)
        with open(fullpath, "rb") as f:
            contents = f.read()
        statics[fullpath] = contents

q = (
    "INSERT INTO `static_assets` VALUES "
    + ", ".join(
        "('/{}', UNCOMPRESS(UNHEX('{}')))".format(k, compress(v).decode("ascii"))
        for k, v in statics.items()
    )
    + ";"
)

print(q)
