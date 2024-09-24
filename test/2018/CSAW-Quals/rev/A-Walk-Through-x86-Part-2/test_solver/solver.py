import binascii

enc = binascii.unhexlify("a5b1aba79f09b5a3d78fb3010b0bd7fdf3c9d7a5b78dd7991905d7b7b50fd7b3018f8f0b85a3d70ba3ab89d701d7db09c393")
print("".join(chr((b ^ 0x69) >> 1) for b in enc))
