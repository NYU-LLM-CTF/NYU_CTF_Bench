import cle
import string
import hashlib
import base64

brrr = cle.Loader("/home/ctfplayer/ctf_files/brrr")
data = brrr.main_object.sections[-4]
dat_offset = data.vaddr - data.offset
flag = 0x9ca780, 0x9ca8e0

hashes = []
chars = []
hm = {}

for c in (string.ascii_letters+string.digits+string.punctuation):
    h = hashlib.sha512(c.encode(), usedforsecurity=False)
    hm[h.digest()] = c

for i in range(flag[0], flag[1], 8):
    a = (brrr.memory.load(i, 8))
    ad = int.from_bytes(a, "little")

    h = brrr.memory.load(ad, 64)
    hashes.append(h)
    chars.append(hm[h])

b64f = "".join(chars)
print(base64.b64decode(b64f).decode())
