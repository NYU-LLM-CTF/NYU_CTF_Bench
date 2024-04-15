# Curve parameters --> Replace the next three lines with given values
p = 625276251724681468065787127391468008213949163 
a = 625276251724681468065787127391468008213949162 
b = 0

# Define curve
E = EllipticCurve(GF(p), [a, b])
order = E.order()
print(is_prime(order))

# Replace the next two lines with given values
P1 = E(106475251480616516532312035568555890205578047 , 431897649280430503785680130194791468278435206)
P2 = E(325210632278386769754263691768220745652895158 , 308687159471094662490925278095484225164835682)
n = P1.order()

k = 1
while (p**k - 1) % order:
	k += 1

K.<a> = GF(p**k)
EK = E.base_extend(K)
PK = EK(P2)
GK = EK(P1)

while True:
	R = EK.random_point()
	m = R.order()
	d = gcd(m,n)
	Q = (m//d)*R
	if n / Q.order() not in ZZ:
		continue
	if n == Q.order():
		break

print('Computing pairings')
alpha = GK.weil_pairing(Q,n)
beta = PK.weil_pairing(Q,n)

print("Computing the log")
dd = beta.log(alpha)
print(dd)
