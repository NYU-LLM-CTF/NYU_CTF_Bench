# Can be run either through the binja snipped editor plugin or just in a binja python shell
import pickle
seen = {}
def recurse(fn):
    if isinstance(fn, list):
        return list(map(recurse, fn))
    if fn.lowest_address in seen: return seen[fn.lowest_address]
    def inner():
        t = len(fn.callees)
        if t == 0: # INPUT gate: no calls
            inp_addr = fn.get_constants_referenced_by(fn.lowest_address + 0xb)[-1].value
            return ("INPUT", inp_addr)
        elif t == 3: # INV gate: upstream gate, malloc, abort
            mask_addr = fn.get_constants_referenced_by(fn.lowest_address + 0x67)[-1].value
            recurse(fn.callees[0])
            return ("INV", mask_addr, fn.callees[0].lowest_address)
        elif t == 4: # XOR gate: upstream gates, malloc, abort
            recurse(fn.callees[:2])
            return ("XOR", fn.callees[0].lowest_address, fn.callees[1].lowest_address)
        elif t == 5: # AND gate: upstream gates, hash, malloc, abort
            recurse(fn.callees[:2])
            # Do some hacky MLIL parsing because the offset does weirder things for the first occurence
            # At least we can assume the CFG should be (roughly) the same
            bb = list(fn.mlil.basic_blocks)[4]
            first_load = [I.operands[1] for I in bb if len(I.operands) > 1 and I.operands[1].operation == MediumLevelILOperation.MLIL_LOAD][0]
            table_offset = first_load.operands[0].operands[1].value.value
            return ("AND", table_offset, fn.callees[0].lowest_address, fn.callees[1].lowest_address)
        else:
            assert False, "Unknown gate type"
    seen[fn.lowest_address] = inner()
    return seen[fn.lowest_address]

main = bv.get_function_at(bv.symbols['main'][0].address)
master_circuit = main.callees[8]
recurse(master_circuit.callees)
print("Done, saving")
with open("/tmp/marbles.pkl", "wb") as f:
    pickle.dump(([c.lowest_address for c in master_circuit.callees], seen), f)
print("All done")
