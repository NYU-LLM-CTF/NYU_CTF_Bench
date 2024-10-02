import random
L = 500
cnum = 100
with open("./dict") as f:
    lines = f.readlines()
with open("../samples",'w') as f:
    for x in range(cnum):
        ct = 0
        s = "" 
        while(ct<L):
            idx = random.randint(0,len(lines)-1)
            s+=lines[idx][:-1]+" "
            ct+=len(lines[idx])
        f.write(s[:L]+'\n')

