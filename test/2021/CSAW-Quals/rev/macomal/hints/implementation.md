Run the following python script to get the flag:

```
swift_string = bytes("kinda_close_i_guess___".encode("utf-8"))
recovered_bytes = bytearray("\x0D\x05\x0F\x03\x1A\x2A\x3C\x0B\x5F\x07\x3A\x32\x5A\x00\x09\x45\x12\x2C\x1B\x2A\x37\x22".encode("utf-8"))

for a, b in zip(swift_string, recovered_bytes):
    print(chr(a ^ b), end="")
```
