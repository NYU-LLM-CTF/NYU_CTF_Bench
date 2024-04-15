from Crypto.Util.number import getPrime, isPrime
import json

curves = []

def smooth_prime(b):
	while True:
		p = 4
		for _ in range(6):
			p *= getPrime(b)
		p -= 1
		if isPrime(p) and p%4 == 3:
			return p

for i in range(20):
	print("Curve",i)
	p = smooth_prime(25)
	a,b = p-1,0
	curves.append({'p': p, 'a': a, 'b': b})
	
with open('mov_attack_curves.json','w') as f:
	json.dump(curves,f,indent=4)
