from .bindings import _FFI, _C, _OPENSSL_VERSION, OpenSSLVersion

import pytest


def _check(return_val):
    """Checks the return code of the C calls"""
    if isinstance(return_val, int) and return_val == 1:
        return
    if isinstance(return_val, bool) and return_val == True:
        return

    raise Exception(
        "Cipher exception: Unknown type %s or value %s" %
        (str(
            type(return_val)),
            str(return_val)))


class Cipher(object):
    """A class representing a symmetric cipher and mode.

    Example:
        An example of encryption and decryption using AES in counter mode.

        >>> from os import urandom
        >>> aes = Cipher("AES-128-CTR")     # Init AES in Counter mode
        >>> key = urandom(16)
        >>> iv  = urandom(16)
        >>>
        >>> # Get a CipherOperation object for encryption
        >>> enc = aes.enc(key, iv)
        >>> ref = b"Hello World"
        >>> ciphertext = enc.update(ref)
        >>> ciphertext += enc.finalize()
        >>>
        >>> # Get a CipherOperation object for decryption
        >>> dec = aes.dec(key, iv)
        >>> plaintext = dec.update(ciphertext)
        >>> plaintext += dec.finalize()
        >>> plaintext == ref # Check resulting plaintest matches referece one.
        True

    """

    __slots__ = ["alg", "gcm"]

    def __init__(self, name, _alg=None):
        """Initialize the cipher by name."""

        if _alg:
            self.alg = _alg
            self.gcm = True
            return
        else:

            self.alg = _C.EVP_get_cipherbyname(name.encode("utf8"))
            self.gcm = False
            if self.alg == _FFI.NULL:
                raise Exception("Unknown cipher: %s" % name)

        if "gcm" in name.lower():
            self.gcm = True

        if "ccm" in name.lower():
            raise Exception("CCM mode not supported")

    def len_IV(self):
        """Return the Initialization Vector length in bytes."""
        if _OPENSSL_VERSION == OpenSSLVersion.V1_0:
            return int(self.alg.iv_len)
        else:
            return int(_C.EVP_CIPHER_iv_length(self.alg))

    def len_key(self):
        """Return the secret key length in bytes."""
        if _OPENSSL_VERSION == OpenSSLVersion.V1_0:
            return int(self.alg.key_len)
        else:
            return int(_C.EVP_CIPHER_key_length(self.alg))

    def len_block(self):
        """Return the block size in bytes."""
        if _OPENSSL_VERSION == OpenSSLVersion.V1_0:
            return int(self.alg.block_size)
        else:
            return int(_C.EVP_CIPHER_block_size(self.alg))

    def get_nid(self):
        """Return the OpenSSL nid of the cipher and mode."""
        if _OPENSSL_VERSION == OpenSSLVersion.V1_0:
            return int(self.alg.nid)
        else:
            return int(_C.EVP_CIPHER_nid(self.alg))

    def op(self, key, iv, enc=1):
        """Initializes a cipher operation, either encrypt or decrypt
        and returns a CipherOperation object

        Args:
            key (str): the block cipher symmetric key. Length depends on block cipher choice.
            iv (str): an Initialization Vector of up to the block size. (Can be shorter.)
            enc (int): set to 1 to perform encryption, or 0 to perform decryption.

        """
        c_op = CipherOperation(enc)
        _check(len(key) == self.len_key())
        _check(enc in [0, 1])

        if not self.gcm:
            _check(len(iv) == self.len_IV())
            _check(_C.EVP_CipherInit_ex(c_op.ctx,
                                        self.alg, _FFI.NULL, key, iv, enc))

        else:
            _check(_C.EVP_CipherInit_ex(c_op.ctx,
                                        self.alg, _FFI.NULL, _FFI.NULL, _FFI.NULL, enc))

            # assert len(iv) <= self.len_block()

            _check(_C.EVP_CIPHER_CTX_ctrl(c_op.ctx,
                                          _C.EVP_CTRL_GCM_SET_IVLEN, len(iv), _FFI.NULL))

            _C.EVP_CIPHER_CTX_ctrl(
                c_op.ctx, _C.EVP_CTRL_GCM_SET_IV_FIXED, -1, iv)
            _C.EVP_CIPHER_CTX_ctrl(c_op.ctx, _C.EVP_CTRL_GCM_IV_GEN, 0, iv)

            _check(_C.EVP_CipherInit_ex(c_op.ctx,
                                        _FFI.NULL, _FFI.NULL, key, iv, enc))

        c_op.cipher = self
        return c_op

    def enc(self, key, iv):
        """Initializes an encryption engine with the cipher with a specific key and Initialization Vector (IV).
        Returns the CipherOperation engine.

        Args:
            key (str): the block cipher symmetric key. Length depends on block cipher choice.
            iv (str): an Initialization Vector of up to the block size. (Can be shorter.)

        """
        return self.op(key, iv, enc=1)

    def dec(self, key, iv):
        """Initializes a decryption engine with the cipher with a specific key and Initialization Vector (IV).
        Returns the CipherOperation engine.

        Args:
            key (str): the block cipher symmetric key. Length depends on block cipher choice.
            iv (str): an Initialization Vector of up to the block size. (Can be shorter.)

        """
        return self.op(key, iv, enc=0)

    def __del__(self):
        pass

