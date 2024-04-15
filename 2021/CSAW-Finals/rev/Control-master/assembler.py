
import argparse
from dataclasses import dataclass
import struct

defs = '''
#define REG_r0_R_DATA (1 << 0)
#define REG_r0_W_DATA (1 << 1)
#define REG_r0_W_ADDR (1 << 2)

#define REG_r1_R_DATA (1 << 3)
#define REG_r1_W_DATA (1 << 4)
#define REG_r1_W_ADDR (1 << 5)

#define REG_r2_R_DATA (1 << 6)
#define REG_r2_W_DATA (1 << 7)
#define REG_r2_W_ADDR (1 << 8)

#define REG_r3_R_DATA (1 << 9)
#define REG_r3_W_DATA (1 << 10)
#define REG_r3_W_ADDR (1 << 11)

#define REG_sp_R_DATA (1 << 12)
#define REG_sp_W_DATA (1 << 13)
#define REG_sp_W_ADDR (1 << 14)

#define ALU_R_X (1 << 15)
#define ALU_R_Y (1 << 16)
#define ALU_ADD (1 << 18)
#define ALU_MUL (1 << 19)
#define ALU_SHF (1 << 17)
#define ALU_XOR (1 << 20)
#define ALU_EQ (1 << 21)

#define RAM_R (1 << 22)
#define RAM_W (1 << 23)

#define OUT_R (1 << 24)
#define IN_W (1 << 25)

#define ROM_W_IP (1 << 26)
#define ROM_W_ADDR (1 << 27)

#define IP_ADD_1 (1 << 28)
#define IP_ADD_2 (1 << 29)
#define IP_R_DATA (1 << 30)

#define HLT (1 << 31)
'''

defs = defs.strip().split('\n')
defs = [x for x in defs if x != '']
defs = [x[8:] for x in defs]

for d in defs:
    s = d.split(' ')
    v = s[0]
    t = eval(' '.join(s[1:]))
    
    globals()[v] = t

label_map = {}
label_warn = False

@dataclass
class Label(object):
    name: str
        
def lookup(lbl):
    if lbl in label_map:
        return label_map[lbl]
    else:
        if label_warn:
            print('Label error: ', lbl)
        return 0

def hlt():
    return [(HLT)]

def mov(dst, src):
    return eval(f'''[
        (REG_{src}_W_DATA | REG_{dst}_R_DATA | IP_ADD_1)
    ]''')

def li(dst, val):
    return eval(f'''[
        (REG_{dst}_R_DATA | ROM_W_IP | IP_ADD_2),
        ({val})
    ]''')

def la(dst, lbl):
    addr = lookup(lbl)
    return eval(f'''[
        (REG_{dst}_R_DATA | ROM_W_IP | IP_ADD_2),
        ({addr})
    ]''')

def addi(dst, val):
    return eval(f'''[
        (REG_{dst}_W_DATA | ALU_R_X | IP_ADD_1),
        (ROM_W_IP | ALU_R_Y | IP_ADD_2),
        ({val}),
        (ALU_ADD | REG_{dst}_R_DATA | IP_ADD_1)
    ]''')

def add(dst, dst2):
    return eval(f'''[
        (REG_{dst}_W_DATA | ALU_R_X | IP_ADD_1),
        (REG_{dst2}_W_DATA | ALU_R_Y | IP_ADD_1),
        (ALU_ADD | REG_{dst}_R_DATA | IP_ADD_1)
    ]''')

def xori(dst, val):
    return eval(f'''[
        (REG_{dst}_W_DATA | ALU_R_X | IP_ADD_1),
        (ROM_W_IP | ALU_R_Y | IP_ADD_2),
        ({val}),
        (ALU_XOR | REG_{dst}_R_DATA | IP_ADD_1)
    ]''')

def mul(dst, dst2):
    return eval(f'''[
        (REG_{dst}_W_DATA | ALU_R_X | IP_ADD_1),
        (REG_{dst2}_W_DATA | ALU_R_Y | IP_ADD_1),
        (ALU_MUL | REG_{dst}_R_DATA | IP_ADD_1)
    ]''')

def shifti(dst, val):
    return eval(f'''[
        (REG_{dst}_W_DATA | ALU_R_X | IP_ADD_1),
        (ROM_W_IP | ALU_R_Y | IP_ADD_2),
        ({val}),
        (ALU_SHF | REG_{dst}_R_DATA | IP_ADD_1)
    ]''')

def push(reg):
    return eval(f'''[
        (REG_{reg}_W_DATA | RAM_R | REG_sp_W_ADDR | IP_ADD_1),
        *addi('sp', -1)
    ]''')

def pushi(val):
    return eval(f'''[
        (ROM_W_IP | RAM_R | REG_sp_W_ADDR | IP_ADD_2),
        ({val}),
        *addi('sp', -1)
    ]''')

def pop(reg):
    return eval(f'''[
        *addi('sp', 1),
        (REG_{reg}_R_DATA | RAM_W | REG_sp_W_ADDR | IP_ADD_1)
    ]''')

