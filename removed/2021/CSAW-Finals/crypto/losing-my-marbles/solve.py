import pickle, random, hashlib

# Load the circuit as extracted in binja
with open("/tmp/marbles.pkl", "rb") as f:
    (output_nodes, raw) = pickle.load(f)

# Some sanity checking
and_base = min(v[1] for v in raw.values() if v[0] == "AND")
assert set((v[1] - and_base)//48 for v in raw.values() if v[0] == "AND") == set(range(6400))
inv_base = min(v[1] for v in raw.values() if v[0] == "INV")
assert set((v[1] - inv_base)//16 for v in raw.values() if v[0] == "INV") == set(range(2087))
input_base = min(v[1] for v in raw.values() if v[0] == "INPUT")
assert set((v[1] - input_base)//16 for v in raw.values() if v[0] == "INPUT") == set(range(256))

KEY = bytes(range(16))

def tob(x: int):
    return x.to_bytes(16, "little", signed=False)

def toi(x: bytes):
    return int.from_bytes(x, "little", signed=False)

def H(b):
    return toi(hashlib.sha256(b).digest()[:16])

def HH(a, b):
    return H(tob(a) + tob(b))

class Garbled:
    def __init__(self):
        self.inputs = [(None, None) for _ in range(256)]
        self.outputs = [(None, None) for _ in range(128)]
        self.and_gates = [(None, None, None) for _ in range(6400)]
        self.inv_gates = [None for _ in range(2087)]
        self.done = {}
        self.R = random.randrange(2**128) | 1

    def set_and(self, addr, a, b, c):
        self.and_gates[(addr - and_base)//48] = (a, b, c)

    def set_inv(self, addr, a):
        self.inv_gates[(addr - inv_base)//16] = a

    def set_input(self, addr, a, b):
        self.inputs[(addr - input_base)//16] = (a, b)

    def do(self, addr, lbl=None):
        if lbl is None:
            lbl = self.mklabel()
        elif isinstance(lbl, int):
            lbl = (lbl, lbl ^ self.R)
        return self.done.setdefault(addr, lbl)

    def mklabel(self):
        zero = random.randrange(2**128)
        one = zero ^ self.R
        return (zero, one)


garbled = Garbled()
def garble(addr):
    if addr in garbled.done: return garbled.done[addr]
    op, *args = raw[addr]
    if op == "XOR":
        a = garble(args[0])
        b = garble(args[1])
        zero = a[0] ^ b[0]
        return garbled.do(addr, zero)
    elif op == "INV":
        a = garble(args[1])
        r = random.randrange(2**128)
        garbled.set_inv(args[0], r)
        return garbled.do(addr, a[0] ^ r ^ garbled.R)
    elif op == "INPUT":
        res = garbled.do(addr)
        garbled.set_input(args[0], *res)
        return res
    elif op == "AND":
        a = garble(args[1])
        b = garble(args[2])
        za = a[a[0] & 1]
        zb = b[b[0] & 1]
        zero = HH(za, zb)
        one = zero ^ garbled.R
        if za != a[0] and zb != b[0]:
            zero, one = one, zero
        table = [None for _ in range(4)]
        for i, _a in enumerate(a):
            for j, _b in enumerate(b):
                w = [zero, one][i and j]
                table[((_a & 1) << 1) | (_b & 1)] = HH(_a, _b) ^ w
        assert table[0] == 0
        garbled.set_and(args[0], *table[1:])
        return garbled.do(addr, (zero, one))
    else:
        assert False, "UNKNOWN GATE"

def eval(addr):
    if addr in garbled.done: return garbled.done[addr]
    def inner():
        op, *args = raw[addr]
        if op == "XOR":
            a = eval(args[0])
            b = eval(args[1])
            return a ^ b
        elif op == "INV":
            a = eval(args[1])
            return a ^ garbled.inv_gates[(args[0] - inv_base) // 16]
        elif op == "INPUT":
            I = (args[0] - input_base)//16
            return garbled.inputs[I][INPUT[I]]
        elif op == "AND":
            a = eval(args[1])
            b = eval(args[2])
            ctxt = 0
            idx = ((a & 1) << 1) | (b & 1)
            if idx != 0:
                ctxt = garbled.and_gates[args[0]//48][idx - 1]
            return ctxt ^ HH(a, b)
        else:
            assert False, "UNKNOWN GATE"
    garbled.done[addr] = inner()
    return garbled.done[addr]


for i, o in enumerate(output_nodes):
    garbled.outputs[i] = garble(o)

# Our key as first input
def output(break_ones, break_all):
    out = []
    for i, k in enumerate(KEY[::-1]):
        for j in range(8):
            out.append(garbled.inputs[i * 8 + j][k & 1])
            k >>= 1

    # The flag input labels
    out += sum(map(list, garbled.inputs[128:]), [])

    # AND gates
    out += sum(map(list, garbled.and_gates), [])

    # INV gates
    out += garbled.inv_gates

    # output gates
    for i, o in enumerate(garbled.outputs):
        if i in break_all:
            out += [random.randrange(2**128), random.randrange(2**128)]
        elif i in break_ones:
            out += [o[0], random.randrange(2**128)]
        else:
            out += list(o)

    return b''.join(o.to_bytes(16, "little") for o in out)

from pwn import process, remote, args
def start():
    if args.HOST and args.PORT:
        return remote(args.HOST, args.PORT)
    return process("./losing_my_marbles")
def oracle(a, b):
    io = start()
    io.send(output(a, b))
    res = len(io.recvline().strip())
    io.close()
    return res

bits = ""
reference = oracle([], [])
BREAK = len("Here you go: ") % 16
for i in range(128 - BREAK):
    bits += str(int(oracle([i], range(128 - BREAK, 128)) < reference))
for i in range(128 - BREAK, 128):
    bits += str(int(oracle([i], range(BREAK)) < reference))

print(bits, len(bits))
from Crypto.Cipher import AES
from Crypto.Util.number import long_to_bytes
print(AES.new(KEY, AES.MODE_ECB).decrypt(long_to_bytes(int(bits[::-1], 2)).rjust(16, b"\0"))[::-1])