# --------- AES GCM special functions ---------------

    @staticmethod
    def aes_128_gcm():
        """Returns a pre-initalized AES-GCM cipher with 128 bits key size"""
        return Cipher(None, _C.EVP_aes_128_gcm())

    @staticmethod
    def aes_192_gcm():
        """Returns a pre-initalized AES-GCM cipher with 192 bits key size"""
        return Cipher(None, _C.EVP_aes_192_gcm())

    @staticmethod
    def aes_256_gcm():
        """Returns a pre-initalized AES-GCM cipher with 256 bits key size"""
        return Cipher(None, _C.EVP_aes_256_gcm())

    def quick_gcm_enc(self, key, iv, msg, assoc=None, tagl=16):
        """One operation GCM encryption.

        Args:
            key (str): the AES symmetric key. Length depends on block cipher choice.
            iv (str): an Initialization Vector of up to the block size. (Can be shorter.)
            msg (str): the message to encrypt.
            assoc (str): associated data that will be integrity protected, but not encrypted.
            tagl (int): the length of the tag, up to the block length.

        Example:
            Use of `quick_gcm_enc` and `quick_gcm_dec` for AES-GCM operations.

            >>> from os import urandom      # Secure OS random source
            >>> aes = Cipher("aes-128-gcm") # Initialize AES-GCM with 128 bit keys
            >>> iv = urandom(16)
            >>> key = urandom(16)
            >>> # Encryption using AES-GCM returns a ciphertext and a tag
            >>> ciphertext, tag = aes.quick_gcm_enc(key, iv, b"Hello")
            >>> # Decrytion using AES-GCM
            >>> p = aes.quick_gcm_dec(key, iv, ciphertext, tag)
            >>> assert p == b'Hello'

        """
        enc = self.enc(key, iv)
        if assoc:
            enc.update_associated(assoc)
        ciphertext = enc.update(msg)
        ciphertext += enc.finalize()
        tag = enc.get_tag(tagl)

        return (ciphertext, tag)

    def quick_gcm_dec(self, key, iv, cip, tag, assoc=None):
        """One operation GCM decrypt. See usage example in "quick_gcm_enc".
        Throws an exception on failure of decryption

        Args:
            key (str): the AES symmetric key. Length depends on block cipher choice.
            iv (str): an Initialization Vector of up to the block size. (Can be shorter.)
            cip (str): the ciphertext to decrypt.
            tag (int): the integrity tag.
            assoc (str): associated data that will be integrity protected, but not encrypted.

        """
        dec = self.dec(key, iv)
        if assoc:
            dec.update_associated(assoc)

        dec.set_tag(tag)
        plain = dec.update(cip)

        try:
            plain += dec.finalize()
        except BaseException:
            raise Exception("Cipher: decryption failed.")
        return plain


