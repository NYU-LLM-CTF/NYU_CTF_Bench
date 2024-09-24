from .bindings import _FFI, _C, get_errors

from functools import wraps
from copy import copy, deepcopy
from binascii import hexlify, unhexlify  # pylint: disable=unused-import

# Py2/3 compatibility
try:
    from builtins import int        # pylint: disable=redefined-builtin
    from builtins import object     # pylint: disable=redefined-builtin
except BaseException:                             # pylint: disable=bare-except
    print("Cannot mock for docs")

try:
    from future.utils import python_2_unicode_compatible
except Exception as e:              # pylint: disable=broad-except
    # An identity decorator
    def python_2_unicode_compatible(x): return x

import pytest


def force_Bn(n):
    """A decorator that coerces the nth input to be a Big Number"""

    def convert_nth(f):
        # pylint: disable=star-args
        @wraps(f)
        def new_f(*args, **kwargs):
            new_args = args
            try:
                if not n < len(args) or args[n].bn:  # isinstance(args[n], Bn):
                    new_args = args
            except BaseException:
                # if not n < len(args):
                #    new_args = args

                if isinstance(args[n], int):
                    r = Bn.from_num(args[n])
                    new_args = list(args)
                    new_args[n] = r
                    new_args = tuple(new_args)
                else:
                    return NotImplemented

            return f(*new_args, **kwargs)

        return new_f
    return convert_nth


def _check(return_val):
    """Checks the return code of the C calls"""
    if __debug__:
        if isinstance(return_val, int) and return_val == 1:
            return
        if isinstance(return_val, bool) and return_val == True:
            return

    if return_val == True and return_val == 1:
        return

    errs = get_errors()
    raise Exception("BN exception: %s" % errs)


class BnCtx(object):
    """ A Bn Context for use by the petlib library """

    __slots__ = ['bnctx', '_C']

    def __init__(self):
        self._C = _C
        self.bnctx = self._C.BN_CTX_new()
        _check(self.bnctx != _FFI.NULL)

    def __del__(self):
        if self.bnctx is not None:
            self._C.BN_CTX_free(self.bnctx)


class BnCtxNULL(BnCtx):
    """ A Bn Context for use by the petlib library """

    __slots__ = ['bnctx', '_C']

    def __init__(self):
        self._C = _C
        self.bnctx = _FFI.NULL

    def __del__(self):
        pass


import threading
_thread_local = threading.local()


def get_ctx():
    global _thread_local

    try:
        return _thread_local.ctx
    except BaseException:
        _thread_local.ctx = BnCtx()
        return _thread_local.ctx


