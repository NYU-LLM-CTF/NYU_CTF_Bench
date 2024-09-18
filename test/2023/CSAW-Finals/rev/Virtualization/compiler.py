from pwn import *
from sys import argv

if len(argv) != 3:
    print("Usage: python3 compiler.py [mode, 1 = program.h, 2 = else.h] [input_file]")
    exit(0)

codes = ""

#with open("binsh.myasm", "r") as h:
#with open("pseudocode.myasm", "r") as h:
with open(argv[2], "r") as h:
    codes = h.read()

#populate label first
pc = 0
label = dict()
for i in codes.split("\n"):
    i = i.strip()
    #print(pc, i)

    #comments or blank line
    if len(i) < 1 or i[0] == ";":
        continue

    #labels
    if ":" in i:
        label[i.split(":")[0].strip()] = pc
        continue
    
    #commands
    pc += 1


ops_dict = {
    "push" : 0,
    "add"  : 4,
    "sub"  : 8,
    "xor"  : 12,
    "mov"  : 16,
    "inc"  : 20,
    "dec"  : 24,
    "cmp"  : 28,
    "jne"  : 32,
    "ret"  : 36,
    "call" : 40,
    "syscall" : 44,
    "special" : 48,
    "and"  : 52,
    "pop"  : 56,
}

registers = {
    'rax' : 1,
    'rbx' : 2,
    'rcx' : 3,
    'rdx' : 4,
    'rsi' : 5,
    'rdi' : 6,
    'rsp' : 7,
    'r8' : 8,
    'r9' : 9,
    'r10' : 10,
    'r11' : 11,
    'r12' : 12,
    'r13' : 13,
    'r14' : 14,
    'r15' : 15,
    'rbp' : 16
}

def convert_to_int(input_str):
    if input_str.strip().startswith("0x"):
        return int(input_str, 16)
    else:
        try:
            return int(input_str, 10)
        except ValueError:
            return None

#compile
pc = 0
code = b""
for i in codes.split("\n"):
    i = i.strip()
    print(pc, i)

    #comments or blank line
    if len(i) < 1 or i[0] == ";":
        continue

    #labels
    if ":" in i:
        continue

    #truncate the operands
    ops = i.split(" ")[0]
    operands = " ".join(i.split(" ")[1:])
    if len(operands.strip()) > 0:
        operands = operands.split(",")
    for i in range(len(operands)):
        operands[i] = operands[i].strip()
    
    opn = 1
    lhs,rhs,imm = 0,0,0

    #need to stamp label
    if ops == "call" or ops == "jne":
        lhs = (label[operands[0]] - pc - 1) * (4*8)
        opn = opn << ops_dict[ops]
        print(bin(opn).zfill(66), lhs, rhs, imm)
        if lhs < 0:
            lhs = 0xFFFFFFFFFFFFFFFF + 1 + lhs
        code += p64(opn) + p64(lhs) + p64(rhs) + p64(imm)
        
        #commands
        pc += 1
        continue



    #furnish lhs
    if len(operands) > 0:
        lhs = operands[0]
        if lhs[0] == 'e':
            lhs = 'r'+lhs[1:]
        if lhs[0] in {'a','b','c','d'}:
            lhs = 'r'+lhs[0]+'x'
        if lhs[0] == '[':
            processor = lhs.split("[")[1].split("]")[0]
            lhs = processor.split("+")[0]
            if len(processor.split("+")) > 1:
                imm = processor.split("+")[1]
                if convert_to_int(imm) != None:
                    imm = convert_to_int(imm)
                    opn |= 0b1000
                else:
                    imm = registers[imm]
                    opn |= 0b100

        if convert_to_int(lhs) != None:
            opn |= 0b10
            lhs = convert_to_int(lhs)
        else:
            lhs = registers[lhs]
    
    #furnish rhs
    if len(operands) > 1:
        rhs = operands[1]
        if rhs[0] == 'e':
            rhs = 'r'+rhs[1:]
        if rhs[0] in {'a','b','c','d'}:
            rhs = 'r'+rhs[0]+'x'
        if rhs[0] == '[': # special case
            processor = rhs.split("[")[1].split("]")[0]
            rhs = processor.split("+")[0]
            if len(processor.split("+")) > 1:
                imm = processor.split("+")[1]
                if convert_to_int(imm) != None:
                    imm = convert_to_int(imm)
                    opn |= 0b100
                else:
                    imm = registers[imm]
                    opn |= 0b1000
            # special case, mov rbx, [rsi+33]
            opn = 1
            opn = opn << ops_dict["special"]
            print(bin(opn).zfill(66), lhs, registers[rhs], imm)
            code += p64(opn) + p64(lhs) + p64(registers[rhs]) + p64(imm)
            pc+=1
            continue

        if convert_to_int(rhs) != None:
            imm = convert_to_int(rhs)
            rhs = convert_to_int(rhs)
            opn |= 0b10
        else:
            rhs = registers[rhs]

    opn = opn << ops_dict[ops]
    print(bin(opn).zfill(66), lhs, rhs, imm)
    code += p64(opn) + p64(lhs) + p64(rhs) + p64(imm)
    
    #commands
    pc += 1


print(label)

with open("program.h" if argv[1] == "1" else "else.h", "w") as h:
    writeto = f"int progsize = {len(code)};\n"

    writeto += "const char prog[] = {"
    for i in code:
        writeto += str(i) + ","
    writeto += "};"

    h.write(writeto)