class CipherOperation(object):

    __slots__ = ["ctx", "cipher", "xenc"]

    def __init__(self, xenc):
        self.ctx = _C.EVP_CIPHER_CTX_new()
        self.cipher = None
        self.xenc = xenc

    def update(self, data):
        """Processes some data, and returns a partial result."""
        block_len = self.cipher.len_block()
        alloc_len = len(data) + block_len + 1
        outl = _FFI.new("int *")
        outl[0] = alloc_len
        out = _FFI.new("unsigned char[]", alloc_len)

        _check(_C.EVP_CipherUpdate(self.ctx, out, outl, data, len(data)))

        ret = bytes(_FFI.buffer(out)[:int(outl[0])])
        return ret

    def finalize(self):
        """Finalizes the operation and may return some additional data.
        Throws an exception if the authenticator tag is different from the expected value.

        Example:
            Example of the exception thrown when an invalid tag is provided.

            >>> from os import urandom
            >>> aes = Cipher.aes_128_gcm()              # Define an AES-GCM cipher
            >>> iv = urandom(16)
            >>> key = urandom(16)
            >>> ciphertext, tag = aes.quick_gcm_enc(key, iv, b"Hello")
            >>>
            >>> dec = aes.dec(key, iv)                  # Get a decryption CipherOperation
            >>> dec.set_tag(urandom(len(tag)))          # Provide an invalid tag.
            >>> plaintext = dec.update(ciphertext)      # Feed in the ciphertext for decryption.
            >>> try:
            ...    dec.finalize()                       # Check and Finalize.
            ... except:
            ...    print("Failure")
            Failure

            Throws an exception since integrity check fails due to the invalid tag.

        """
        block_len = self.cipher.len_block()
        alloc_len = block_len
        outl = _FFI.new("int *")
        outl[0] = alloc_len
        out = _FFI.new("unsigned char[]", alloc_len)

        try:
            _check(_C.EVP_CipherFinal_ex(self.ctx, out, outl))
            if outl[0] == 0:
                return b''

            ret = bytes(_FFI.buffer(out)[:int(outl[0])])
            return ret
        except BaseException:
            raise Exception("Cipher: decryption failed.")

    def update_associated(self, data):
        """Processes some GCM associated data, and returns nothing."""

        if self.xenc == 0:
            self.set_tag(b"\00" * 16)

        outl = _FFI.new("int *")
        _check(_C.EVP_CipherUpdate(self.ctx, _FFI.NULL, outl, data, len(data)))
        _check(outl[0] == len(data))

    def get_tag(self, tag_len=16):
        """Get the GCM authentication tag. Execute after finalizing the encryption.

        Example:
            AES-GCM encryption usage:

            >>> from os import urandom
            >>> aes = Cipher.aes_128_gcm()          # Initialize AES cipher
            >>> key = urandom(16)
            >>> iv = urandom(16)
            >>> enc = aes.enc(key, iv)              # Get an encryption CipherOperation
            >>> enc.update_associated(b"Hello")     # Include some associated data
            >>> ciphertext = enc.update(b"World!")  # Include some plaintext
            >>> nothing = enc.finalize()            # Finalize
            >>> tag = enc.get_tag(16)               # Get the AES-GCM tag

        """
        tag = _FFI.new("unsigned char []", tag_len)
        ret = _C.EVP_CIPHER_CTX_ctrl(
            self.ctx, _C.EVP_CTRL_GCM_GET_TAG, tag_len, tag)
        _check(ret)
        s = bytes(_FFI.buffer(tag)[:])
        return s

    def set_tag(self, tag):
        """Specify the GCM authenticator tag. Must be done before finalizing decryption

        Example:
            AES-GCM decryption and check:

            >>> aes = Cipher.aes_128_gcm()              # Define an AES-GCM cipher
            >>> ciphertext, tag = (b'dV\\xb9:\\xd0\\xbe', b'pA\\xbe?\\xfc\\xd1&\\x03\\x1438\\xc5\\xf8In\\xaa')
            >>> dec = aes.dec(key=b"A"*16, iv=b"A"*16)  # Get a decryption CipherOperation
            >>> dec.update_associated(b"Hello")         # Feed in the non-secret assciated data.
            >>> plaintext = dec.update(ciphertext)      # Feed in the ciphertext for decryption.
            >>> dec.set_tag(tag)                        # Provide the AES-GCM tag for integrity.
            >>> nothing = dec.finalize()                # Check and finalize.
            >>> assert plaintext == b'World!'

        """
        _check(
            _C.EVP_CIPHER_CTX_ctrl(
                self.ctx,
                _C.EVP_CTRL_GCM_SET_TAG,
                len(tag),
                tag))

    def __del__(self):
        _C.EVP_CIPHER_CTX_free(self.ctx)


