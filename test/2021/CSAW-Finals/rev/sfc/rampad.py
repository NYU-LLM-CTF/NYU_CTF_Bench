f = open("ram.hex","r")
sx = f.readline().strip().split()
n = len(sx)
for i in range(0xFF-n):
    sx.append(f"{hex(i)[2:]}")
f.close()
f = open("ram.hex","w")
f.write(" ".join(sx))