@python_2_unicode_compatible
class Bn(object):
    """The core Big Number class.
         It supports all comparisons (<, <=, ==, !=, >=, >),
         arithmetic operations (+, -, %, /, divmod, pow)
         and copy operations (copy and deep copy). The right-hand
         side operand may be a small native python integer (<2^64). """

    __C = _C

    # We know this class will keep minimal state
    __slots__ = ['bn']

    # -- static methods

    @staticmethod
    def from_num(num):
        if isinstance(num, int):
            return Bn(num)
        elif isinstance(num, Bn):
            return num
        else:
            # raise TypeError("Cannot coerce %s into a BN." % num)
            return NotImplemented

    @staticmethod
    def from_decimal(sdec):
        """Creates a Big Number from a decimal string.

        Args:
            sdec (string): numeric string possibly starting with minus.

        See Also:
            str() produces a decimal string from a big number.

        Example:
            >>> hundred = Bn.from_decimal("100")
            >>> str(hundred)
            '100'

        """

        ptr = _FFI.new("BIGNUM **")
        read_bytes = _C.BN_dec2bn(ptr, sdec.encode("utf8"))
        if read_bytes != len(sdec):
            raise Exception("BN Error")

        ret = Bn()
        _C.BN_copy(ret.bn, ptr[0])
        _C.BN_clear_free(ptr[0])
        return ret

    @staticmethod
    def from_hex(shex):
        """Creates a Big Number from a hexadecimal string.

        Args:
            shex (string): hex (0-F) string possibly starting with minus.

        See Also:
            hex() produces a hexadecimal representation of a big number.

        Example:
            >>> Bn.from_hex("FF")
            255
        """

        ptr = _FFI.new("BIGNUM **")
        read_bytes = _C.BN_hex2bn(ptr, shex.encode("utf8"))
        if read_bytes != len(shex):
            raise Exception("BN Error")

        ret = Bn()
        _C.BN_copy(ret.bn, ptr[0])
        _C.BN_clear_free(ptr[0])
        return ret

    @staticmethod
    def from_binary(sbin):
        """Creates a Big Number from a byte sequence representing the number in Big-endian 8 byte atoms. Only positive values can be represented as byte sequence, and the library user should store the sign bit separately.

        Args:
            sbin (string): a byte sequence.

        Example:
            >>> byte_seq = unhexlify(b"010203")
            >>> Bn.from_binary(byte_seq)
            66051
            >>> (1 * 256**2) + (2 * 256) + 3
            66051
        """
        ret = Bn()
        _C.BN_bin2bn(sbin, len(sbin), ret.bn)
        return ret

    @staticmethod
    def get_prime(bits, safe=1):
        """
        Builds a prime Big Number of length bits.

        Args:
                bits (int) -- the number of bits.
                safe (int) -- 1 for a safe prime, otherwise 0.

        """
        _check(0 < bits < 10000)
        _check(safe in [0, 1])

        ret = Bn()
        _check(
            _C.BN_generate_prime_ex(
                ret.bn,
                bits,
                safe,
                _FFI.NULL,
                _FFI.NULL,
                _FFI.NULL))
        return ret

    ## -- methods

    _upper_bound = 2**(64 - 1)

    def __init__(self, num=0):
        'Allocate a Big Number structure, initialized with a small integer or zero.'
        self.bn = _C.BN_new()

        if num == 0:
            return

        if __debug__:
            _check(0 <= abs(num) <= self._upper_bound)
            _check(isinstance(num, int))

        # Assign
        if num != 0:
            ret = _C.BN_set_word(self.bn, abs(num))
            if __debug__:
                _check(ret)
            if ret != 1:
                raise Exception("Bn Exception.")

        if num < 0:
            self._set_neg(1)

    def _set_neg(self, sign=1):
        # """Sets the sign to "-" (1) or "+" (0)"""
        if not (sign == 0 or sign == 1):
            raise Exception("Sign has to be 0 or 1.")
        _C.BN_set_negative(self.bn, sign)

    def copy(self):
        """Returns a copy of the Bn object."""
        return self.__copy__()

    def __copy__(self):
        # 'Copies the big number. Support for copy module'
        other = Bn()
        _C.BN_copy(other.bn, self.bn)
        return other

    def __deepcopy__(self, memento):
        # 'Deepcopy is the same as copy'
        # pylint: disable=unused-argument
        return self.__copy__()

    def __del__(self):
        # 'Deallocate all resources of the big number'
        self.__C.BN_clear_free(self.bn)

    def __inner_cmp__(self, other):
        # 'Irel comparison function'
        # if __debug__:
        #    _check( type(other) == Bn )
        try:
            sig = int(_C.BN_cmp(self.bn, other.bn))
            return sig
        except AttributeError:
            return self.__inner_cmp__(Bn.from_num(other))

    def __lt__(self, other):
        return self.__inner_cmp__(other) < 0

    def __le__(self, other):
        return self.__inner_cmp__(other) <= 0

    def __eq__(self, other):
        return self.__inner_cmp__(other) == 0

    def __ne__(self, other):
        return self.__inner_cmp__(other) != 0

    def __gt__(self, other):
        return self.__inner_cmp__(other) > 0

    def __ge__(self, other):
        return self.__inner_cmp__(other) >= 0

    def bool(self):
        'Turn Bn into boolean. False if zero, True otherwise.'
        return self.__bool__()

    def __bool__(self):
        # 'Turn into boolean'
        return not (self == Bn(0))

    # Python 2 compatibility
    def __nonzero__(self):
        return self.__bool__()

    # Export in different representations

    def repr(self):
        'The representation of the number as a decimal string'
        return self.__repr__()

    def __repr__(self):
        # 'The representation of the number as a decimal string'
        buf = _C.BN_bn2dec(self.bn)
        s = bytes(_FFI.string(buf))
        _C.OPENSSL_free(buf)
        return s.decode('utf8')

    def int(self):
        """A native python integer representation of the Big Number.
             Synonym for int(bn).
        """
        return self.__int__()

    def __int__(self):
        return int(self.__repr__())

    def __index__(self):
        return int(self.__repr__())

    def hex(self):
        """The representation of the string in hexadecimal.
        Synonym for hex(n)."""
        return self.__hex__()

    def __hex__(self):
        # """The representation of the string in hexadecimal"""
        buf = _C.BN_bn2hex(self.bn)
        s = bytes(_FFI.string(buf))
        _C.OPENSSL_free(buf)
        return s.decode("utf8")

    def binary(self):
        """Returns a byte sequence storing the absolute value of the Big
        Number in Big-Endian format (with 8 bit atoms). You need to extact the sign separately.

        Example:
            >>> bin = Bn(66051).binary()
            >>> hexlify(bin) == b'010203'
            True
        """
        if self < 0:
            raise Exception("Cannot represent negative numbers")
        size = _C.bn_num_bytes(self.bn)
        bin_string = _FFI.new("unsigned char[]", size)

        l = _C.BN_bn2bin(self.bn, bin_string)
        assert int(l) == size
        return bytes(_FFI.buffer(bin_string)[:])

    def random(self):
        """Returns a cryptographically strong random number 0 <= rnd < self.

        Example:
            >>> r = Bn(100).random()
            >>> 0 <= r < 100
            True

        """
        rnd = Bn()
        err = _C.BN_rand_range(rnd.bn, self.bn)
        if __debug__:
            _check(err)
        return rnd

    # ---------- Arithmetic --------------

    def int_neg(self):
        """Returns the negative of this number. Synonym with -self.

        Example:

            >>> one100 = Bn(100)
            >>> one100.int_neg()
            -100
            >>> -one100
            -100

        """
        return self.__neg__()

    def int_add(self, other):
        """Returns the sum of this number with another. Synonym for self + other.

        Example:

            >>> one100 = Bn(100)
            >>> two100 = Bn(200)
            >>> two100.int_add(one100) # Function syntax
            300
            >>> two100 + one100        # Operator syntax
            300

        """
        return self.__add__(other)

    def __radd__(self, other):
        return self.__add__(other)

    def __add__(self, other):
        try:
            r = Bn()
            err = _C.BN_add(r.bn, self.bn, other.bn)

            if __debug__:
                _check(err)
            return r
        except AttributeError:
            return self.__add__(Bn.from_num(other))

    def int_sub(self, other):
        """Returns the difference between this number and another.
        Synonym for self - other.

        Example:

            >>> one100 = Bn(100)
            >>> two100 = Bn(200)
            >>> two100.int_sub(one100) # Function syntax
            100
            >>> two100 - one100        # Operator syntax
            100

        """
        return self - other

    def __rsub__(self, other):
        return Bn(other) - self

    def __sub__(self, other):
        try:
            r = Bn()
            err = _C.BN_sub(r.bn, self.bn, other.bn)

            if __debug__:
                _check(err)

            return r
        except AttributeError:
            return self.__sub__(Bn.from_num(other))

    def int_mul(self, other):
        """Returns the product of this number with another.
        Synonym for self * other.

        Example:

            >>> one100 = Bn(100)
            >>> two100 = Bn(200)
            >>> one100.int_mul(two100) # Function syntax
            20000
            >>> one100 * two100        # Operator syntax
            20000

        """
        return self.__mul__(other)

    def __rmul__(self, other):
        return self.__mul__(other)

    def __mul__(self, other):

        try:
            r = Bn()
            local_ctx = get_ctx()
            err = _C.BN_mul(r.bn, self.bn, other.bn, local_ctx.bnctx)

            if __debug__:
                _check(err)

            return r
        except AttributeError:
            other = Bn.from_num(other)
            if other is NotImplemented:
                return NotImplemented
            return self.__mul__(other)