# When testing ignore extra variables
# pylint: disable=unused-variable,redefined-outer-name

def test_aes_init():
    aes = Cipher("AES-128-CBC")
    assert aes.alg != _FFI.NULL
    assert aes.len_IV() == 16
    assert aes.len_block() == 16
    assert aes.len_key() == 16
    assert aes.get_nid() == 419
    del aes


def test_errors():
    with pytest.raises(Exception) as excinfo:
        aes = Cipher("AES-128-XXF")
    assert 'Unknown' in str(excinfo.value)


def test_aes_enc():
    aes = Cipher("AES-128-CBC")
    enc = aes.op(key=b"A" * 16, iv=b"A" * 16)

    ref = b"Hello World" * 10000

    ciphertext = enc.update(ref)
    ciphertext += enc.finalize()

    dec = aes.op(key=b"A" * 16, iv=b"A" * 16, enc=0)
    plaintext = dec.update(ciphertext)
    plaintext += dec.finalize()
    assert plaintext == ref


def test_aes_ctr():
    aes = Cipher("AES-128-CTR")
    enc = aes.op(key=b"A" * 16, iv=b"A" * 16)

    ref = b"Hello World" * 10000

    ciphertext = enc.update(ref)
    ciphertext += enc.finalize()

    dec = aes.op(key=b"A" * 16, iv=b"A" * 16, enc=0)
    plaintext = dec.update(ciphertext)
    plaintext += dec.finalize()
    assert plaintext == ref


def test_aes_ops():
    aes = Cipher("AES-128-CTR")
    enc = aes.enc(key=b"A" * 16, iv=b"A" * 16)

    ref = b"Hello World" * 10000

    ciphertext = enc.update(ref)
    ciphertext += enc.finalize()

    dec = aes.dec(key=b"A" * 16, iv=b"A" * 16)
    plaintext = dec.update(ciphertext)
    plaintext += dec.finalize()
    assert plaintext == ref


def test_aes_gcm_encrypt():
    aes = Cipher.aes_128_gcm()
    assert aes.gcm

    enc = aes.op(key=b"A" * 16, iv=b"A" * 16)

    enc.update_associated(b"Hello")
    ciphertext = enc.update(b"World!")
    c2 = enc.finalize()
    assert c2 == b''

    tag = enc.get_tag(16)
    assert len(tag) == 16


def test_aes_gcm_encrypt_192():
    aes = Cipher.aes_192_gcm()
    assert aes.gcm

    enc = aes.op(key=b"A" * 24, iv=b"A" * 16)

    enc.update_associated(b"Hello")
    ciphertext = enc.update(b"World!")
    c2 = enc.finalize()
    assert c2 == b''

    tag = enc.get_tag(16)
    assert len(tag) == 16


def test_aes_gcm_encrypt_256():
    aes = Cipher.aes_256_gcm()
    assert aes.gcm

    enc = aes.op(key=b"A" * 32, iv=b"A" * 16)

    enc.update_associated(b"Hello")
    ciphertext = enc.update(b"World!")
    c2 = enc.finalize()
    assert c2 == b''

    tag = enc.get_tag(16)
    assert len(tag) == 16


@pytest.fixture
def aesenc():
    aes = Cipher.aes_128_gcm()
    assert aes.gcm

    enc = aes.op(key=b"A" * 16, iv=b"A" * 16)

    enc.update_associated(b"Hello")
    ciphertext = enc.update(b"World!")
    c2 = enc.finalize()
    assert c2 == b''

    tag = enc.get_tag(16)
    assert len(tag) == 16

    return (aes, enc, ciphertext, tag)


