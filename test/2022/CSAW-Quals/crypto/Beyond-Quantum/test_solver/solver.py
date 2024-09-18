import numpy as np
import sys
from sympy.abc import x
from sympy import ZZ, Poly
import math

from pwn import *

# grab c_poly and h_poly from server interaction

# Grab these from server interactivity
c_poly = Poly(55*x**96 - 62*x**95 - 18*x**94 - 10*x**93 - 24*x**92 + 57*x**91 - 43*x**90 - 6*x**89 - 57*x**88 + 2*x**87 + 53*x**86 - 15*x**85 + 7*x**84 - 62*x**83 + 13*x**82 + 44*x**81 - 8*x**80 - 59*x**79 - 47*x**78 + 40*x**77 + 36*x**76 + 8*x**75 + 52*x**74 - 9*x**73 + 15*x**72 - 30*x**71 + 56*x**70 + 23*x**69 + 35*x**68 + 23*x**67 + 32*x**66 - 27*x**65 + 24*x**63 + 34*x**62 - 14*x**61 + 32*x**60 - 38*x**59 + 14*x**58 - 5*x**57 + 16*x**56 - 7*x**55 + 63*x**54 - 42*x**53 - 59*x**52 - 38*x**51 + 46*x**50 + 51*x**49 - 17*x**48 + 54*x**47 - 61*x**46 + 5*x**45 - 60*x**44 + 32*x**43 + 36*x**42 - 7*x**41 + 15*x**40 + 12*x**39 - 15*x**38 + 30*x**37 + 39*x**36 + 5*x**35 - 57*x**34 + 19*x**33 + 47*x**32 + 49*x**31 - 46*x**30 - 31*x**29 + 23*x**28 - 10*x**27 - 24*x**26 + 46*x**25 - 7*x**24 + 31*x**23 - 41*x**22 - 6*x**21 + 41*x**20 + 9*x**19 - 41*x**18 + 27*x**17 - 48*x**16 + 40*x**15 + 34*x**14 + 5*x**13 - 48*x**12 - 10*x**11 + 26*x**10 - 48*x**9 - 38*x**8 + 49*x**7 - 62*x**6 - 10*x**5 - 45*x**4 + 47*x**3 + 45*x**2 - 47*x + 36, x, domain='ZZ')
h_poly = Poly(55*x**96 - 63*x**95 - 18*x**94 - 10*x**93 - 25*x**92 + 56*x**91 - 44*x**90 - 7*x**89 - 57*x**88 + 2*x**87 + 53*x**86 - 15*x**85 + 7*x**84 - 63*x**83 + 12*x**82 + 43*x**81 - 8*x**80 - 59*x**79 - 47*x**78 + 40*x**77 + 36*x**76 + 7*x**75 + 51*x**74 - 9*x**73 + 15*x**72 - 30*x**71 + 55*x**70 + 23*x**69 + 35*x**68 + 22*x**67 + 31*x**66 - 28*x**65 + 24*x**63 + 34*x**62 - 15*x**61 + 32*x**60 - 39*x**59 + 13*x**58 - 6*x**57 + 16*x**56 - 7*x**55 + 62*x**54 - 43*x**53 - 60*x**52 - 38*x**51 + 45*x**50 + 50*x**49 - 17*x**48 + 53*x**47 - 62*x**46 + 5*x**45 - 60*x**44 + 31*x**43 + 35*x**42 - 7*x**41 + 15*x**40 + 12*x**39 - 15*x**38 + 29*x**37 + 39*x**36 + 4*x**35 - 58*x**34 + 18*x**33 + 47*x**32 + 49*x**31 - 47*x**30 - 32*x**29 + 22*x**28 - 10*x**27 - 25*x**26 + 45*x**25 - 7*x**24 + 30*x**23 - 41*x**22 - 6*x**21 + 41*x**20 + 9*x**19 - 41*x**18 + 26*x**17 - 48*x**16 + 39*x**15 + 34*x**14 + 4*x**13 - 48*x**12 - 11*x**11 + 25*x**10 - 49*x**9 - 38*x**8 + 48*x**7 - 62*x**6 - 10*x**5 - 45*x**4 + 46*x**3 + 45*x**2 - 48*x + 36, x, domain='ZZ')


# We provide this helper function in code
def poly_to_bytes(poly):
    res = poly.set_domain(ZZ).all_coeffs()[::-1]
    res = np.packbits(np.array(res).astype(int)).tobytes().hex()
    return bytes.fromhex(res)

def decrypt_bad_cipher(c_poly, h_poly):
    my_poly = (c_poly - h_poly)
    my_solt = my_poly.set_domain(ZZ).all_coeffs()[::-1]
    my_o = np.packbits(np.array(my_solt).astype(int)).tobytes().hex()
    my_o = bytes.fromhex(my_o)
    return my_o.decode('ascii')

def decrypt_bad_cipher_alt(c_poly, h_poly):
    my_poly = (c_poly - h_poly)
    my_o = poly_to_bytes(my_poly)
    return my_o.decode('ascii')

if __name__ == "__main__":
    # decrypt_bad_cipher_alt(c_poly, h_poly)
    password = decrypt_bad_cipher(c_poly, h_poly)
    print("Password:", password)

    p = remote("crypto.chal.csaw.io",5000)
    p.sendline("3 " + password)
    p.readuntil("??\n\n")
    print("Flag:", p.readline()[:-1].decode('ascii'))
