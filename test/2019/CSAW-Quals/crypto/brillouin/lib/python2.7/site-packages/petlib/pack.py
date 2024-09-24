"""The module provides functions to pack and unpack petlib Bn, EcGroup, and EcPt
strucures.

Example:
    >>> # Define a custom class, encoder and decoder
    >>> class CustomType:
    ...     def __eq__(self, other):
    ...         return isinstance(other, CustomType)
    >>>
    >>> def enc_custom(obj):
    ...     return b''
    >>>
    >>> def dec_custom(data):
    ...     return CustomType()
    >>>
    >>> register_coders(CustomType, 10, enc_custom, dec_custom)
    >>>
    >>> # Define a structure
    >>> G = EcGroup()
    >>> custom_obj = CustomType()
    >>> test_data = [G, G.generator(), G.order(), custom_obj]
    >>>
    >>> # Encode and decode custom structure
    >>> packed = encode(test_data)
    >>> x = decode(packed)
    >>> assert x == test_data

"""

import msgpack

from .ec import EcGroup, EcPt
from .bn import Bn

__all__ = ["encode", "decode", "register_coders"]

_pack_reg = {}
_unpack_reg = {}


def register_coders(cls, num, enc_func, dec_func):
    """ Register a new type for encoding and decoding.
    Take a class type, a number, an encoding and a decoding function."""

    if num in _unpack_reg or cls in _pack_reg:
        raise Exception("Class or number already in use.")

    coders = (cls, num, enc_func, dec_func)
    _pack_reg[cls] = coders
    _unpack_reg[num] = coders


def bn_enc(obj):
    if obj < 0:
        neg = b"-"
        data = (-obj).binary()
    else:
        neg = b"+"
        data = obj.binary()
    return neg + data


def bn_dec(data):
    num = Bn.from_binary(data[1:])
    # Accomodate both Python 2 and Python 3
    if data[0] == ord("-") or data[0] == "-":
        return -num
    return num


def ecg_enc(obj):
    # Serialize EcGroup objects
    nid = obj.nid()
    packed_nid = msgpack.packb(nid)
    return packed_nid


def ecg_dec(data):
    # Decode EcGroup
    nid = msgpack.unpackb(data)
    return EcGroup(nid)


def ecpt_enc(obj):
    # Serialize EcPt objects
    nid = obj.group.nid()
    data = obj.export()
    packed_data = msgpack.packb((nid, data))
    return packed_data


def ecpt_dec(data):
    # Decode EcPt
    nid, ptdata = msgpack.unpackb(data)
    return EcPt.from_binary(ptdata, EcGroup(nid))


def _init_coders():
    global _pack_reg, _unpack_reg
    _pack_reg, _unpack_reg = {}, {}
    register_coders(Bn, 0, bn_enc, bn_dec)
    register_coders(EcGroup, 1, ecg_enc, ecg_dec)
    register_coders(EcPt, 2, ecpt_enc, ecpt_dec)


# Register default coders
_init_coders()


def default(obj):
    # Serialize Bn objects
    for T in _pack_reg:
        if isinstance(obj, T):
            _, num, enc, _ = _pack_reg[T]
            return msgpack.ExtType(num, enc(obj))

    raise TypeError("Unknown type: %r" % (type(obj),))


def make_encoder(out_encoder=None):
    if out_encoder is None:
        return default
    else:
        def new_encoder(obj):
            try:
                encoded = default(obj)
                return encoded
            except BaseException:
                return out_encoder(obj)
        return new_encoder


def ext_hook(code, data):
    if code in _unpack_reg:
        _, _, _, dec = _unpack_reg[code]
        return dec(data)

    # Other
    return msgpack.ExtType(code, data)


def make_decoder(custom_decoder=None):
    if custom_decoder is None:
        return ext_hook
    else:
        def new_decoder(code, data):
            out = ext_hook(code, data)
            if not isinstance(out, msgpack.ExtType):
                return out
            else:
                return custom_decoder(code, data)
        return new_decoder


def encode(structure, custom_encoder=None):
    """ Encode a structure containing petlib objects to a binary format. May define a custom encoder for user classes. """
    encoder = make_encoder(custom_encoder)
    packed_data = msgpack.packb(structure, default=encoder, use_bin_type=True)
    return packed_data


