""" A bilinear pairing library based on Diego Aranha's bp contribution to OpenSSL. 
As an example here is an implementation of the BLS signature scheme (Boneh, Lynn, Shacham, 2001):
    >>> G = BpGroup()
    >>>
    >>> # Key Generation
    >>> private = G.order().random()
    >>> pub = private * G.gen2() # The public key
    >>>
    >>> # Signature
    >>> message = b"Hello World"
    >>> sig = private * G.hashG1(message)
    >>>
    >>> # Verification
    >>> G.pair(sig, G.gen2()) == G.pair(G.hashG1(message), pub)
    True
"""


from copy import copy
from binascii import hexlify
from hashlib import sha512

from petlib.bn import Bn, force_Bn


try:
    from .bindings import _FFI, _C

    from petlib.bindings import _C as petlibc
    import pytest

    from builtins import int        # pylint: disable=redefined-builtin
    from builtins import object     # pylint: disable=redefined-builtin

    POINT_CONVERSION_COMPRESSED = petlibc.POINT_CONVERSION_COMPRESSED
    POINT_CONVERSION_UNCOMPRESSED = petlibc.POINT_CONVERSION_UNCOMPRESSED

except:                             # pylint: disable=bare-except
    POINT_CONVERSION_COMPRESSED = 0
    POINT_CONVERSION_UNCOMPRESSED = 1
    print('Cannot mock for docs')

try:
    from future.utils import python_2_unicode_compatible
except Exception as e:              # pylint: disable=broad-except
    # An identity decorator
    python_2_unicode_compatible = lambda x: x

def _check(return_val):
        """Checks the return code of the C calls"""
        if __debug__:
            if isinstance(return_val, int) and return_val == 1:
                return
            if isinstance(return_val, bool) and return_val == True:
                return

        if return_val == 1 or return_val == True:
            return

        raise Exception("EC exception: %s" % return_val) 


NID_fp254bnb = 1

class BpGroup(object):
    """ A class representing all groups involved in the bilinear pairing: G1, G2, and GT. """
    
    bpq = None
    try:
        _C = _C
    except:
        _C = None
        print("Mock for docs.")

    def __init__(self, nid=NID_fp254bnb, optimize_mult=True):
        """Build an BP group from the Open SSL nid."""

        self.nid = nid

        self.bpg = _C.BP_GROUP_new_by_curve_name(nid)
        self.optimize_mult = optimize_mult

        if optimize_mult:
            _check(_C.BP_GROUP_precompute_mult_G1(self.bpg, _FFI.NULL))
            _check(_C.BP_GROUP_precompute_mult_G2(self.bpg, _FFI.NULL))

        self.g1 = G1Elem(self)
        _check( _C.BP_GROUP_get_generator_G1(self.bpg, self.g1.elem) )

        self.g2 = G2Elem(self)
        _check( _C.BP_GROUP_get_generator_G2(self.bpg, self.g2.elem) )

        self.ord = None
        self.inf = None

        self.p = None

        self.math = _C

    def order(self):
        """Returns the order of the group as a Big Number.
        
        Example:
            >>> G = BpGroup()
            >>> print(G.order())
            16798108731015832284940804142231733909759579603404752749028378864165570215949
        """

        if self.ord is None:
            o = Bn()
            _check( _C.BP_GROUP_get_order(self.bpg, o.bn, _FFI.NULL) )
            self.ord = o

        return self.ord

    def gen1(self):
        """ Returns the generator for G1. """
        return self.g1

    def hashG1(self, sbin):
        """ Hashes a byte string into a point of G1. 
        
        Example:
            >>> G = BpGroup()
            >>> g1 = G.gen1()
            >>> g1p = G.hashG1(b"Hello")
            >>> x = g1 + g1p
        """

        if self.p is None:
            p = Bn()
            a, b = Bn(), Bn()
            _check( _C.BP_GROUP_get_curve(self.bpg, p.bn, a.bn, b.bn, _FFI.NULL) )
            self.p = p

        pt = G1Elem(self)
        xhash = sbin
        y = 1    
        ret = 0

        while ret == 0:
            xhash = sha512(xhash).digest()
            x = Bn.from_binary(xhash) % self.p
            ret = _C.G1_ELEM_set_compressed_coordinates(self.bpg, pt.elem, x.bn, y, _FFI.NULL)

        _check( _C.G1_ELEM_is_on_curve(self.bpg, pt.elem, _FFI.NULL) )
        return pt


    def gen2(self):
        """ Returns the generator for G2. """
        return self.g2

    def pair(self, g1, g2):
        """ The pairing operation e(G1, G2) -> GT. 
        
            Example:
                >>> G = BpGroup()
                >>> g1, g2 = G.gen1(), G.gen2()
                >>> gt = G.pair(g1, g2)
                >>> gt6 = G.pair(g1.mul(2), g2.mul(3))
                >>> gt.exp(6).eq( gt6 )
                True
                >>> gt**6 == G.pair(2*g1, 3*g2)
                True
        """

        gt = GTElem(self)
        _check( _C.GT_ELEM_pairing(self.bpg, gt.elem, g1.elem, g2.elem, _FFI.NULL) )
        return gt


    def __copy__(self):
        return BpGroup(self.nid, self.optimize_mult)

    def __eq__(self, G):
        return G.nid == self.nid

    def __del__(self):
        """ Clears the Group object """
        if self.bpq is not None:
            self._C.BP_GROUP_clear_free(self.bpg)


