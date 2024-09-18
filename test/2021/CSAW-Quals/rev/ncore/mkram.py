

f = open("ram.hex","w")
f.write(" ".join([format(i,'x') for i in range(256)]))