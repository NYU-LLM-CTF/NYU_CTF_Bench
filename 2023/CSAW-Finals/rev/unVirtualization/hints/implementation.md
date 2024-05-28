Run the following python script to get the flag:

```
from pwn import *

with open("ctf_files/prog", 'rb') as h:
    buf = h.read()
start = buf.index(b"\x48\x89\x14\x01") + 4
buf = buf[start:]

out = ""
for i in range(50):
    lhs = buf.index(b"\xB8") + 1
    rhs = (buf.index(b"\x48\x83\xf8") + 3) if buf.index(b"\x48\x83\xf8") < 20 else (buf.index(b"\x48\x3d") + 2)
    lhs = u8(buf[lhs:lhs+1])
    rhs = u8(buf[rhs:rhs+1])
    buf = buf[2:]
    try:
        buf = buf[buf.index(b"\xB8"):]
    except Exception:
        pass
    out += chr(lhs^rhs)
print(out)
```