class Ops(object):
    """ A class to implement infix operations. """

    try:
        _C = _C
    except:
        _C = None
        print("Mock for docs.")

    def __eq__(self, other):
        try:
            return self.eq(other)
        except Exception as e:
            raise Exception("Equality Operation Failed: %s" % e.value())

    def __hash__(self):
        return self.export().__hash__()
    
    def __ne__(self, other):
        return not self.__eq__(other)

    def __add__(self, other):
        return self.add(other)

    def __sub__(self, other):
        try:
            return self.sub(other)
        except:
            return self.add(other.neg())

    def __mul__(self, other):
        return self.mul(other)

    def __rmul__(self, other):
        return self.mul(other)

    def __pow__(self, other, modulo=None):
        return self.exp(other)

    def __neg__(self):
        return self.neg()
        
class G1Elem(Ops):

    @staticmethod
    def inf(group):
        """ Returns the element at infinity for G1 """
        zero = G1Elem(group)
        _check( _C.G1_ELEM_set_to_infinity(group.bpg, zero.elem) )
        return zero

    def __init__(self, group):
        """ Returns and element of G1 """
        self.group = group
        self.elem = _C.G1_ELEM_new(group.bpg);

    def __copy__(self):
        """ Copy the G1 point. """
        newpt = G1Elem(self.group)
        _check( _C.G1_ELEM_copy(newpt.elem, self.elem) )
        return newpt

    def add(self, other):
        """ Returns the sum of two points. """
        newpt = G1Elem(self.group)
        _check( _C.G1_ELEM_add(self.group.bpg, newpt.elem, self.elem, other.elem, _FFI.NULL) )
        return newpt   

    def double(self):
        """ Returns the double of the G1 point. """
        newpt = G1Elem(self.group)
        _check( _C.G1_ELEM_dbl(self.group.bpg, newpt.elem, self.elem, _FFI.NULL) )
        return newpt

    def neg(self):
        """ Returns the inverse point. 
        
            Example:
                >>> G = BpGroup()
                >>> g1 = G.gen1()
                >>> g1.add(g1.neg()).isinf()
                True
                >>> g1 - g1 == G1Elem.inf(G)
                True
        """
        newpt = self.__copy__()
        _check( _C.G1_ELEM_invert(self.group.bpg, newpt.elem, _FFI.NULL))
        return newpt

    def eq(self, other):
        """ Returns True if points are equal.
        
            Example:
                >>> G = BpGroup()
                >>> g1 = G.gen1()
                >>> g1.add(g1).eq(g1.double())
                True
                >>> g1.eq(g1.double())
                False
                >>> g1+g1 == 2*g1
                True
                >>> g1+g1 == Bn(2)*g1
                True
        """
        resp = _C.G1_ELEM_cmp(self.group.bpg, self.elem, other.elem, _FFI.NULL)
        return (int(resp) == 0)

    def isinf(self):
        """ Returns True if the element is infinity. """
        return int(_C.G1_ELEM_is_at_infinity(self.group.bpg, self.elem)) == 1

    @force_Bn(1)
    def mul(self, scalar):
        """ Multiplies the point with a scalar. 
        
            Example:
                >>> g1 = BpGroup().gen1()
                >>> g1.mul(2).eq(g1.double())
                True
        """
        newpt = G1Elem(self.group)
        _check( _C.G1_ELEM_mul(self.group.bpg, newpt.elem, _FFI.NULL, self.elem, scalar.bn, _FFI.NULL) )
        return newpt

    def export(self, form=POINT_CONVERSION_COMPRESSED):
        """ Export a point to a byte representation. """
        size = int(_C.G1_ELEM_point2oct(self.group.bpg, self.elem, form, _FFI.NULL, 0, _FFI.NULL))

        out = _FFI.new("unsigned char[]", size)
        _C.G1_ELEM_point2oct(self.group.bpg, self.elem, form, out, size, _FFI.NULL)
        ret = bytes(_FFI.buffer(out)[:size])

        return ret

    @staticmethod
    def from_bytes(sbin, group):
        """ Import a G1 point from bytes.
        
            Export:
                >>> G = BpGroup()
                >>> g1 = G.gen1()
                >>> buf = g1.export()
                >>> g1p = G1Elem.from_bytes(buf, G)
                >>> g1 == g1p
                True
        """
        pt_bytes = _FFI.new("unsigned char[]", sbin)

        newpt = G1Elem(group)
        _check( _C.G1_ELEM_oct2point(group.bpg, newpt.elem, pt_bytes, len(sbin), _FFI.NULL) )

        return newpt

    def __del__(self):
        if self.elem != None:
            self._C.G1_ELEM_clear_free(self.elem);


