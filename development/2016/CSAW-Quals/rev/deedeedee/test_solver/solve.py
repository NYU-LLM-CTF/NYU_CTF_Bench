from itertools import cycle

keys = [str(x) for x in range(1, 500)]
enc = bytearray.fromhex("676c60677a74326d716c6074325f6c6575347172316773616c6d686e665f68735e6773385e345e3377657379316e327d")

for key in keys:
    enc_add = len(enc) & 0xFF;
    for i in range(len(enc)):
        enc[i] ^= enc_add ^ ord(key[i % len(key)])

print(enc.decode('utf-8'))
