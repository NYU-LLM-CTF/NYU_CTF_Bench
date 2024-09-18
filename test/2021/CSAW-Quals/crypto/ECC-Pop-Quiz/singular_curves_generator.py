from random import randint
import json
from Crypto.Util.number import getPrime
from collections import namedtuple

curves = []

# Create a simple Point class to represent the affine points.
Point = namedtuple("Point", "x y")

# The point at infinity (origin for the group law).
O = 'Origin'

def check_point(P):
	if P == O:
		return True
	else:
		return (P.y**2 - (P.x**3 + a*P.x + b)) % p == 0

def point_inverse(P):
	if P == O:
		return P
	return Point(P.x, -P.y % p)

def point_addition(P, Q):
	if P == O:
		return Q
	elif Q == O:
		return P
	elif Q == point_inverse(P):
		return O
	else:
		if P == Q:
			lam = (3*P.x**2 + a) * pow(2*P.y,-1,p)
			lam %= p
		else:
			lam = (Q.y - P.y) * pow((Q.x - P.x),-1,p)
			lam %= p
	Rx = (lam**2 - P.x - Q.x) % p
	Ry = (lam*(P.x - Rx) - P.y) % p
	R = Point(Rx, Ry)
	assert check_point(R)
	return R

def double_and_add(P, n):
	Q = P
	R = O
	while n > 0:
		if n % 2 == 1:
			R = point_addition(R, Q)
		Q = point_addition(Q, Q)
		n = n // 2
	assert check_point(R)
	return R


for i in range(20):
	print("Curve",i)
	while True:
		p = getPrime(256)
		if (p%4)==3:
			break
	a,b = -3,2
	while True:
		gx = randint(0,p-1)
		gy = pow(gx**3 + a*gx + b,(p+1)//4,p)
		if (gy**2 - (gx**3 + a*gx + b)) % p == 0:
			G = Point(gx, gy)
			break
	n = randint(10**5,10**6)
	P = double_and_add(G, n)
	curves.append({'p': p, 'gx': gx, 'gy': gy, 'px': P.x, 'py': P.y, 'n': n})

with open('singular_curves.json','w') as f:
	json.dump(curves,f,indent=4)
