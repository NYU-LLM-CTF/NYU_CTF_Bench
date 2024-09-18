try:
    from . import bp
    from . import pack
except:
    pass

__doc__ = """The ``bplib`` is a library implementing support for computations on groups supporting 
bilinear pairings, as used in modern cryptography. 

It is based on the OpenPairing library by 
Diego Aranha (https://github.com/dfaranha/OpenPairing), which is itself based on, and compatible 
with, OpenSSL math functions (``bn`` and ``ec``). The ``bplib`` is compatible with ``petlib`` types
including ``petlib.bn`` and the group G1 is a ``petlib.ec`` EC group. Along with ``petlib``, 
they provide easy to use 
support for maths and ciphers used in modern Privacy Enhancing Technologies."

A set of bilinear EC groups is defined as:

    >>> G = bp.BpGroup()

Such a BpGroup describes 3 groups G1, G2 and GT such that pair(G1,G2)->GT. Generators 
for the groups G1 and G2 are denoted by:

    >>> g1, g2 = G.gen1(), G.gen2()

The special ``pair`` operation computes to pairing into GT:

    >>> gt = G.pair(g1, g2)

Operations are defined on all elements of G1, G2 or GT in a natural additive infix notation for G1 and G2, and a multiplicative notation for GT:
    
    >>> gt6 = gt**6

As expected the ``pair`` operations is additive:

    >>> G.pair(g1, 6*g2) == gt6
    True
    >>> G.pair(6*g1, g2) == gt6
    True
    >>> G.pair(2*g1, 3*g2) == gt6
    True

"""

VERSION = "0.0.6"