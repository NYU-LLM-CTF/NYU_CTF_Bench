import logging
from enum import Enum
from os import urandom

import construct as c
from sqlalchemy import Column, Date, Integer, SmallInteger
from sqlalchemy.ext.declarative import declarative_base

BUFSIZE = 4096
CERTFILE = 'cert.pem'
KEYFILE = 'cert.key'

CREDS = (
    ['admin', 'admin'],
    ['betsy', 'hunter2'],
    ['charles', 'Passw0rd!'],
    ['denny', 'hee8Eegu'],
    ['elen', '12345'],
    ['francine', '*g_^w+F14B",56N7'],
)

log = logging.getLogger(__name__)
log.setLevel(logging.DEBUG)

Base = declarative_base()


class ListType(object):
    @staticmethod
    def parse(data):
        contents = list()
        marker = data.index(0)
        i = marker + 1
        for l in c.GreedyRange(c.VarInt).parse(data[:marker]):
            contents.append(deserialize(data[i : i + l]))
            i += l
        return contents

    @staticmethod
    def build(contents):
        sc = list(map(serialize, contents))
        data = (
            c.GreedyRange(c.VarInt).build(list(map(len, sc)))
            + b'\x00'
            + b''.join(sc)
        )
        return data


class Pixel(Base):
    __tablename__ = 'pixels'
    x = Column(SmallInteger, primary_key=True)
    y = Column(SmallInteger, primary_key=True)
    r = Column(SmallInteger)
    g = Column(SmallInteger)
    b = Column(SmallInteger)


CONTENT_TYPES = (
    (0x20, str, c.PascalString(c.Int16ub, "utf8")),
    (0x0a, bool, c.Flag),
    (0x30, int, c.VarInt),
    (0x00, list, ListType),
    (0x01, tuple, ListType),
    (0xca, type(None), c.Pass),
    (0xaa, Pixel, c.Array(3, c.VarInt)),
)
DESERIALIZATION_TYPES = {k: v for (k, _, v) in CONTENT_TYPES}
SERIALIZATION_TYPES = {k: (v1, v2) for (v1, k, v2) in CONTENT_TYPES}


def serialize(contents):
    type_flag, builder = SERIALIZATION_TYPES[type(contents)]
    return bytes([type_flag]) + builder.build(contents)


def deserialize(data):
    log.debug(f'deserializing {data}')
    return DESERIALIZATION_TYPES[data[0]].parse(data[1:])


class Message(object):
    def __init__(self, type_, contents=None):
        self.type = MessageType(type_)
        self.contents = contents

    @staticmethod
    def recv(sock, type_check=None):
        data = b''
        while len(data) <= 8 or data[:4] != data[-1:-5:-1]:
            rec = sock.recv(BUFSIZE)
            if not rec:
                raise ConnectionError('empty recv')
            data += rec
            # log.debug(f'received total: {data}')
        type_ = MessageType(data[4])
        if type_check is not None and type_check != type_:
            raise TypeError(f'type {type_} is not expected type {type_check}')
        log.debug(f'received contents: {deserialize(data[5:-4])}')
        return Message(type_, deserialize(data[5:-4]))

    def send(self, sock):
        canary = urandom(4)
        msg = canary + self.serialized + canary[::-1]
        # log.debug(f'sending "{msg}"')
        sock.send(msg)

    @property
    def serialized(self):
        log.debug(f'serializing "{self.contents}"')
        return bytes([self.type.value]) + serialize(self.contents)


class MessageType(Enum):
    ERROR = 0xee
    FLAG = ord('f')
    GETPIXEL = 0x10
    GOODBYE = 0xbb
    HELLO = 0x41
    LOGIN = 0x20
    PIXEL = 0x00
    SETPIXEL = 0x78
    SUCCESS = 0x0a
