from binaryninja import *
from operator    import *
from pprint      import *
from itertools   import chain


def compute_backbone_map(bv, mlil, state_var):
    # don't think too much about this...
    backbone = {}
    uses = mlil.get_var_uses(state_var)
    uses += mlil.get_var_uses(mlil[mlil.get_var_uses(mlil[mlil.get_var_uses(state_var)[0]].dest)[1]].dest)
    blks = (b for idx in uses for b in mlil.basic_blocks if b.start <= idx < b.end)
    for bb in blks:
        cond_var = bb[-1].condition.src
        cmp_il = mlil[mlil.get_var_definitions(cond_var)[0]]
        state = cmp_il.src.right.constant
        backbone[state] = bv.get_basic_blocks_at(bb[0].address)[0]
    return backbone


def compute_original_blocks(bv, mlil, state_var):
    original = mlil.get_var_definitions(state_var)
    return itemgetter(*original)(mlil)


def gather_full_backbone(backbone_map):
    backbone_blocks = backbone_map.values()
    backbone_blocks += [bb.outgoing_edges[1].target for bb in backbone_blocks]
    for bb in backbone_blocks:
        blk = bb
        while len(blk.outgoing_edges) == 1:
            if blk not in backbone_blocks:
                backbone_blocks.append(blk)
            blk = blk.outgoing_edges[0].target
    return set(backbone_blocks)


def safe_asm(bv, asm_str):
    asm = bv.arch.assemble(asm_str)
    return asm


g_backbone = { }
def deflatten_cfg(bv, addr):
    func = bv.get_basic_blocks_at(addr)[0].function
    mlil = func.medium_level_il
    state_var = func.get_low_level_il_at(addr).medium_level_il.dest
    backbone = compute_backbone_map(bv, mlil, state_var)
    original = compute_original_blocks(bv, mlil, state_var)

    foo = { }
    for i in original:
        a  = safe_asm(bv, "mov eax, {}".format(bv.get_disassembly(i.address).split(" ")[-1]))
        a += safe_asm(bv, "hlt")
        foo[i.address] = a
    for i in backbone:
        assert i not in g_backbone
        g_backbone[i] = backbone[i].outgoing_edges[0].target.start
    nop = safe_asm(bv, 'nop')
    for bb in gather_full_backbone(backbone):
        bv.write(bb.start, nop * bb.length)
    for i,j in foo.iteritems():
        bv.write(i,j)


def print_struct():
    print "typedef struct { uint32_t sw; uint64_t a; } OBF;"
    print "OBF guest_tbl[] = {"
    for i in g_backbone:
        print "    {{ 0x{:x}, 0x{:x} }},".format(i, g_backbone[i])
    print "};"
    print "int guest_tbl_len = {};".format(len(g_backbone))
