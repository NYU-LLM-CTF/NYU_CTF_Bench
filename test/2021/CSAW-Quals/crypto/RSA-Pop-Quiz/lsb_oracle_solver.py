import math
from Crypto.Util.number import long_to_bytes

N = int(input("What is the modulus (N)?: "))
e = int(input("What is the public exponent (e)?: "))
c = int(input("What is the ciphertext (c)?: "))

lower_bound = 0
upper_bound = N

for i in range(1,N):
	text_to_send = c*pow(2**i,e,N) % N
	print(text_to_send)
	bit = int(input("\nWhat is the bit?: "))
	if bit == 0:
		upper_bound = (upper_bound+lower_bound)/2
	else:
		lower_bound = (upper_bound+lower_bound)/2
	print("\nLower bound:",lower_bound)
	print("Upper bound:",upper_bound)
	if math.floor(upper_bound) == math.ceil(lower_bound):
		break
	print()

print(long_to_bytes(math.ceil(lower_bound)))
