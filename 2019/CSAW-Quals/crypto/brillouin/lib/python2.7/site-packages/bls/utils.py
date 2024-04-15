""" Utilities """
from hashlib import sha256



# ==================================================
# polynomial utilities
# ==================================================
def poly_eval(coeff, x):
	""" evaluate a polynomial defined by the list of coefficient coeff at point x """
	return sum([coeff[i] * (x ** i) for i in range(len(coeff))])

def lagrange_basis(t, o, i, x=0):
	""" generates the lagrange basis polynomial li(x), for a polynomial of degree t-1 """
	numerator, denominator = 1, 1
	for j in range(1,t+1):
		if j != i:
			numerator = (numerator * (x - j)) % o
			denominator = (denominator * (i - j)) % o 
	return (numerator * denominator.mod_inverse(o)) % o


# ==================================================
# other
# ==================================================
def ec_sum(list):
	""" sum EC points list """
	ret = list[0]
	for i in range(1,len(list)):
		ret = ret + list[i]
	return ret


def hash(elements):
  """ generates a Bn hash by hashing a number of EC points """
  Cstring = b",".join([str(x) for x in elements])
  return  sha256(Cstring).digest()


