h = open("qr_code.txt", "r")

h = h.read()

size = 0
for i in h.split():
    binn = bin(int(i))[2:]
    size = max(len(binn), size)

for i in h.split():
    binn = bin(int(i))[2:].zfill(29)
    for i in binn:
        print(chr(9608) if i == "1" else " ", end="")
    print()