# ------------------ Mod arithmetic -------------------------


    def mod_add(self, other, m):
        """
        mod_add(other, m)
        Returns the sum of self and other modulo m.

        Example:

            >>> Bn(10).mod_add(Bn(2), Bn(11))  # Only function notation available
            1

        """
        try:
            r = Bn()
            local_ctx = get_ctx()
            err = _C.BN_mod_add(r.bn, self.bn, other.bn, m.bn, local_ctx.bnctx)
            if __debug__:
                _check(err)

            return r
        except AttributeError:
            return self.mod_add(Bn.from_num(other), Bn.from_num(m))

    def mod_sub(self, other, m):
        """
        mod_sub(other, m)
        Returns the difference of self and other modulo m.

        Example:

            >>> Bn(10).mod_sub(Bn(2), Bn(11))  # Only function notation available
            8

        """

        try:
            r = Bn()
            local_ctx = get_ctx()
            err = _C.BN_mod_sub(r.bn, self.bn, other.bn, m.bn, local_ctx.bnctx)

            if __debug__:
                _check(err)

            return r
        except AttributeError:
            return self.mod_sub(Bn.from_num(other), Bn.from_num(m))

    def mod_mul(self, other, m):
        """
        mod_mul(other, m)
        Return the product of self and other modulo m.

        Example:

            >>> Bn(10).mod_mul(Bn(2), Bn(11))  # Only function notation available
            9

        """
        try:
            r = Bn()
            local_ctx = get_ctx()
            err = _C.BN_mod_mul(r.bn, self.bn, other.bn, m.bn, local_ctx.bnctx)

            if __debug__:
                _check(err)

            return r
        except AttributeError:
            return self.mod_mul(Bn.from_num(other), Bn.from_num(m))

    def mod_inverse(self, m):
        """
        mod_inverse(m)
        Compute the inverse mod m, such that self * res == 1 mod m.

        Example:

            >>> Bn(10).mod_inverse(m = Bn(11))  # Only function notation available
            10
            >>> Bn(10).mod_mul(Bn(10), m = Bn(11)) == Bn(1)
            True

        """

        try:
            res = Bn()
            local_ctx = get_ctx()
            err = _C.BN_mod_inverse(res.bn, self.bn, m.bn, local_ctx.bnctx)

            if err == _FFI.NULL:
                errs = get_errors()

                if errs == [50770023]:
                    raise Exception("No inverse")

                elif errs == [50782316]:
                    raise Exception("No inverse")

                else:
                    raise Exception("Unknown error: %s" % errs)

            return res
        except AttributeError:
            return self.mod_inverse(Bn.from_num(m))

    def mod_pow(self, other, m, ctx=None):
        """ Performs the modular exponentiation of self ** other % m.

            Example:
                >>> one100 = Bn(100)
                >>> one100.mod_pow(2, 3)   # Modular exponentiation
                1

        """
        return self.__pow__(other, m, ctx=ctx)

    def divmod(self, other):
        """Returns the integer division and remainder of this number by another.
        Synonym for (div, mod) = divmod(self, other)"""
        return self.__divmod__(other)

    def __rdivmod__(self, other):
        return Bn(other).__divmod__(self)

    def __divmod__(self, other):
        try:
            dv = Bn()
            rem = Bn()
            local_ctx = get_ctx()
            ret = _C.BN_div(dv.bn, rem.bn, self.bn, other.bn, local_ctx.bnctx)
            if __debug__:
                _check(ret)
            return (dv, rem)
        except AttributeError:
            return self.__divmod__(Bn.from_num(other))

    def int_div(self, other):
        """Returns the integer division of this number by another.
        Synonym of self / other.

        Example:

            >>> one100 = Bn(100)
            >>> two100 = Bn(200)
            >>> two100.int_div(one100) # Function syntax
            2
            >>> two100 / one100        # Operator syntax
            2

        """
        return self.__div__(other)

    def __rdiv__(self, other):
        return Bn(other).__div__(self)

    def __div__(self, other):
        dv, _ = divmod(self, other)
        return dv

    def mod(self, other):
        """Returns the remainder of this number modulo another.
        Synonym for self % other.

        Example:

            >>> one100 = Bn(100)
            >>> two100 = Bn(200)
            >>> two100.mod(one100) # Function syntax
            0
            >>> two100 % one100        # Operator syntax
            0


        """
        return self.__mod__(other)

    def __rmod__(self, other):
        return Bn(other).__mod__(self)

    def __mod__(self, other):

        try:
            rem = Bn()

            local_ctx = get_ctx()
            err = _C.BN_nnmod(rem.bn, self.bn, other.bn, local_ctx.bnctx)

            if __debug__:
                _check(err)
            return rem
        except AttributeError:
            self.__mod__(Bn.from_num(other))

    def __rtruediv__(self, other):
        return Bn(other).__truediv__(self)

    def __truediv__(self, other):
        return self.__div__(other)

    def __rfloordiv__(self, other):
        return Bn(other).__floordiv__(self)

    def __floordiv__(self, other):
        return self.__div__(other)

    def __rpow__(self, other):
        return Bn(other).__pow__(self)

    def pow(self, other, modulo=None, ctx=None):
        """Returns the number raised to the power other optionally modulo a third number.
        Synonym with pow(self, other, modulo).

        Example:

            >>> one100 = Bn(100)
            >>> one100.pow(2)      # Function syntax
            10000
            >>> one100 ** 2        # Operator syntax
            10000
            >>> one100.pow(2, 3)   # Modular exponentiation
            1

        """
        if modulo:
            return self.__pow__(other, modulo, ctx)
        else:
            return self ** other

    def __pow__(self, other, modulo=None, ctx=None):

        try:
            res = Bn()

            if ctx is None:
                ctx = BnCtx()

            if modulo is None:
                _check(_C.BN_exp(res.bn, self.bn, other.bn, ctx.bnctx))
            else:
                _check(
                    _C.BN_mod_exp(
                        res.bn,
                        self.bn,
                        other.bn,
                        modulo.bn,
                        ctx.bnctx))

            return res
        except BaseException:
            other = Bn.from_num(other)
            if modulo is not None:
                modulo = Bn.from_num(modulo)
            return self.__pow__(other, modulo, ctx)

    def is_prime(self):
        """Returns True if the number is prime, with negligible prob. of error."""

        res = int(_C.BN_is_prime_ex(self.bn, 0, get_ctx().bnctx, _FFI.NULL))
        if res == 0:
            return False
        if res == 1:
            return True
        raise Exception("Primality test failure %s" % int(res))

    def is_odd(self):
        """Returns True if the number is odd."""

        return bool(_C.bn_is_odd(self.bn))

    def is_bit_set(self, n):
        """Returns True if the nth bit is set"""
        return int(_C.BN_is_bit_set(self.bn, n))

    def num_bits(self):
        """Returns the number of bits representing this Big Number"""
        return int(_C.BN_num_bits(self.bn))

    # Implement negative
    def __neg__(self):
        # pylint: disable=protected-access
        global zero
        ret = copy(self)
        if ret >= zero:
            ret._set_neg(1)
        else:
            ret._set_neg(0)
        return ret

    def __hash__(self):
        return int(self).__hash__()

