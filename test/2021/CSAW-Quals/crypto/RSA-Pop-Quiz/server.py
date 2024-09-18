from Crypto.Util.number import getPrime, bytes_to_long, inverse
import random, math, json
from sympy import isprime

with open("flag.txt",'r') as f:
	flag = f.read()

m1 = "Wiener wiener chicken dinner" # For wiener's attack
m2 = "Who came up with this math term anyway?" # For sexy primes
m3 = "Totally did not mean to put an oracle there" # For LSB oracle
m4 = "I'll be careful next time to not leak the key" # For partial key

def wiener_attack():
	m_bytes = bytes(m1,'utf-8')
	m = bytes_to_long(m_bytes)
	with open('wiener_attack.json','r') as f:
		RSA = json.loads(f.read())
	index = random.randint(0,len(RSA)-1)
	N = RSA[index]['N']
	e = RSA[index]['e']
	print("N =",N)
	print("e =",e)
	print("c =",pow(m,e,N))
	
def sexy_primes():
	m_bytes = bytes(m2,'utf-8')
	m = bytes_to_long(m_bytes)
	with open('sexy_primes.json','r') as f:
		RSA = json.loads(f.read())
	index = random.randint(0,len(RSA)-1)
	N = RSA[index]['N']
	e = RSA[index]['e']
	print("N =",N)
	print("e =",e)
	print("c =",pow(m,e,N))

def lsb_oracle():
	m_bytes = bytes(m3,'utf-8')
	m = bytes_to_long(m_bytes)
	p = getPrime(512)
	q = getPrime(512)
	N = p*q
	phi = (p-1)*(q-1)
	e = 65537
	d = inverse(e,phi)
	print("N =",N)
	print("e =",e)
	print("c =",pow(m,e,N))
	while True:
		print("\nWhat would you like to decrypt? (please respond with an integer)")
		given = int(input(""))
		decrypt = pow(given,d,N)
		print("\nThe oracle responds with:",bin(decrypt)[-1])
		print("Would you like to continue? (yes/no)")
		ans = input("")
		if ans == "no":
			break

def partial_key():
	m_bytes = bytes(m4,'utf-8')
	m = bytes_to_long(m_bytes)
	with open('partial_key.json','r') as f:
		RSA = json.loads(f.read())
	index = random.randint(0,len(RSA)-1)
	N = RSA[index]['N']
	e = RSA[index]['e']
	d = RSA[index]['d']
	print("N =",N)
	print("e =",e)
	print("d0 =",int(bin(d)[-512:],2))
	print("c =",pow(m,e,N))
	print("d0bits = 512")
	print("nBits = 1024")

def main():
	print("Part 1 --> This is one of the most common RSA attacks in CTFs!\n")
	wiener_attack()
	while True:
		print("\nWhat is the plaintext?")
		answer = input("")
		if answer == m1:
			print("Success!")
			break
		else:
			print("Please try again!")
	
	print("Part 2 --> Sexy primes were used to make the modulus!\n")
	sexy_primes()
	while True:
		print("\nWhat is the plaintext?")
		answer = input("")
		if answer == m2:
			print("Success!")
			break
		else:
			print("Please try again!")
	
	print("Part 3 --> Looks like there is a oracle which is telling the LSB of the plaintext. That will not help you, right?\n")
	lsb_oracle()
	while True:
		print("\nWhat is the plaintext?")
		answer = input("")
		if answer == m3:
			print("Success!")
			break
		else:
			print("Please try again!")
	
	print("Part 4 --> Oops, looks like I leaked part of the private key. Hope that doesn't come back to bite me!\n")
	partial_key()
	while True:
		print("\nWhat is the plaintext?")
		answer = input("")
		if answer == m4:
			print("Success!")
			break
		else:
			print("Please try again!")
	
	print("\nCongrats on passing the RSA Pop Quiz! Here is your flag:",flag)

if __name__ == "__main__":
	main()
