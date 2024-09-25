with open("wyvern_data.bin", "rb") as f:
    data = f.read()

secrets = [int.from_bytes(data[i:i+4], 'little') for i in range(0x14, 0x84, 4)]
offs = [secrets[0]] + [secrets[i] - secrets[i-1] for i in range(1, len(secrets))]

flag = "flag{" + (''.join(chr(o) for o in offs)) + "}"
print(flag)
