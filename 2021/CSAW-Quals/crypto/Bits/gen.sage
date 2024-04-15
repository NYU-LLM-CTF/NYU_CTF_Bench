NBITS = 508
NFACBITS = 30

def prd(f):
    return prod(p^e for p, e in f)

proof.arithmetic(False)
def get_prime():
    rp = lambda: random_prime(2^NFACBITS, lbound=2^(NFACBITS-1))
    power = NBITS//NFACBITS
    while True:
        factors = [(2,1), (rp(),power), (rp(), 1)]
        if is_prime(prd(factors) + 1):
            return factors

def multgen(p, factors):
    g = 2
    exponents = [(p - 1) // (f[0]^f[1]) for f in factors]
    while True:
        if all(pow(g, e, p) != 1 for e in exponents):
            return g
        g += 1

if __name__ == "__main__":
    ps = get_prime()
    qs = get_prime()
    p = prd(ps) + 1
    q = prd(qs) + 1

    assert gcd(p - 1, q - 1) == 2

    g1 = multgen(p, ps)
    assert GF(p)(g1).multiplicative_order() == p - 1
    g2 = multgen(q, qs)
    assert GF(q)(g2).multiplicative_order() == q - 1
    g = crt([ZZ(g1), ZZ(g2)], [p, q])
    print(f"""
{str(ps)}
{g1}
{str(qs)}
{g2}
""".strip())
