from Crypto.Util.number import getPrime, bytes_to_long
from sympy import isprime
import json

RSA = []
for i in range(20):
	print("Round",i)
	while True:
		p = getPrime(512)
		q = p + 6
		e = 65537
		if isprime(q):
			N = p*q
			phi = (p-1)*(q-1)
			d = pow(e,-1,phi)
			RSA.append({'p': p, 'q': q, 'N': N, 'd': d, 'e': e})
			break

with open('sexy_primes.json','w') as f:
	json.dump(RSA,f,indent=4)