def out(reg):
    return eval(f'''[
        (REG_{reg}_W_DATA | OUT_R | IP_ADD_1)
    ]''')

def inr(reg):
    return eval(f'''[
        (REG_{reg}_R_DATA | IN_W | IP_ADD_1)
    ]''')

def eqi(reg, val, ltrue, lfalse):
    addr_true = lookup(ltrue)
    addr_false = lookup(lfalse)
    
    return eval(f'''[
        (REG_{reg}_W_DATA | ALU_R_X | IP_ADD_1),
        (ROM_W_IP | ALU_R_Y | IP_ADD_2),
        ({val}),
        (ALU_R_X | ALU_EQ | IP_ADD_1),
        (ROM_W_IP | ALU_R_Y | IP_ADD_2),
        ({(addr_true - addr_false) & 0xffffffff}),
        (ALU_R_X | ALU_MUL | IP_ADD_1),
        (ROM_W_IP | ALU_R_Y | IP_ADD_2),
        ({addr_false}),
        (ALU_ADD | IP_R_DATA),
    ]''')

def eq(reg, reg2, ltrue, lfalse):
    addr_true = lookup(ltrue)
    addr_false = lookup(lfalse)
    
    return eval(f'''[
        (REG_{reg}_W_DATA | ALU_R_X | IP_ADD_1),
        (REG_{reg2}_W_DATA | ALU_R_Y | IP_ADD_1),
        (ALU_R_X | ALU_EQ | IP_ADD_1),
        (ROM_W_IP | ALU_R_Y | IP_ADD_2),
        ({(addr_true - addr_false) & 0xffffffff}),
        (ALU_R_X | ALU_MUL | IP_ADD_1),
        (ROM_W_IP | ALU_R_Y | IP_ADD_2),
        ({addr_false}),
        (ALU_ADD | IP_R_DATA),
    ]''')

def jmp(lbl):
    addr = lookup(lbl)
    
    return eval(f'''[
        (ROM_W_IP | IP_R_DATA),
        ({addr})
    ]''')

def ldm(reg, off):
    return eval(f'''[
        (REG_{off}_W_ADDR | ROM_W_ADDR | REG_{reg}_R_DATA | IP_ADD_1)
    ]''')

def load(reg, off):
    return eval(f'''[
        (REG_{off}_W_ADDR | RAM_W | REG_{reg}_R_DATA | IP_ADD_1)
    ]''')

def store(reg, off):
    return eval(f'''[
        (REG_{off}_W_ADDR | RAM_R | REG_{reg}_W_DATA | IP_ADD_1)
    ]''')

def call(lbl, ret_lbl):
    addr_r = lookup(ret_lbl)
    
    return eval(f'''[
        *pushi({addr_r}),
        *jmp("{lbl}")
    ]''')

def ret():
    return eval(f'''[
        *addi('sp', 1),
        (RAM_W | REG_sp_W_ADDR | IP_R_DATA)
    ]''')

def dbs(val):
    # raw string
    bs = eval(val)
    return list(bs)

@dataclass
class Instruction(object):
    op: str
        
    def enc(self):
        p = self.op.split(' ')[0]
        a = ' '.join(self.op.split(' ')[1:]).split(',')
        a = [x.strip() for x in a]
        a = [x for x in a if x != '']
        
        if p == 'dbs':
            a = [' '.join(self.op.split(' ')[1:])]

        return globals()[p](*a)

def preprocess(asm):
    out = []
    ret_idx = 0
    
    for a in asm:
        if type(a) is Instruction and a.op.startswith('call'):
            ret_lbl = f'_ret_{ret_idx}'
            out.append(Instruction(f'{a.op}, {ret_lbl}'))
            out.append(Label(ret_lbl))
            ret_idx += 1
        else:
            out.append(a)
            
    return out
    
def assemble(asm):
    global label_map
    global label_warn
    label_map = {}
    
    asm = asm.strip().split('\n')
    asm = [x.strip() for x in asm if x.strip() != '' and not x.strip()[0] == ';']
    asm = [Label(x[:-1]) if x.endswith(':') else Instruction(x) for x in asm]
    
    asm = preprocess(asm)
    
    # Generate bytecode.
    label_warn = False
    code = []
    for line in asm:
        if type(line) is Label:
            label_map[line.name] = len(code)
        else:
            code += line.enc()
            
    # Second pass, with full labels.
    label_warn = True
    code = []
    for line in asm:
        if type(line) is Label:
            label_map[line.name] = len(code)
        else:
            code += line.enc()
    
    enc = b''
    for c in code:
        enc += struct.pack('<I', c & 0xffffffff)

    return enc


def main(args):
    asm = open(args.input, 'r').read()
    enc = assemble(asm)
    open(args.output, 'wb').write(enc)


if __name__=='__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('input', help='Input assembly.')
    parser.add_argument('output', help='Output path.')
    args = parser.parse_args()

    main(args)
