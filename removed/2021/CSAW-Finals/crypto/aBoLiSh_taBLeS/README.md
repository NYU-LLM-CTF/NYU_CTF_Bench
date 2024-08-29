# aBoLiSh taBLeS

## Author

CryptoHack (jack and Robin_Jadoul)

## Description

I believe that DLOG > CDH > DDH, strictly. So to increase security, I never reveal my signatures.

## Distribution to players

- `chal.sage` --> md5: 474d1e9b3b3e9fcda799a243cff9de74
- network connection to the running challenge

## Deploying

See `Dockerfile`

## Solution

This challenge is based on the BLS signing algorithm using BLS curves. Usually, all points used in the signing protocol on `BLS12381` curves are in the r-torsion of `G1` and `G2`. As `r` is a large prime, this makes solving the discrete log problem infeasible, ensuring the security of the signatures.

The vulnreability of this challenge is located in the `hash_to_point()` function. Instead of taking a message and lifting it to a point in the r-torsion of `G2`, it lifts it instead to a generic point on `E2`. Additional insecurities come from the fact the secret is relatively small (70 bits). We note that the algorithm still works as we lift the points into the r-torsion with the additional scalar multiplication by the cofactor

```py
def lift_E2_to_E12(self, P):
    """
    Lift point on E/F_{q^2} to E/F_{q_12} through the sextic twist
    """
    assert P.curve() == E2, "Attempting to lift a point from the wrong curve."
    xs, ys = [c.polynomial().coefficients() for c in (h2*P).xy()] # notice the multiplication by h2 here.
    nx = F12(xs[0] - xs[1] + w ^ 6*xs[1])
    ny = F12(ys[0] - ys[1] + w ^ 6*ys[1])
    return E12(nx / (w ^ 2), ny / (w ^ 3))
```

The cofactor of `G2`, in our code called `h2`, factorises as:

```python
sage: factor(0x5d543a95414e7f1091d50792876a202cd91de4547085abaa68a205b2e5a7ddfa628f1cb4d9e82ef21537e293a6691ae1616ec6e786f0c70cf1c38e31c7238e5)                                                                                           
13^2 * 23^2 * 2713 * 11953 * 262069 * 402096035359507321594726366720466575392706800671181159425656785868777272553337714697862511267018014931937703598282857976535744623203249
```

Although there is another large prime here, we see that the cofactor has several small factors `[13, 23, 2713, 11953, 262069]` and if we can force a message to lie in a subgroup of these orders we can perform a subgroup confinement attack to learn bits of the private key. Roughly, the product of these factors is approximately 50 bits, which is what we could hope to recover from this attack using the Chinese remainder theorem.

Studying `hash_to_point()`

```py
def hash_to_point(self, msg):
    i = 0
    m = int(msg, 16)
    Hm = self.hash(i, msg)
    while True:
        try:
            Hmx = int(Hm, 16) % p
            return m*E2.lift_x(Hmx)
        except:
            i += 1
            i %= 256
            Hm = self.hash(i, Hm)
```

We see that the returned value is `m*E2.lift_x(Hmx)`. This means that if we make `m` a multiple of `P.order() / f`, then we should find a point of order `f`. Our goal is to find points which have the order of all the small factors of `h2`, which we can do with the following code:

```py
for f in n_factors:
    tmp = (r*h2) // f
    msg = hex(tmp)[2:].zfill(250)
    while True:
        P = bls_local.hash_to_point(msg)
        if P == E2(0,1,0):
            print("Got unlucky and made a bad point...")
            tmp *= 2
            msg = hex(tmp)[2:].zfill(250)
            continue
        assert f*P == E2(0,1,0)
        low_order.append(P)
        break
```

With these low order points, we can then easily solve the discrete log problem, as there are at most `f` options to pick as we learn the values of `d mod f` for all small factors `f`.

Solving the discrete log problem on the curve `E2` is however further complicated as we do not have access to the signature, but only a commitment of the signature which is of the form `g^f(P) mod q`, where `q` is a 512-bit safe prime, g is a generator of the prime order subgroup and `f(P)` is a function which takes a point on `E2` and returns an integer.

To recover `d mod p` for each prime factor of the cofactor `h2`, we must then perform a linear search for `j*P` for `j in [0,p-1]`, compute the commitment to the same point and then compare to the commitment we obtain from the server. These will be the same when `j = d mod p`. This linear search is slow, but as the cofactors are so small this is still feasible.

Recovering partial information from the subgroup attack should recover 50 bits of the 70 total bits of the secret. To recover the final 20 bits, we can perform one last linear search with a generic point of large order using that we know the secret is of the form:

```python
dlogs = [...small subgroup attack]
factors = [13, 23, 2713, 11953, 262069]
partial_d = crt(dlogs, factors)
n = prod(factors)

d = partial_d + x*n
```

For some unknown `x`.

Performing this last linear search, the secret `d` is recovered. The challenge is solved by taking the challenge message: `https://cryptohack.org` and computing the corresponding point `P_challenge` and signing it by computing `[d]P_challenge`. 

The full solution in `solve.sage` is (somewhat) carefully commented.







