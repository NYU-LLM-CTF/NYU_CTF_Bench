""" BLS signature scheme """
from bplib.bp import BpGroup, G2Elem
from bls.utils import *


def setup():
	""" generate all public parameters """
	G = BpGroup()
	(g1, g2) = G.gen1(), G.gen2()
	(e, o) = G.pair, G.order()
	return (G, o, g1, g2, e)


def ttp_keygen(params, t, n):
	""" generate keys for threshold signature (executed by a TTP) """
	assert n >= t and t > 0
	(G, o, g1, g2, e) = params
	# generate polynomials
	v = [o.random() for _ in range(0,t)]
	# generate shares
	sk = [poly_eval(v,i) % o for i in range(1,n+1)]
	# set keys
	vk = [xi*g2 for xi in sk]
	return (sk, vk)


def aggregate_vk(params, vk, threshold=True):
	""" aggregate the verification keys """
	(G, o, g1, g2, e) = params
	t = len(vk)
	# evaluate all lagrange basis polynomial li(0)
	l = [lagrange_basis(t, o, i, 0) for i in range(1,t+1)] if threshold else [1 for _ in range(t)]
	# aggregate keys
	aggr_vk = ec_sum([l[i]*vk[i] for i in range(t)])
	return aggr_vk


def sign(params, sk, m):
	""" sign messages """
	assert len(m) > 0
	(G, o, g1, g2, e) = params
	digest = hash(m)
	h = G.hashG1(digest)
	sigma = sk*h
	return sigma


def aggregate_sigma(params, sigs, threshold=True):
	""" aggregate partial signatures """
	(G, o, g1, g2, e) = params
	t = len(sigs)
	# evaluate all lagrange basis polynomial li(0)
	l = [lagrange_basis(t, o, i, 0) for i in range(1,t+1)] if threshold else [1 for _ in range(t)]
	# aggregate sigature
	aggr_s = ec_sum([l[i]*sigs[i] for i in range(t)])
	return aggr_s


def verify(params, aggr_vk, sigma, m):
	""" verify the signature """
	(G, o, g1, g2, e) = params
	digest = hash(m)
	h = G.hashG1(digest)
	return not h.isinf() and e(sigma, g2) == e(h, aggr_vk)



