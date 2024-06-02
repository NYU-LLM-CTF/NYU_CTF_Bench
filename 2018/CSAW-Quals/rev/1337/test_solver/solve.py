import string
import itertools

magic1 = 0xbeb9e408e58575b0
magic2 = 0xb8f8437f04f80044
magic3 = 0xc227df7146b09474

test = "T3stT3St"
test_val = int(test[::-1].encode("hex"), 16)

def int_to_str(val):
    val = "{:016x}".format(val)
    return val.decode("hex")[::-1]

def mul(val):
    res = (val >> 62) + pow(5, val, 2 ** 64) - 1
    return res & 0xffffffffffffffff

def solve(num, lvl, magic, inputs):
    # Stop. If we consumed 8B we have a solution
    if lvl == 8:
        inputs.append(int_to_str(num)) 
        return

    # Prepare mask
    mask = 0xff
    for i in range(0, lvl):
        mask = (mask << 8) | 0xff 
    
    # Bruteforce
    for c in string.printable:
        test_num = ord(c) << ((lvl)*8) | num
        res = mul(test_num)
        # If input byte matches, go deeper
        if res & mask == magic & mask:
            solve(test_num, lvl+1, magic, inputs)


test_res = mul(test_val)
retrotest = []
solve(test_val & (1 << 62), 0, test_res, retrotest)
assert test == retrotest[0]

found1 = []
found2 = []
found3 = []

solve(0, 0, magic1, found1)
# solve(1 < 62, 0, magic1, found1)
solve(0, 0, magic2, found2)
# solve(1 < 62, 0, magic2, found2)
solve(0x0, 0, magic3, found3)
# solve(1 < 62, 0, magic3, found3)

for flag in itertools.product(found1, found2, found3):
    print ("flag{%s}" % ("".join(flag)))