class G2Elem(Ops):

    @staticmethod
    def inf(group):
        """ Returns the element at infinity for G2. """
        zero = G2Elem(group)
        _check( _C.G2_ELEM_set_to_infinity(group.bpg, zero.elem) )
        return zero

    def __init__(self, group):
        """ Returns and element of G2. """
        self.group = group
        self.elem = _C.G2_ELEM_new(group.bpg);

    def __del__(self):
        if self.elem != None:
            self._C.G2_ELEM_clear_free(self.elem);

    def __copy__(self):
        """ Copy the G2 point. """
        newpt = G2Elem(self.group)
        _check( _C.G2_ELEM_copy(newpt.elem, self.elem) )
        return newpt

    def add(self, other):
        """ Returns the sum of two points. """
        newpt = G2Elem(self.group)
        _check( _C.G2_ELEM_add(self.group.bpg, newpt.elem, self.elem, other.elem, _FFI.NULL) )
        return newpt   

    def double(self):
        """ Returns the double of the G2 point. """
        newpt = G2Elem(self.group)
        _check( _C.G2_ELEM_dbl(self.group.bpg, newpt.elem, self.elem, _FFI.NULL) )
        return newpt

    def neg(self):
        """ Returns the inverse point. 
        
            Example:
                >>> g2 = BpGroup().gen2()
                >>> g2.add(g2.neg()).isinf()
                True
        """
        newpt = self.__copy__()
        _check( _C.G2_ELEM_invert(self.group.bpg, newpt.elem, _FFI.NULL))
        return newpt

    def eq(self, other):
        """ Returns True if points are equal.
        
            Example:
                >>> G = BpGroup()
                >>> g2 = G.gen2()
                >>> g2.add(g2).eq(g2.double())
                True
                >>> g2.add(g2) == g2.double()
                True
                >>> g2.eq(g2.double())
                False
                >>> g2 != g2.double()
                True
        """
        resp = _C.G2_ELEM_cmp(self.group.bpg, self.elem, other.elem, _FFI.NULL)
        return (int(resp) == 0)

    def isinf(self):
        """ Returns True if the element is infinity."""
        return int(_C.G2_ELEM_is_at_infinity(self.group.bpg, self.elem)) == 1

    @force_Bn(1)
    def mul(self, scalar):
        """ Multiplies the point with a scalar. 
        
            Example:
                >>> g2 = BpGroup().gen2()
                >>> g2.mul(2).eq(g2.double())
                True
        """
        newpt = G2Elem(self.group)
        _check( _C.G2_ELEM_mul(self.group.bpg, newpt.elem, _FFI.NULL, self.elem, scalar.bn, _FFI.NULL) )
        return newpt

    def export(self, form=POINT_CONVERSION_UNCOMPRESSED):
        """ Export a point to a byte representation. """
        size = int(_C.G2_ELEM_point2oct(self.group.bpg, self.elem, form, _FFI.NULL, 0, _FFI.NULL))
        
        out = _FFI.new("unsigned char[]", size)
        _C.G2_ELEM_point2oct(self.group.bpg, self.elem, form, out, size, _FFI.NULL)
        ret = bytes(_FFI.buffer(out)[:size])

        return ret

    @staticmethod
    def from_bytes(sbin, group):
        """ Import a G2 point from bytes.

            Export:
                >>> G = BpGroup()
                >>> g2 = G.gen2()
                >>> buf = g2.export()
                >>> g2p = G2Elem.from_bytes(buf, G)
                >>> g2.eq(g2p)
                True
        """
        pt_bytes = _FFI.new("unsigned char[]", sbin)

        newpt = G2Elem(group)
        _check( _C.G2_ELEM_oct2point(group.bpg, newpt.elem, pt_bytes, len(sbin), _FFI.NULL) )

        return newpt

