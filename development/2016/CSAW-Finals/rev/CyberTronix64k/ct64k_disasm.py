import struct
import sys

u16 = lambda x: struct.unpack('<H', x)[0]

INSTRUCTION_NAMES = [
    'MI',
    'MV',
    'MD',
    'LD',
    'ST',
    'AD',
    'SB',
    'ND',
    'OR',
    'XR',
    'SR',
    'SL',
    'SA',
    'JG',
    'JL',
    'JQ',
]

# ARITH instructions are those that take two operands.
ARITH_INSTRUCTIONS = [
    'MI', 'MV', 'MD', 'LD', 'ST', 'AD', 'SB',
    'ND', 'OR', 'XR', 'SR', 'SL', 'SA',
]

# JUMP instructions are instructions take 3 operands
JUMP_INSTRUCTIONS = [
    'JG', 'JL', 'JQ'
]

def format_hex(raw):
    return ' '.join('{:02x}'.format(c) for c in raw)

class CT64Instruction(object):
    def __init__(self, name, opcode, addr, rm=None, imm=None, mem=None, raw=None):
        self.name = name
        self.opcode = opcode
        self.addr = addr
        self.rm = rm
        self.imm = imm
        self.mem = mem
        self.raw = raw

    def __str__(self):
        if self.name in ARITH_INSTRUCTIONS:
            if self.name == 'MI':
                return '({}) {} 0x{:04x}, 0x{:04x}'.format(format_hex(self.raw), self.name, self.rm, self.imm)
            else:
                return '({}) {} 0x{:04x}, 0x{:04x}'.format(format_hex(self.raw), self.name, self.rm, self.mem)
        elif self.name in JUMP_INSTRUCTIONS:
            return '({}) {} 0x{:04x}, 0x{:04x}, 0x{:04x}'.format( format_hex(self.raw), self.name, self.rm, self.mem, self.imm)
        else:
            return '{}'.format(self.name)

def redirects_control_flow(instr):
    is_jump = instr.name in JUMP_INSTRUCTIONS
    is_mi_and_modifies_ip = instr.name == 'MI' and instr.rm == 0
    targets = None
    if is_jump:
        targets = [instr.imm]
    elif is_mi_and_modifies_ip:
        targets = [instr.imm]
    return targets

def decode_arith(code, addr):
    """
    decode an ARITH instruction at beginning of code
    """
    if len(code) < 4:
        raise ValueError("not enough bytes")
    raw = code[0:4]
    opcode = (u16(code[0:2]) & 0xF000) >> 12
    name = INSTRUCTION_NAMES[opcode]
    rm = u16(code[0:2]) & 0x0FFF
    mem = u16(code[2:4])
    imm = u16(code[2:4])
    # MI has an imm, everything else doesn't
    if name == 'MI':
        return CT64Instruction(name=name, opcode=opcode, addr=addr, rm=rm, imm=imm, raw=raw)
    else:
        return CT64Instruction(name=name, opcode=opcode, addr=addr, rm=rm, mem=mem, raw=raw)

def decode_jump(code, addr):
    """
    decode a JUMP instruction at beginning of code
    """
    if len(code) < 6:
        raise ValueError("not enough bytes")
    raw = code[0:6]
    opcode = (u16(code[0:2]) & 0xF000) >> 12
    name = INSTRUCTION_NAMES[opcode]
    rm = u16(code[0:2]) & 0x0FFF
    mem = u16(code[2:4])
    imm = u16(code[4:6])
    # special handling for HF
    if opcode == 0xF and rm == 0 and mem == 0 and imm == addr:
        return CT64Instruction(name=name, opcode=opcode, addr=addr, rm=rm, mem=mem, imm=imm, raw=raw)
    else:
        return CT64Instruction(name=name, opcode=opcode, addr=addr, rm=rm, mem=mem, imm=imm, raw=raw)


def disassemble_at(code, addr):
    """
    returns a (instr, width) tuple 
    """
    opcode = (u16(code[0:2]) & 0xF000) >> 12
    mneumonic = INSTRUCTION_NAMES[opcode]
    if mneumonic in ARITH_INSTRUCTIONS:
        size = 2
        instr = decode_arith(code, addr)
    elif mneumonic in JUMP_INSTRUCTIONS:
        size = 3
        instr = decode_jump(code, addr)
    else:
        raise ValueError("Unknown opcode: {}, {}".format(mneumnoic, opcode))
    return (instr, size)

def disasm(code):
    """
    Return a dictionary of address -> CT64Instruction
    """
    base_addr = 0x1000
    curr_offset = 0x0
    instrs = []
    last_instr = None
    try:
        while not last_instr or last_instr.name != 'HF' and code[curr_offset:]:
            instr, size = disassemble_at(code[curr_offset:], base_addr + curr_offset)
            instrs.append(instr)
            curr_offset += size*2 # double because size is in words, we need bytes
            last_instr = instr
            control_flow_targets = redirects_control_flow(instr)
            print(hex(instr.addr), instr)
            if control_flow_targets:
                print(','.join(map(hex, control_flow_targets)))
    except ValueError:
        pass # not enough bytes
    return instrs

if __name__ == '__main__':
    with open(sys.argv[1], 'rb') as f:
        rom = f.read()
    instrs = disasm(rom)
