from Crypto.Util.number import getPrime, bytes_to_long
import json

RSA = []
for i in range(20):
	print("Round",i)
	while True:
		try:
			p = getPrime(512)
			q = getPrime(512)
			N = p*q
			phi = (p-1)*(q-1)
			e = 17
			d = pow(e,-1,phi)
			break
		except:
			continue
	RSA.append({'p': p, 'q': q, 'N': N, 'd': d, 'e': e})

with open('partial_key.json','w') as f:
	json.dump(RSA,f,indent=4)