# Unsuported
# object.__lshift__(self, other)
# object.__rshift__(self, other)
# object.__and__(self, other)
# object.__xor__(self, other)
# object.__or__(self, other)

# ---------- Tests ------------


# Some globals
zero = Bn(0)


def test_bn_constructors():
    assert Bn.from_decimal("100") == 100
    assert Bn.from_decimal("-100") == -100

    with pytest.raises(Exception) as excinfo:
        Bn.from_decimal("100ABC")
    assert 'BN Error' in str(excinfo.value)

    with pytest.raises(Exception) as excinfo:
        Bn.from_hex("100ABCZ")
    assert 'BN Error' in str(excinfo.value)

    assert Bn.from_hex(Bn(-100).hex()) == -100
    assert Bn(15).hex() == Bn(15).hex()

    with pytest.raises(Exception) as excinfo:
        Bn(-100).binary()
    assert 'negative' in str(excinfo.value)

    #assert Bn.from_binary(Bn(-100).binary()) == 100
    assert Bn.from_binary(Bn(100).binary()) == Bn(100)
    assert Bn.from_binary(Bn(100).binary()) == 100

    with pytest.raises(Exception) as excinfo:
        s = 10**10
        Bn(s)
    assert 'does not fit' in str(excinfo.value)

    with pytest.raises(Exception) as excinfo:
        _check(False)
    assert 'BN' in str(excinfo.value)

    #assert Bn.from_binary(Bn(-100).binary()) != Bn(50)
    assert int(Bn(-100)) == -100

    assert repr(Bn(5)) == Bn(5).repr() == "5"
    assert range(10)[Bn(4)] == 4

    d = {Bn(5): 5, Bn(6): 6}
    assert Bn(5) in d


