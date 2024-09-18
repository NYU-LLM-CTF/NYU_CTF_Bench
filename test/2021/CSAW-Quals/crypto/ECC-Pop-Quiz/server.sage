from random import randint
import json

with open("flag.txt",'r') as f:
	flag = f.read()

def smarts_attack():
	with open("smarts_attack_curves.json",'r') as f:
		curves = json.loads(f.read())
	index = randint(0,len(curves)-1)
	p = int(curves[index]['field']['p'],16)
	a = int(curves[index]['a'],16)
	b = int(curves[index]['b'],16)
	E = EllipticCurve(GF(p), [a, b])
	print("The curve parameters are:")
	print("p = "+str(p))
	print("a = "+str(a))
	print("b = "+str(b))
	P1 = E.gens()[0]
	print('\nP1: '+str(P1))
	secret = randint(1, E.order() - 1)
	P2 = secret * P1
	print('P2: '+str(P2))
	print('P2 = secret * P1')
	return secret

def mov_attack():
	with open("mov_attack_curves.json",'r') as f:
		curves = json.loads(f.read())
	index = randint(0,len(curves)-1)
	p = curves[index]['p']
	a = curves[index]['a']
	b = curves[index]['b']
	E = EllipticCurve(GF(p), [a, b])
	print("The curve parameters are:")
	print("p = "+str(p))
	print("a = "+str(a))
	print("b = "+str(b))
	P1 = E.gens()[0]
	print('\nP1: '+str(P1))
	secret = randint(1, 10**9)
	P2 = secret * P1
	print('P2: '+str(P2))
	print('P2 = secret * P1')
	return secret

def singular_curves():
	with open("singular_curves.json",'r') as f:
		curves = json.loads(f.read())
	index = randint(0,len(curves)-1)
	p = curves[index]['p']
	secret = curves[index]['n']
	G = (curves[index]['gx'],curves[index]['gy'])
	P = (curves[index]['px'],curves[index]['py'])
	print("The curve parameters are:")
	print("p = "+str(p))
	print("a = ???")
	print("b = ???")
	print('\nP1: '+str(G))
	print('P2: '+str(P))
	print('P2 = secret * P1')
	return secret

def main():
	print("The answer will be a randomly generated solution and hence not an obvious message.")
	print("Part 1 --> Are you smart enough to crack this?\n")
	smarts = smarts_attack()
	while True:
		print("\nWhat is the value of 'secret'?: ")
		n = int(input(""))
		if n == smarts:
			print("Success!")
			break
		else:
			print("Please try again!")
	
	print("\nPart 2 --> Can you move on to the next question?\n")
	mov = mov_attack()
	while True:
		print("\nWhat is the value of 'secret'?: ")
		n = int(input(""))
		if n == mov:
			print("Success!")
			break
		else:
			print("Please try again!")
	
	print("\nPart 3 --> This singular question remains between you and completion!\n")
	singular = singular_curves()
	while True:
		print("\nWhat is the value of 'secret'?: ")
		n = int(input(""))
		if n == singular:
			print("Success!")
			break
		else:
			print("Please try again!")
	
	print("\nCongrats on passing the ECC Pop Quiz! Here is your flag: "+flag)

if __name__ == "__main__":
	main()
