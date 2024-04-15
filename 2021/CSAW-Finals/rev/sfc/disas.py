
opcodes = {0:"ADD",1:"SUB",2:"MOVF",3:"MOVT",4:"ENT",5:"EXT",6:"JGT",7:"JEQ",8:"JMP",9:"INC",10:"MOVFS",11:"FLUSH",12:"RDTM",13:"MOVFU", 14:"MOVFI", 15:"MOVFSI"}

mnem2opc = dict()
for k,v in opcodes.items():
    mnem2opc[v] = k

def assem(filein = "prog.asm",fileo = "ram.hex"):
    fo = open(fileo,"w")
    lines = open(filein,"r").readlines()
    for l in lines:
        l = l.strip() 
        chs = l.split()
        opc = chs[0]
        if opc not in mnem2opc:
            fo.write(f"{l.strip()} ")
            continue
        b0 = 0 + mnem2opc[opc]
        b1 = 0
        if opc in ["ADD","SUB"]:
            r0 = int(chs[1][1:])
            r1 = int(chs[2][1:])
            r2 = int(chs[3][1:])
            b0 += r0*16
            b0 += r1*64
            b1 += r2
        if opc in ["INC","RDTM"]:
            r0 = int(chs[1][1:])
            b0 += r0*16
        if opc in ["MOVF","MOVT","MOVFU","MOVFS"]:
            r0 = int(chs[1][1:])
            b0 += r0*16
            b1 += int(chs[2])
        if opc in ["MOVFSI","MOVFI"]:
            r0 = int(chs[1][1:])
            r1 = int(chs[2][1:])
            b0 += r0*16
            b0 += r1*64
            b1 += int(chs[3])
        if opc in ["JGT","JEQ"]:
            r0 = int(chs[1][1:])
            r1 = int(chs[2][1:])
            tgt = int(chs[3])
            b0 += r0*16
            b0 += r1*64
            b1 += tgt
        if opc == "JMP":
            tgt = int(chs[1])
            b1 += tgt
        fo.write(f"{hex(b0)[2:]} {hex(b1)[2:]} ")

        
def disas(file="ram.hex"):
    bs_ = open(file,"r").readlines()[0].split()
    bs = [int(x,16) for x in bs_]

    for i in range(20):
        if (2*i+1)>=len(bs):
            return
        b0 = bs[2*i]
        b1 = bs[2*i+1]
        b0s = "{0:08b}".format(b0)
        b1s = "{0:08b}".format(b1)
        opc = int(b0s[-4:],2)
        mnem = "UNK"
        ops = []
        if opc in opcodes:
            mnem = opcodes[opc]
        op1 = str(int(b0s[2:4],2))
        op2 = str(int(b0s[0:2],2))

        if mnem in ["ADD","SUB"]:
            ops.append(f"R{op1}")
            ops.append(f"R{op2}")
        if mnem in ["MOVFSI"]:
            ops.append(f"R{op1}")
            ops.append(f"R{op2}")
            ops.append(f"{b1}")
        if mnem in ["INC","RDTM"]:
            ops.append(f"R{op1}")
        if mnem == "JMP":
            ops.append(f"{b1}")
        if mnem in ["JGT","JEQ"]:
            ops.append(f"R{op1}")
            ops.append(f"R{op2}")
            ops.append(f"{b1}")
        if mnem == "MOVF" or mnem == "MOVFU":
            ops.append(f"R{op1}")
            ops.append(str(int(b1s[::-1],2)))
        if mnem == "MOVT":
            ops.append(f"R{op1}")
            ops.append(f"{b1}")
        print(f"{(2*i):3} : {bs_[2*i]} {bs_[2*i+1]} | {b0s} {b1s} | {mnem}  {' '.join(ops)}")

assem("prog.asm","ram.hex")
disas()