def test_gcm_dec(aesenc):
    aes, enc, ciphertext, tag = aesenc
    dec = aes.dec(key=b"A" * 16, iv=b"A" * 16)
    dec.update_associated(b"Hello")
    plaintext = dec.update(ciphertext)

    dec.set_tag(tag)

    dec.finalize()

    assert plaintext == b"World!"


def test_gcm_dec_badassoc(aesenc):
    aes, enc, ciphertext, tag = aesenc

    dec = aes.dec(key=b"A" * 16, iv=b"A" * 16)
    dec.update_associated(b"H4llo")
    plaintext = dec.update(ciphertext)

    dec.set_tag(tag)

    with pytest.raises(Exception) as excinfo:
        dec.finalize()
    assert "Cipher" in str(excinfo.value)


def test_gcm_dec_badkey(aesenc):
    aes, enc, ciphertext, tag = aesenc

    dec = aes.dec(key=b"B" * 16, iv=b"A" * 16)
    dec.update_associated(b"Hello")
    plaintext = dec.update(ciphertext)

    dec.set_tag(tag)

    with pytest.raises(Exception) as excinfo:
        dec.finalize()
    assert "Cipher" in str(excinfo.value)


def test_gcm_dec_badiv(aesenc):
    aes, enc, ciphertext, tag = aesenc
    dec = aes.dec(key=b"A" * 16, iv=b"B" * 16)
    dec.update_associated(b"Hello")
    plaintext = dec.update(ciphertext)

    dec.set_tag(tag)

    with pytest.raises(Exception) as excinfo:
        dec.finalize()
    assert "Cipher" in str(excinfo.value)


def test_aes_gcm_byname():
    aes = Cipher("aes-128-gcm")
    assert aes.gcm

    enc = aes.op(key=b"A" * 16, iv=b"A" * 16)

    enc.update_associated(b"Hello")
    ciphertext = enc.update(b"World!")
    c2 = enc.finalize()
    assert c2 == b''

    tag = enc.get_tag(16)
    assert len(tag) == 16

    dec = aes.dec(key=b"A" * 16, iv=b"A" * 16)
    dec.update_associated(b"Hello")
    plaintext = dec.update(ciphertext)

    dec.set_tag(tag)

    dec.finalize()

    assert plaintext == b"World!"


def test_aes_gcm_different_IV():
    aes = Cipher("aes-128-gcm")

    enc = aes.op(key=b"A" * 16, iv=b"A" * 16)
    enc.update_associated(b"Hello")
    ciphertext = enc.update(b"World!")
    c2 = enc.finalize()
    tag = enc.get_tag(16)

    enc = aes.op(key=b"A" * 16, iv=b"A" * 16)
    enc.update_associated(b"Hello")
    ciphertext2 = enc.update(b"World!")
    c2 = enc.finalize()
    tag2 = enc.get_tag(16)

    enc = aes.op(key=b"A" * 16, iv=b"B" * 16)
    enc.update_associated(b"Hello")
    ciphertext3 = enc.update(b"World!")
    c2 = enc.finalize()
    tag3 = enc.get_tag(16)

    assert ciphertext == ciphertext2
    assert ciphertext != ciphertext3


def test_quick():
    aes = Cipher("aes-128-gcm")
    c, t = aes.quick_gcm_enc(b"A" * 16, b"A" * 16, b"Hello")
    p = aes.quick_gcm_dec(b"A" * 16, b"A" * 16, c, t)
    assert p == b"Hello"


def test_quick_assoc():
    aes = Cipher("aes-128-gcm")
    c, t = aes.quick_gcm_enc(b"A" * 16, b"A" * 16, b"Hello", assoc=b"blah")
    p = aes.quick_gcm_dec(b"A" * 16, b"A" * 16, c, t, assoc=b"blah")
    assert p == b"Hello"

# pylint: enable=unused-variable,redefined-outer-name
