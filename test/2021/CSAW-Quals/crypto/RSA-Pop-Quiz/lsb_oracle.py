from Crypto.Util.number import getPrime, bytes_to_long

m_bytes = b'test'
m = bytes_to_long(m_bytes)

p = getPrime(20)
q = getPrime(20)
N = p*q
phi = (p-1)*(q-1)
e = 65537
d = pow(e,-1,phi)

print("N =",N)
print("e =",e)
print("c =",pow(m,e,N))

while True:
	given = int(input("\nWhat would you like to decrypt?: "))
	decrypt = pow(given,d,N)
	print("\nThe oracle responds with:",bin(decrypt)[-1])
