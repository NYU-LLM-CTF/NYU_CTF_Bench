from dataclasses import dataclass
from Crypto.Util.number import long_to_bytes, bytes_to_long
import hashlib, os, copy

def next_and_idx():
    if not hasattr(next_and_idx, "i"):
        next_and_idx.i = -1
    next_and_idx.i += 1
    return next_and_idx.i

def next_inv_idx():
    if not hasattr(next_inv_idx, "i"):
        next_inv_idx.i = -1
    next_inv_idx.i += 1
    return next_inv_idx.i

def H(b):
    return bytes_to_long(hashlib.sha256(b).digest()[:16][::-1])

def HH(a, b):
    return H(long_to_bytes(a)[::-1] + long_to_bytes(b)[::-1])

def rnd():
    return bytes_to_long(os.urandom(16))

class Circuit:
    def eval(self, inputs):
        if not hasattr(self, "_cache"):
            self._cache = self._eval(inputs)
        return self._cache

    def eval_garbled(self, inputs):
        if not hasattr(self, "_gcache"):
            self._gcache = self._eval_garbled(inputs)
        return self._gcache

    def garble(self, g=None):
        if g is None: g = {}
        if self.index in g: return
        if "R" not in g:
            g["R"] = rnd() | 1
        self._garble(g)
        if self.index not in g: g[self.index] = None
        return g

    def gen_c(self, f):
        if not hasattr(self, "_ccache"):
            self._ccache = self._gen_c(f)
        return self._ccache

@dataclass
class AND(Circuit):
    index: int
    a: Circuit
    b: Circuit
    def _eval(self, inputs):
        a = self.a.eval(inputs)
        b = self.b.eval(inputs)
        return a & b

    def _eval_garbled(self, inputs):
        a = self.a.eval_garbled(inputs)
        b = self.b.eval_garbled(inputs)
        idx = ((a & 1) << 1) | (b & 1)
        ctxt = ([0] + inputs[self.index])[idx]
        return HH(a, b) ^ ctxt

    def _garble(self, g):
        self.a.garble(g)
        self.b.garble(g)
        a = self.a.zero_wire
        b = self.b.zero_wire
        za = a ^ g["R"] if (a & 1) else a
        zb = b ^ g["R"] if (b & 1) else b
        self.zero_wire = HH(za, zb)
        if za != a and zb != b: self.zero_wire ^= g["R"]
        one_wire = self.zero_wire ^ g["R"]
        g[self.index] = [None for _ in range(4)]
        for i, _a in enumerate([a, a ^ g["R"]]):
            for j, _b in enumerate([b, b ^ g["R"]]):
                if i * j == 1:
                    w = one_wire
                else:
                    w = self.zero_wire
                g[self.index][((_a & 1) << 1) | (_b & 1)] = HH(_a, _b) ^ w

        assert g[self.index][0] == 0
        g[self.index].pop(0)

    def _gen_c(self, f):
        aname = self.a.gen_c(f)
        bname = self.b.gen_c(f)
        name = f"gate_{self.index}"
        and_idx = next_and_idx()
        f.write(f"""
        static elem {name}() {{
            static int done = 0;
            static elem cached = 0;
            if (done) return cached;
            done = 1;
            elem a = {aname}();
            elem b = {bname}();
            int idx = ((a & 1) << 1) | (b & 1);
            elem ctxt = 0;
            if (idx) ctxt = ANDGATE[{and_idx}][idx - 1];
            elem res = HH(a, b) ^ ctxt;
            HNode* p = seen_before[res & SEEN_MASK];
            while (p) {{
                if (p->e == res) abort();
                p = p->next;
            }}
            p = malloc(sizeof(HNode));
            p->e = res;
            p->next = seen_before[res & SEEN_MASK];
            seen_before[res & SEEN_MASK] = p;
            return cached = res;
        }}
        """)
        return name

@dataclass
class XOR(Circuit):
    index: int
    a: Circuit
    b: Circuit
    def _eval(self, inputs):
        a = self.a.eval(inputs)
        b = self.b.eval(inputs)
        return a ^ b
    
    def _eval_garbled(self, inputs):
        a = self.a.eval_garbled(inputs)
        b = self.b.eval_garbled(inputs)
        return a ^ b

    def _garble(self, g):
        self.a.garble(g)
        self.b.garble(g)
        self.zero_wire = self.a.zero_wire ^ self.b.zero_wire

    def _gen_c(self, f):
        aname = self.a.gen_c(f)
        bname = self.b.gen_c(f)
        name = f"gate_{self.index}"
        f.write(f"""
        static elem {name}() {{
            static int done = 0;
            static elem cached = 0;
            if (done) return cached;
            done = 1;
            elem a = {aname}();
            elem b = {bname}();
            elem res = a ^ b;
            HNode* p = seen_before[res & SEEN_MASK];
            while (p) {{
                if (p->e == res) abort();
                p = p->next;
            }}
            p = malloc(sizeof(HNode));
            p->e = res;
            p->next = seen_before[res & SEEN_MASK];
            seen_before[res & SEEN_MASK] = p;
            return cached = res;
        }}
        """)
        return name

