from pwn import *

def patch(routine):
    with open(routine[0], "r") as f:
        f.seek(routine[2])
        bytestr = f.read(routine[4])
    print "writing " + "".join([x.encode("hex") for x in bytestr])
    with open(routine[1], "r+b") as f:
        f.seek(routine[3])
        f.write(bytestr)

def patch_const(routine):
    print "writing " + "".join([x.encode("hex") for x in routine[2]])
    with open(routine[0], "r+b") as f:
        f.seek(routine[1])
        f.write(routine[2])


def find_pattern(fn, pstr):
    with open(fn, "r") as f:
        raw = f.read()
        off = raw.find(pstr)
        if off == -1:
            print "couldn't find pattern " + pstr
            exit(0)
        return off

#source file, target file, source offset, target offset, length
e = ELF("bomblab")

print find_pattern("phase1_64", "yote") - 0x54
print find_pattern("phase2_64", "yote") - 0xb0
raw_input("Press enter to continue patching...")
routines = [
        ["phase1_64", "bomblab", 0x54, find_pattern("bomblab", "pch1")-0x1, find_pattern("phase1_64", "yote")-0x54],
        ["phase2_64", "bomblab", 0xb0, find_pattern("bomblab", "pch2")-0x1, find_pattern("phase2_64", "yote")-0xb0]
        ]


# target file, target offset, value
const_routines = [
        ["phase1_64", find_pattern("phase1_64", "con1"), p32(e.symbols["omae"])],
        ["phase1_64", find_pattern("phase1_64", "con2"), p32(e.symbols["omae"]+0x8)],
        ["phase1_64", find_pattern("phase1_64", "con3"), p32(e.symbols["omae"]+0x10)],
        ["phase1_64", find_pattern("phase1_64", "con4"), p32(e.symbols["omae"]+0x18)],
        ["phase1_64", find_pattern("phase1_64", "jmp1"), p32(find_pattern("bomblab", "pch1")+0x08048000-0x1+0x7)],
        ["phase1_64", find_pattern("phase1_64", "jmp2"), p32(e.symbols["fptrs"])], #points to fptrs
        ["phase1_64", find_pattern("phase1_64", "jmp3"), p32(e.symbols["fptrs"]+0x16)], #points to fptrs+8
        ["phase2_64", find_pattern("phase2_64", "con5"), p32(e.symbols["p2_pass"])],
        ["phase2_64", find_pattern("phase2_64", "jmp4"), p32(find_pattern("bomblab", "pch2")+0x08048000-0x1+0x115)],
        ["phase2_64", find_pattern("phase2_64", "jmp5"), p32(e.symbols["fptrs"]+0x28)], #points to fptrs
        ["bomblab", e.symbols["fptrs"]-0x08048000, p64(find_pattern("bomblab", "pch1") + find_pattern("phase1_64", "con3")-0x54+0x08048000-0x3) + p64(0x23)],
        ["bomblab", e.symbols["fptrs"]+0x16-0x08048000, p64(find_pattern("bomblab", "pch1") + find_pattern("phase1_64","\xc7\x04\x24\x00\x00\x00\x00")-0x1-0x54+0x08048000)+p64(0x23)], #mov DWORD [esp], 0x0
        ["bomblab", e.symbols["fptrs"]+0x28-0x08048000, p64(find_pattern("bomblab", "pch2") + find_pattern("phase2_64","\x90\x90\x90\x90\x90\x90\x90")-0x1-0xb0+0x08048000)+p64(0x23)], #mov DWORD [esp], 0x0
        ]

for routine in const_routines:
    print "current const routine: "
    print routine
    patch_const(routine)
for routine in routines:
    print "current routine: "
    print routine
    patch(routine)
