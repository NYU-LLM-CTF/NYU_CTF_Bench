from .bindings import _FFI, _C, _OPENSSL_VERSION, OpenSSLVersion

from binascii import hexlify

import pytest


def _check(return_val):
    """Checks the return code of the C calls"""
    if isinstance(return_val, int) and return_val == 1:
        return
    if isinstance(return_val, bool) and return_val == True:
        return

    raise Exception("HMAC exception")


def secure_compare(a1, a2):
    """A constant-time comparison function. Returns True if the two strings are equal and False otherwise.

    Args:
        a1 (str): the first string
        a2 (str): the second string

    Returns:
        bool: whether the two stings are equal.
    """
    _check(isinstance(a1, type(a2)))

    if len(a1) != len(a2):
        return False

    x = _C.CRYPTO_memcmp(a1, a2, len(a1))
    if int(x) == 0:
        return True

    return False


class Hmac(object):
    """Initialize the HMAC by name with a key.

    Args:
        name: the name of the hash function to be used.
        key: the cryptographic symmetric key of the HMAC.

    Returns:
        An HMAC instance, ready to accept data to MAC.

    Example:

        >>> h = Hmac(b"sha512", b"Jefe")
        >>> h.update(b"what do ya want ")
        >>> h.update(b"for nothing?")
        >>> d = h.digest()
        >>> len(d)
        64
        >>> hexlify(d)[:10] == b"164b7a7bfc"
        True

    """

    def __init__(self, name, key):
        self.mac_ctx = None
        md = _C.EVP_get_digestbyname(name)
        if md == _FFI.NULL:
            raise Exception("HMAC Error loading function %s" % name)

        self.outsize = _C.EVP_MD_size(md)
        if _OPENSSL_VERSION == OpenSSLVersion.V1_0:
            self.mac_ctx = _FFI.new("HMAC_CTX *")
            _C.HMAC_CTX_init(self.mac_ctx)
        else:
            self.mac_ctx = _C.HMAC_CTX_new()

        _check(_C.HMAC_Init_ex(self.mac_ctx, key, len(key), md, _FFI.NULL))
        self.active = True

    def update(self, data):
        """Update the HMAC with some data to authenticate.

        Args:
            data: the data to add to the MAC.

        Note: you must not call update after you finalize the HMAC.

        Raises:
            Exception: if called after the HMAC has been finalized.
        """
        if not self.active:
            raise Exception("HMAC already finalized!")
        _check(_C.HMAC_Update(self.mac_ctx, data, len(data)))

    def digest(self):
        """Output the HMAC digest as a binary string.

        Returns:
            The digest as a binary data string.
        """
        if not self.active:
            raise Exception("HMAC already finalized!")

        self.active = False
        out_md = _FFI.new("unsigned char[]", self.outsize)
        out_len = _FFI.new("unsigned int *")
        _check(_C.HMAC_Final(self.mac_ctx, out_md, out_len))

        if int(out_len[0]) != self.outsize:
            raise Exception("HMAC Unexpected length")

        return bytes(_FFI.buffer(out_md)[:])

    def __del__(self):
        if self.mac_ctx is not None and _OPENSSL_VERSION == OpenSSLVersion.V1_1:
            _C.HMAC_CTX_free(self.mac_ctx)


def test_init():
    h = Hmac(b"md5", b"Hello")
    h.update(b"hello")
    d = h.digest()
    assert d
    assert len(d) == 128 / 8


def test_vectors():
    """
    Key =          4a656665                          ("Jefe")
   Data =         7768617420646f2079612077616e7420  ("what do ya want ")
                  666f72206e6f7468696e673f          ("for nothing?")

   HMAC-SHA-224 = a30e01098bc6dbbf45690f3a7e9e6d0f
                  8bbea2a39e6148008fd05e44
   HMAC-SHA-256 = 5bdcc146bf60754e6a042426089575c7
                  5a003f089d2739839dec58b964ec3843
   HMAC-SHA-384 = af45d2e376484031617f78d2b58a6b1b
                  9c7ef464f5a01b47e42ec3736322445e
                  8e2240ca5e69e2c78b3239ecfab21649
   HMAC-SHA-512 = 164b7a7bfcf819e2e395fbe73b56e0a3
                  87bd64222e831fd610270cd7ea250554
                  9758bf75c05a994a6d034f65f8f0e6fd
                  caeab1a34d4a6b4b636e070a38bce737
    """

    h = Hmac(b"sha512", b"Jefe")
    assert 512 / 8 == h.outsize
    h.update(b"what do ya want ")
    h.update(b"for nothing?")
    d = h.digest()

    with pytest.raises(Exception) as excinfo:
        h.update(b"some more")
    assert 'finalized' in str(excinfo.value)

    with pytest.raises(Exception) as excinfo:
        h.digest()
    assert 'finalized' in str(excinfo.value)

    with pytest.raises(Exception) as excinfo:
        h = Hmac(b"sha999", b"Jefe")
    assert 'Error' in str(excinfo.value)

    ans1 = hexlify(d)
    ans2 = b"164b7a7bfcf819e2e395fbe73b56e0a387bd64222e831fd610270cd7ea2505549758bf75c05a994a6d034f65f8f0e6fdcaeab1a34d4a6b4b636e070a38bce737"

    assert len(ans1) == len(ans2)
    assert ans1 == ans2


def test_cmp():
    assert secure_compare(b"Hello", b"Hello")
    assert not secure_compare(b"Hello", b"Hellx")
    assert not secure_compare(b"Hello", b"Hell")

    with pytest.raises(Exception) as excinfo:
        assert not secure_compare(b"Hello", 2)
    assert 'HMAC' in str(excinfo.value)