def decode(packed_data, custom_decoder=None):
    """ Decode a binary byte sequence into a structure containing pelib objects. May define a custom decoder for custom classes. """
    decoder = make_decoder(custom_decoder)
    structure = msgpack.unpackb(
        packed_data,
        ext_hook=decoder,
        encoding='utf-8')
    return structure

# --- TESTS ---


def test_basic():
    x = [b'spam', u'egg']
    packed = msgpack.packb(x, use_bin_type=True)
    y = msgpack.unpackb(packed, encoding='utf-8')
    assert x == y


def test_bn():
    bn1, bn2 = Bn(1), Bn(2)
    test_data = [bn1, bn2, -bn1, -bn2]
    packed = msgpack.packb(test_data, default=default, use_bin_type=True)
    x = msgpack.unpackb(packed, ext_hook=ext_hook, encoding='utf-8')
    assert x == test_data


def test_ecgroup():
    G = EcGroup()
    test_data = [G]
    packed = msgpack.packb(test_data, default=default, use_bin_type=True)
    x = msgpack.unpackb(packed, ext_hook=ext_hook, encoding='utf-8')
    assert x == test_data


def test_ecpt():
    G = EcGroup()
    test_data = [G.generator()]
    packed = msgpack.packb(test_data, default=default, use_bin_type=True)
    x = msgpack.unpackb(packed, ext_hook=ext_hook, encoding='utf-8')
    assert x == test_data


def test_mixed():
    G = EcGroup()
    test_data = [G, G.generator(), G.order()]
    packed = msgpack.packb(test_data, default=default, use_bin_type=True)
    x = msgpack.unpackb(packed, ext_hook=ext_hook, encoding='utf-8')
    assert x == test_data


def test_enc_dec():
    G = EcGroup()
    test_data = [G, G.generator(), G.order()]
    packed = encode(test_data)
    x = decode(packed)
    assert x == test_data


def test_enc_dec_dict():
    G = EcGroup()
    # , G.generator():"1", "2":G.order()}
    test_data = {G.order(): [G, G.generator()]}
    packed = encode(test_data)
    x = decode(packed)
    assert x[G.order()] == test_data[G.order()]


def test_enc_dec_custom():

    # Define a custom class, encoder and decoder
    class CustomClass:
        def __eq__(self, other):
            return isinstance(other, CustomClass)

    def enc_CustomClass(obj):
        if isinstance(obj, CustomClass):
            return msgpack.ExtType(11, b'')
        raise TypeError("Unknown type: %r" % (obj,))

    def dec_CustomClass(code, data):
        if code == 11:
            return CustomClass()

        return msgpack.ExtType(code, data)

    # Define a structure
    G = EcGroup()
    custom_obj = CustomClass()
    test_data = [G, G.generator(), G.order(), custom_obj]

    # Encode and decode custom structure
    packed = encode(test_data, enc_CustomClass)
    x = decode(packed, dec_CustomClass)
    assert x == test_data


def test_streaming():

    # Define a custom class, encoder and decoder
    class CustomClass2:
        def __eq__(self, other):
            return isinstance(other, CustomClass2)

    def enc_CustomClass(obj):
        if isinstance(obj, CustomClass2):
            return msgpack.ExtType(12, b'')
        raise TypeError("Unknown type: %r" % (obj,))

    def dec_CustomClass(code, data):
        if code == 12:
            return CustomClass2()

        return msgpack.ExtType(code, data)

    # Define a structure
    G = EcGroup()
    custom_obj = CustomClass2()
    test_data = [G, G.generator(), G.order(), custom_obj]
    packed1 = encode(test_data, enc_CustomClass)
    packed2 = encode(test_data, enc_CustomClass)

    data = packed1 + packed2

    decoder = make_decoder(dec_CustomClass)
    Up = msgpack.Unpacker(ext_hook=decoder)
    Up.feed(data)
    for o in Up:
        assert o == test_data


def test_docstring():
    # Define a custom class, encoder and decoder
    class CustomType:
        def __eq__(self, other):
            return isinstance(other, CustomType)

    def enc_custom(obj):
        return b''

    def dec_custom(data):
        return CustomType()

    _init_coders()
    register_coders(CustomType, 14, enc_custom, dec_custom)
    assert CustomType in _pack_reg

    # Define a structure
    G = EcGroup()
    custom_obj = CustomType()
    test_data = [G, G.generator(), G.order(), custom_obj]

    # Encode and decode custom structure
    packed = encode(test_data)
    x = decode(packed)
    assert x == test_data
    _init_coders()