def test_bn_prime():
    p = Bn.get_prime(128)
    assert p > Bn(0)
    assert p.is_prime()
    assert not Bn(16).is_prime()
    assert p.num_bits() > 127


def test_bn_arithmetic():
    assert (Bn(1) + Bn(1) == Bn(2))
    assert (Bn(1).int_add(Bn(1)) == Bn(2))

    assert (Bn(1) + 1 == Bn(2))
    # assert (1 + Bn(1) == Bn(2))

    assert (Bn(1) + Bn(-1) == Bn(0))
    assert (Bn(10) + Bn(10) == Bn(20))
    assert (Bn(-1) * Bn(-1) == Bn(1))
    assert (Bn(-1).int_mul(Bn(-1)) == Bn(1))

    assert (Bn(10) * Bn(10) == Bn(100))
    assert (Bn(10) - Bn(10) == Bn(0))
    assert (Bn(10) - Bn(100) == Bn(-90))
    assert (Bn(10) + (-Bn(10)) == Bn(0))
    s = -Bn(100)
    assert (Bn(10) + s == Bn(-90))
    assert (Bn(10) - (-Bn(10)) == Bn(20))
    assert -Bn(-10) == 10
    assert Bn(-10).int_neg() == 10

    assert divmod(Bn(10), Bn(3)) == (Bn(3), Bn(1))
    assert Bn(10).divmod(Bn(3)) == (Bn(3), Bn(1))

    assert Bn(10) / Bn(3) == Bn(3)
    assert Bn(10) // Bn(3) == Bn(3)
    assert Bn(10).int_div(Bn(3)) == Bn(3)

    assert Bn(10) % Bn(3) == Bn(1)
    assert Bn(10).mod(Bn(3)) == Bn(1)

    assert Bn(2) ** Bn(8) == Bn(2 ** 8)
    assert pow(Bn(2), Bn(8), Bn(27)) == Bn(2 ** 8 % 27)

    pow(Bn(10), Bn(10)).binary()

    assert pow(Bn(2), 8, 27) == 2 ** 8 % 27

    assert Bn(3).mod_inverse(16) == 11

    with pytest.raises(Exception) as excinfo:
        Bn(3).mod_inverse(0)
        print("Got inverse")
    assert 'No inverse' in str(excinfo.value)

    with pytest.raises(Exception) as excinfo:
        x = Bn(0).mod_inverse(Bn(13))
        print("!!! Got inverse", x)
    assert 'No inverse' in str(excinfo.value)

    # with pytest.raises(Exception) as excinfo:
    #    x = Bn(0).mod_inverse(Bn(13))
    #    print("Got inverse", x)
    #assert 'No inverse' in str(excinfo.value)

    assert Bn(10).mod_add(10, 15) == (10 + 10) % 15
    assert Bn(10).mod_sub(100, 15) == (10 - 100) % 15
    assert Bn(10).mod_mul(10, 15) == (10 * 10) % 15
    assert Bn(-1).bool()


