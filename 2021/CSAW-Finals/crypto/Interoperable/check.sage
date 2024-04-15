# NIST P256 details
p_NIST =  2^256 - 2^224 + 2^192 + 2^96 - 1
a_NIST = -0x3
b_NIST =  0x5ac635d8aa3a93e7b3ebbd55769886bc651d06b0cc53b0f63bce3c3e27d2604b
E_NIST = EllipticCurve(GF(p_NIST), [a_NIST, b_NIST])
Gx = 0x6b17d1f2e12c4247f8bce6e563a440f277037d812deb33a0f4a13945d898c296
Gy = 0x4fe342e2fe1a7f9b8ee7eb4a7c0f9e162bce33576b315ececbb6406837bf51f5
G_NIST = E_NIST(Gx, Gy)
 
# secp256k1 details
p_secp = 2^256 - 2^32 - 977
a_secp = 0x0
b_secp = 0x7
E_secp = EllipticCurve(GF(p_secp), [a_secp, b_secp])

# Px = 0x5cea790ab92b4d49dde2568e60e6ed5512d9f4bdb58e76682afe4a92f9e10a8a
# Py = 0x9fcbb5d437d75b0616acd28824e27f58eb125917023a09678118ec3bf34cc8e8
Px = 0x9d80c0d5fadc37cd6bd6a8a227060347b22759b99e651e8d7ca02e5912f8cb89
Py = 0x8559ff52fe197ebccbbac18b08d2357db9d01a7952c28a9c8a918fa9bd58e3dc
P = E_secp(Px, Py)

# Compute the offset for the new curve
# E_new = x^3 - 3x + B + offset
R.<x,y> = PolynomialRing(GF(p_NIST))
f = y^2 - (x^3 + a_NIST*x + b_NIST)
offset = Integer(f(x=Px, y=Py))
 
# Check this works!!
g = y^2 - (x^3 + a_NIST*x + b_NIST + offset)
assert g(x=Px, y=Py) == 0
 
# This is the curve we'll be essentially working on
E_new = EllipticCurve(GF(p_NIST), [a_NIST, b_NIST + offset])
P_new = E_new(Px, Py)

print(E_new)
print(P_new.order())
print(ecm.factor(P_new.order()))
exit()
# Let's look at the order of the curve, if this has small
# factors, we can obtain secrets by using PH.
P_order = P_new.order()
P_factors = ecm.factor(P_order)
print(f"New curve: {E_new}")
print(f"Invalid point order: {P_order}")
print(f"Invalid point order: {P_factors}")

# lets see how long the discrete log problem takes
d = randint(1, P_order)
Q = d*P_new

print(d)
print(Q)

exit()
dlogs = []
for factor in P_factors:
    print(f'Working on factor: {factor}')
    tmp = P_order // factor
    P_tmp = tmp*P_new
    Q_tmp = tmp*Q
    d_test = discrete_log_lambda(Q_tmp, P_tmp, (0,factor), '+')
    # For testing
    assert d_test == (d % factor)
    dlogs.append(d_test)
    print(f"Current progress")
    print(dlogs)

d0 = crt(dlogs,P_factors)
print(d0)
print(d0*P_new == Q)
