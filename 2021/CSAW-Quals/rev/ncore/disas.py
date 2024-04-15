
bs_ = open("ram.hex","r").readlines()[0].split()[:-3]
bs = [int(x,16) for x in bs_]
opcodes = {0:"ADD",1:"SUB",2:"AND",3:"OR",4:"RES",5:"MOVF",6:"MOVT",7:"ENT",8:"EXT",9:"JGT",10:"JEQ",11:"JMP",12:"INC",13:"MOVFS"}

for i in range(20):
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
        ops.append(op1)
        ops.append(op2)
    if mnem in ["INC"]:
        ops.append(f"R{op1}")
    if mnem == "JMP":
        ops.append(f"{b1}")
    if mnem == "MOVF":
        ops.append(f"R{op1}")
        ops.append(str(int(b1s[::-1],2)))
    if mnem == "MOVT":
        ops.append(f"R{op1}")
        ops.append(f"{b1}")
    print(f"{(2*i):3} : {bs_[2*i]} {bs_[2*i+1]} | {b0s} {b1s} | {mnem} {' '.join(ops)}")