class GTElem(Ops):

    @staticmethod
    def zero(group):
        """ Returns the element at infinity for GT. """
        zero_pt = GTElem(group)
        _check( _C.GT_ELEM_zero(zero_pt.elem) )
        return zero_pt

    def iszero(self):
        """ Return True if the element is zero."""
        return int(_C.GT_ELEM_is_zero(self.elem)) == 1

    @staticmethod
    def one(group):
        """ Returns the element at infinity for GT. """
        one_pt = GTElem(group)
        _check( _C.GT_ELEM_set_to_unity(group.bpg, one_pt.elem) )
        return one_pt

    def isone(self):
        """ Return zero if the element is one. """
        return int(_C.GT_ELEM_is_unity(self.group.bpg, self.elem)) == 1

    def __init__(self, group):
        """ Returns and element of GT. """
        self.group = group
        self.elem = _C.GT_ELEM_new(group.bpg);

    def __del__(self):
        if self.elem != None:
            self._C.GT_clear_free(self.elem);

    def __copy__(self):
        """ Copy the GT element. 
        
        Example:
            >>> G = BpGroup()
            >>> g1, g2 = G.gen1(), G.gen2()
            >>> gt = G.pair(g1, g2)
            >>> gtp = gt.__copy__()
            >>> gt == gtp
            True
        """
        newpt = GTElem(self.group)
        _check( _C.GT_ELEM_copy(newpt.elem, self.elem) )
        return newpt

    def add(self, other):
        """ Returns the sum of two GT elements. 
        
            Example:
                >>> G = BpGroup()
                >>> zero = GTElem.zero(G)
                >>> x = zero.add(zero)
                >>> x.iszero()
                True
                >>> zero + zero == zero
                True
                >>> one = GTElem.one(G)
                >>> zero + one == one
                True
        """
        newpt = GTElem(self.group)
        _check( _C.GT_ELEM_add(self.group.bpg, newpt.elem, self.elem, other.elem, _FFI.NULL) )
        return newpt

    def sub(self, other):
        """ Returns the difference of two GT elements. 

            Example:
                >>> G = BpGroup()
                >>> zero = GTElem.zero(G)
                >>> one = GTElem.one(G)
                >>> x = one.sub(one)
                >>> x.iszero()
                True
                >>> one - one == zero
                True
        """
        newpt = GTElem(self.group)
        _check( _C.GT_ELEM_sub(self.group.bpg, newpt.elem, self.elem, other.elem, _FFI.NULL) )
        return newpt

    def mul(self, other):
        """ Returns the product of two elements. 

            Example:
                >>> G = BpGroup()
                >>> gt = G.pair(G.gen1(), G.gen2())
                >>> gtinv = gt.inv()
                >>> x = gt.mul(gtinv)
                >>> x.isone()
                True
                >>> gt * gtinv == GTElem.one(G)
                True
        """
        newpt = GTElem(self.group)
        _check( _C.GT_ELEM_mul(self.group.bpg, newpt.elem, self.elem, other.elem, _FFI.NULL) )
        return newpt

    def inv(self):
        """ Returns the inverse element. 

            Example:
                >>> G = BpGroup()
                >>> gt = G.pair(G.gen1(), G.gen2())
                >>> gt2 = gt.mul(gt)
                >>> gtp = gt.sqr()
                >>> gtp.eq(gt2)
                True
        """
        newpt = GTElem(self.group)
        _check( _C.GT_ELEM_inv(self.group.bpg, newpt.elem, self.elem, _FFI.NULL))
        return newpt

    def sqr(self):
        """ Returns the square of an element. """
        newpt = GTElem(self.group)
        _check( _C.GT_ELEM_sqr(self.group.bpg, newpt.elem, self.elem, _FFI.NULL))
        return newpt


    def eq(self, other):
        """ Returns True if elements are equal. """
        resp = _C.GT_ELEM_cmp(self.elem, other.elem)
        return (int(resp) == 0)

    @force_Bn(1)
    def exp(self, scalar):
        """ Exponentiates the element with a scalar. """
        pt_elem = self
        if scalar < 0:
            pt_elem = self.inv()

        newpt = GTElem(self.group)
        _check( _C.GT_ELEM_exp(self.group.bpg, newpt.elem, pt_elem.elem, scalar.bn, _FFI.NULL) )
        return newpt

    def export(self):
        """ Export a GT element to a byte representation. """
        size = int(_C.GT_ELEM_elem2oct(self.group.bpg, self.elem, _FFI.NULL, 0, _FFI.NULL))
        
        out = _FFI.new("unsigned char[]", size)
        _C.GT_ELEM_elem2oct(self.group.bpg, self.elem, out, size, _FFI.NULL)
        ret = bytes(_FFI.buffer(out)[:size])

        return ret

    @staticmethod
    def from_bytes(sbin, group):
        """ Import a GT element from bytes.

            Export:
                >>> G = BpGroup()
                >>> gt = G.pair(G.gen1(), G.gen2())
                >>> buf = gt.export()
                >>> gtp = GTElem.from_bytes(buf, G)
                >>> gt.eq(gtp)
                True
        """
        pt_bytes = _FFI.new("unsigned char[]", sbin)

        newpt = GTElem(group)
        _check( _C.GT_ELEM_oct2elem(group.bpg, newpt.elem, pt_bytes, len(sbin), _FFI.NULL) )

        return newpt

def test_negatives():
    G = BpGroup()
    gt_v1 = G.pair(-G.gen1(), G.gen2())
    gt_v2 = G.pair(G.gen1(), -G.gen2())
    assert gt_v1 == gt_v2

    assert (-5)*G.gen1() == 5 * (-G.gen1())
    assert (-5)*G.gen1() != 5 * (G.gen1())

    assert G.pair(-10 * G.gen1(), G.gen2()) == G.pair(G.gen1(), G.gen2())**(-10)
    assert G.pair(10 * G.gen1(), -G.gen2()) == G.pair(G.gen1(), G.gen2())**(-10)