def test_bn_right_arithmetic():
    assert (1 + Bn(1) == Bn(2))

    assert (-1 * Bn(-1) == Bn(1))

    assert (10 * Bn(10) == Bn(100))
    assert (10 - Bn(10) == Bn(0))
    assert (10 - Bn(100) == Bn(-90))
    assert (10 + (-Bn(10)) == Bn(0))
    s = -Bn(100)
    assert (10 + s == Bn(-90))
    assert (10 - (-Bn(10)) == Bn(20))

    assert divmod(10, Bn(3)) == (Bn(3), Bn(1))

    assert 10 / Bn(3) == Bn(3)
    assert 10 // Bn(3) == Bn(3)

    assert 10 % Bn(3) == Bn(1)
    assert 2 ** Bn(8) == Bn(2 ** 8)

    assert 100 == Bn(100)

    pow(10, Bn(10))


def test_bn_allocate():
    # Test allocation
    n0 = Bn(10)
    assert True

    assert str(Bn()) == "0"
    assert str(Bn(1)) == "1"
    assert str(Bn(-1)) == "-1"

    assert Bn(15).hex() == "0F"
    assert Bn(-15).hex() == "-0F"

    assert int(Bn(5)) == 5
    assert Bn(5).int() == 5

    assert 0 <= Bn(15).random() < 15

    # Test copy
    o0 = copy(n0)
    o1 = deepcopy(n0)

    assert o0 == n0
    assert o1 == n0

    # Test nonzero
    assert not Bn()
    assert not Bn(0)
    assert Bn(1)
    assert Bn(100)


