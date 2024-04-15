from pwn import *
import owiener, math
from Crypto.Util.number import long_to_bytes

server = remote("crypto.chal.csaw.io",5008)

def wiener_attack():
	N_data = server.recvline().split(b" = ")
	e_data = server.recvline().split(b" = ")
	c_data = server.recvline().split(b" = ")
	N = int(N_data[1][:-2])
	e = int(e_data[1][:-2])
	c = int(c_data[1][:-2])
	print("N =",N,"\ne =",e,"\nc =",c)
	print(server.recvline())
	print(server.recvline())
	d = owiener.attack(e, N)
	m = long_to_bytes(pow(c,d,N))
	print(m)
	server.sendline(m)
	print(server.recvline())

def sexy_primes():
	N_data = server.recvline().split(b" = ")
	e_data = server.recvline().split(b" = ")
	c_data = server.recvline().split(b" = ")
	N = int(N_data[1][:-2])
	e = int(e_data[1][:-2])
	c = int(c_data[1][:-2])
	print("N =",N,"\ne =",e,"\nc =",c)
	print(server.recvline())
	print(server.recvline())
	p = -3 + pow(N+9,1/2)
	q = 3 + pow(N+9,1/2)
	phi = (p-1)*(q-1)
	d = int(pow(e,-1,phi))
	m = long_to_bytes(pow(c,d,N))
	print(m)
	server.sendline(m)
	print(server.recvline())

def lsb_oracle():
	N_data = server.recvline().split(b" = ")
	e_data = server.recvline().split(b" = ")
	c_data = server.recvline().split(b" = ")
	N = int(N_data[1][:-2])
	e = int(e_data[1][:-2])
	c = int(c_data[1][:-2])
	print("N =",N,"\ne =",e,"\nc =",c)
	lower_bound = 0
	upper_bound = N
	i = 0
	while True:
		i += 1
		print(server.recvline())
		print(server.recvline())
		text_to_send = c*pow(2**i,e,N) % N
		server.sendline(str(text_to_send))
		print(server.recvline())
		bit_data = server.recvline().split()
		print(bit_data)
		if b"0"==bit_data[-1]:
			upper_bound = (upper_bound+lower_bound)/2
		elif b"1"==bit_data[-1]:
			lower_bound = (upper_bound+lower_bound)/2
		else:
			print("Error!")
			break
		print("\nLower bound:",int(lower_bound))
		print("Upper bound:",int(upper_bound))
		print(server.recvline())
		if int(upper_bound) - int(lower_bound) == 1:
			server.sendline("no")
			break
		server.sendline("yes")
	m = long_to_bytes(upper_bound)
	print(server.recvline())
	print(server.recvline())
	print(m)
	server.sendline(m)
	print(server.recvline())

def partial_key():
	N_data = server.recvline().split(b" = ")
	e_data = server.recvline().split(b" = ")
	d0_data = server.recvline().split(b" = ")
	c_data = server.recvline().split(b" = ")
	d0Bits_data = server.recvline().split(b" = ")
	nBits_data = server.recvline().split(b" = ")
	N = int(N_data[1][:-2])
	e = int(e_data[1][:-2])
	c = int(c_data[1][:-2])
	nBits = int(nBits_data[1][:-2])
	d0bits = int(d0Bits_data[1][:-2])
	d0 = int(d0_data[1][:-2])
	print("N =",N,"\ne =",e,"\nc =",c,"\nd0 =",d0,"\nd0Bits =",d0bits,"\nnBits =",nBits)
	X = var('X')
	found = False
	for k in range(1,e+1):
		if found:
			break
		print("Attempt",k)
		results = solve_mod([e*d0 - k*(N-X+1) == 1], 2^d0bits)
		for x in results:
			s = ZZ(x[0])
			P = var('P')
			p0_results = solve_mod([P^2 - s*P + N == 0], 2^d0bits)
			for y in p0_results:
				p0 = int(y[0])
				PR.<z> = PolynomialRing(Zmod(N))
				f = 2^d0bits*z + p0
				f = f.monic()
				roots = f.small_roots(X=2^(nBits//2 - d0bits + 1), beta=0.1)
				if roots:
					x0 = roots[0]
					p = gcd(2^d0bits*x0 + p0, N)
					q = N//ZZ(p)
					d = int(pow(e,-1,(p-1)*(q-1)))
					m = long_to_bytes(pow(c,d,N))
					found = True
	print(server.recvline())
	print(server.recvline())
	print(m)
	server.sendline(m)
	print(server.recvline())

print(server.recvline())
print(server.recvline())
wiener_attack()
print(server.recvline())
print(server.recvline())
sexy_primes()
print(server.recvline())
print(server.recvline())
lsb_oracle()
print(server.recvline())
print(server.recvline())
partial_key()
print(server.recvline())
print(server.recvline())
server.close()