@dataclass
class INV(Circuit):
    index: int
    a: Circuit
    def _eval(self, inputs):
        a = self.a.eval(inputs)
        return 1 - a

    def _eval_garbled(self, inputs):
        a = self.a.eval_garbled(inputs)
        return a ^ inputs[self.index]

    def _garble(self, g):
        self.a.garble(g)
        self.zero_wire = rnd()
        g[self.index] = self.zero_wire ^ self.a.zero_wire ^ g["R"]

    def _gen_c(self, f):
        aname = self.a.gen_c(f)
        name = f"gate_{self.index}"
        inv_idx = next_inv_idx()
        f.write(f"""
        static elem {name}() {{
            static int done = 0;
            static elem cached = 0;
            if (done) return cached;
            done = 1;
            elem a = {aname}();
            elem res = a ^ INVGATE[{inv_idx}];
            HNode* p = seen_before[res & SEEN_MASK];
            while (p) {{
                if (p->e == res) abort();
                p = p->next;
            }}
            p = malloc(sizeof(HNode));
            p->e = res;
            p->next = seen_before[res & SEEN_MASK];
            seen_before[res & SEEN_MASK] = p;
            return cached = res;
        }}
        """)
        return name

@dataclass
class Input(Circuit):
    index: int
    def _eval(self, inputs):
        return inputs[self.index]

    def _eval_garbled(self, inputs):
        return inputs[self.index]

    def _garble(self, g):
        self.zero_wire = rnd()
        g[self.index] = (self.zero_wire, self.zero_wire ^ g["R"])

    def _gen_c(self, f):
        name = f"gate_{self.index}"
        f.write(f"""
        static elem {name}() {{
            return INPUTS[{self.index}];
        }}
        """)
        return name

GATES = {"AND": AND, "XOR": XOR, "INV": INV}

def parse(f):
    ngates, nwires = map(int, f.readline().strip().split())
    niv, *nis = map(int, f.readline().strip().split())
    nov, *nos = map(int, f.readline().strip().split())
    f.readline() # Empty, skip
    gates = [Input(i) for i in range(sum(nis))] + [None for _ in range(nwires - sum(nis))]
    for j in range(ngates):
        i, o, *op, out, g = f.readline().strip().split()
        i = int(i)
        o = int(o)
        assert o == 1
        g = GATES[g]
        assert gates[int(out)] is None
        assert all(gates[int(x)] is not None for x in op)
        gates[int(out)] = g(j + sum(nis), *[gates[int(x)] for x in op])
    assert not any(x is None for x in gates)
    return gates[-sum(nos):]

def combine_g_inputs(g, inputs):
    g = copy.deepcopy(g)
    for i, inp in enumerate(inputs):
        g[i] = g[i][inp]
    return g

def garble(circ):
    g = circ[0].garble()
    for c in circ[1:]:
        c.garble(g)
    return g

def gen_c(circ, f):
    output_fns = []
    f.write('#include "common.h"\n')
    for o in circ:
        output_fns.append(o.gen_c(f))

    # write run_circuit
    f.write("void run_circuit() {\n    elem t; uint8_t *out = RESULT;\n")
    for i, o in enumerate(output_fns):
        f.write(f"""
            t = {o}();
            for (int i = 0; i < 2; i++) {{
                if (t == OUTPUT[{i}][i]) {{
                    *(out++) = '0' + i;
                    break;
                }}
            }}
        """)
    f.write("}")

if __name__ == "__main__":
    with open("./aes_128.txt") as f:
        circ = parse(f)
    from Crypto.Cipher import AES
    from Crypto.Util.number import *
    k = b"\x01" * 16
    m = bytes(range(ord("a"), ord("a") + 16))
    reference = bin(bytes_to_long(AES.new(k, AES.MODE_ECB).encrypt(m)))[2:].zfill(128)
    g = garble(circ)
    inputs = list(map(int, bin(bytes_to_long(k))[2:].zfill(128)[::-1])) + list(map(int, bin(bytes_to_long(m))[2:].zfill(128)[::-1]))
    print(reference)
    print(''.join(map(str, (int(x.eval_garbled(combine_g_inputs(g, inputs)) != x.zero_wire) for x in circ)))[::-1])

    with open("circ.c", "w") as f:
        gen_c(circ, f)