def test_bn_cmp():
    assert Bn(1) < Bn(2)
    assert Bn(1) <= Bn(2)
    assert Bn(2) <= Bn(2)
    assert Bn(2) == Bn(2)
    assert Bn(2) <= Bn(3)
    assert Bn(2) < Bn(3)


def test_extras():
    two = Bn(2)
    two2 = two.copy()
    assert two == two2


def test_odd():
    assert Bn(1).is_odd()
    assert Bn(1).is_bit_set(0)
    assert not Bn(1).is_bit_set(1)

    assert Bn(3).is_odd()
    assert Bn(3).is_bit_set(0)
    assert Bn(3).is_bit_set(1)

    assert not Bn(0).is_odd()
    assert not Bn(2).is_odd()

    assert Bn(100).is_bit_set(Bn(100).num_bits() - 1)


def test_check():
    with pytest.raises(Exception) as excinfo:
        _check(False)
    assert 'BN' in str(excinfo.value)

    with pytest.raises(Exception) as excinfo:
        _check(-1)
    assert 'BN' in str(excinfo.value)

    with pytest.raises(Exception) as excinfo:
        _check(0)
    assert 'BN' in str(excinfo.value)


def test_timing_exp():
    p = Bn.from_decimal("158261031819091141711717027498980088325079888681498417129323009913367867128038610210948802263526234270043507882496188624614467036250990588401775690578042934008692254417273606807265961724843618743242066301529332478013432957153823449143202719186309012133210922613102725038632605463022887306439116579645787938883")
    psmall = Bn.from_decimal(
        "90123082853250477832412338337738008391831682960497136029451532639902615425459")

    xs = [p.random() for _ in range(1000)]
    ys = [p.random() for _ in range(1000)]

    import time

    print
    t0 = time.time()
    X = [xi.mod_mul(yi, psmall) for (xi, yi) in zip(xs, ys)]
    t1 = time.time()
    print("Mod_mul time: %.2fms" % ((t1 - t0) * 1000.0 / 1000.0))

    t0 = time.time()
    X = [xi.pow(yi, p) for (xi, yi) in zip(xs, ys)]
    t1 = time.time()
    print("    Pow time: %.2fms" % ((t1 - t0) * 1000.0 / 1000.0))

    ctx = BnCtx()
    t0 = time.time()
    X = [xi.pow(yi, p, ctx) for (xi, yi) in zip(xs, ys)]
    t1 = time.time()
    print("Pow ctx time: %.2fms" % ((t1 - t0) * 1000.0 / 1000.0))
