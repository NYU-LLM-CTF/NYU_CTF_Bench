import os, pickle, functools
import rzpipe

info = functools.partial(print, "[*]")

def callees(f):
    return [o.xrefs_from[0].addr for o in rz.cmdJ(f"pdfj @ {f}").ops if o.type == "call"]

def recurse(addr):
    if isinstance(addr, list):
        return list(map(recurse, addr))
    if addr in seen: return seen[addr]

    def inner():
        cls = callees(addr)
        t = len(cls)
        if t == 0: # INPUT gate: no calls
            inp_addr = rz.cmdJ(f"pdfj @ {addr}").ops[3].ptr
            return ("INPUT", inp_addr)
        elif t == 3: # INV gate: upstream gate, malloc, abort
            recurse(cls[0])
            dis = rz.cmdJ(f"pdfj @ {addr}")
            mov = [o for o in dis.ops if o.disasm.startswith("mov rsi")][0]
            mask_addr = int(mov.disasm.split("[")[1][:-1], 16)
            return ("INV", mask_addr, cls[0])
        elif t == 4: # XOR gate: upstream gates, malloc, abort
            recurse(cls[:2])
            return ("XOR", cls[0], cls[1])
        elif t == 5: # AND gate: upstream gates, hash, malloc, abort
            recurse(cls[:2])
            dis = rz.cmdJ(f"pdfj @ {addr}")
            jmp = [i for i, o in enumerate(dis.ops) if o.type == "cjmp"][1]
            table_offset = int(dis.ops[jmp+6].opcode.split(" + ")[1][:-1], 16)
            return ("AND", table_offset, cls[0], cls[1])
        else:
            assert False, "Unknown gate type"
    seen[addr] = inner()
    return seen[addr]

rz = rzpipe.open("losing_my_marbles")

if os.path.exists("marbles.rzdb"):
    info("Loading stored analysis")
    rz.cmd("Po marbles.rzdb")
else:
    info("Starting initial analysis")
    rz.cmd("aaa")
    # info("Defining main")
    # for x in rz.cmdJ("pdj @ entry0"):
    #     if x.disasm.startswith("lea rdi"):
    #         main = x.ptr
    #         break
    # else:
    #     assert False
    # rz.cmd(f"af main @ {main}")
    rz.cmd("Ps marbles.rzdb")

output_bits = callees(callees("main")[-2])
info("Starting the recursion")
seen = {}
recurse(output_bits)
info("Done, saving")
with open("/tmp/marbles.pkl", "wb") as f:
    pickle.dump((output_bits, seen), f)
info("All done")
