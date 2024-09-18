from Crypto.Util.number import getPrime, bytes_to_long
import random, json

RSA = []
for i in range(20):
	print("Round",i)
	p = getPrime(512)
	q = getPrime(512)
	N = p*q
	phi = (p-1)*(q-1)
	while True:
		try:
			d = random.randint(2,pow(N,1/4)//3)
			e = pow(d,-1,phi)
			break
		except:
			continue
	RSA.append({'p': p, 'q': q, 'N': N, 'd': d, 'e': e})

with open('wiener_attack.json','w') as f:
	json.dump(RSA,f,indent=4)
