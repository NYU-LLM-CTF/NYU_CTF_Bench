#!/usr/bin/env python3
# coding: utf-8
# https://raw.githubusercontent.com/trichimtrich/turnproxy/master/turnproxy.py

import argparse

import asyncio
import os
import io
import socket

from struct import pack, unpack

import hmac
from hashlib import md5, sha1

import logging
from urllib.parse import urlparse


"""Utilities"""

# https://gist.github.com/sbz/1080258
def hexdump(src, length=16):
    FILTER = ''.join([(len(repr(chr(x))) == 3) and chr(x) or '.' for x in range(256)])
    if isinstance(src, str): src = src.encode('utf-8')
    lines = []
    for c in range(0, len(src), length):
        chars = src[c:c+length]
        hex = ' '.join(["%02x" % x for x in chars])
        printable = ''.join(["%s" % ((x <= 127 and FILTER[x]) or '.') for x in chars])
        lines.append("%08x: %-*s  %s" % (c, length*3, hex, printable))
    return '\n'.join(lines)


def get_ip4_port(addr_str):
    result = urlparse(addr_str)
    p = result.netloc if result.netloc else result.path
    if '/' in p or p.count(':') > 1:
        raise Exception('Invalid address')
    ps = p.split(':')
    host = ps[0]
    if len(ps) > 1:
        if not ps[1].isdigit():
            raise Exception('Invalid address')
        port = int(ps[1])
    else:
        port = 3478 # default turn
    # resolve
    ip = socket.gethostbyname(host)
    return ip, port


"""Turn TCP Client Implementation"""

TURN_MAGIC_COOKIE = 0x2112A442
TURN_MAGIC_XOR = b'\x00\x00\x21\x12\x21\x12\xa4\x42'
TURN_CHANNEL = 0x40020000

TURN_PROTOCOL_TCP = 0x06000000
TURN_RPOTOCOL_UDP = 0x11000000


def _get_const_name(cls, val, type_: type) -> str:
    for attr_name in dir(cls):
        attr = getattr(cls, attr_name)
        if isinstance(attr, type_) and attr == val:
            return attr_name
    return ''


class TurnMessageMethod:
    Reversed            = 0x0000 # RFC5389
    Binding             = 0x0001
    SharedSecret        = 0x0002 # Reserved - RFC5389

    # https://tools.ietf.org/html/rfc5766#section-13
    Allocate            = 0x0003
    Refresh             = 0x0004
    Send                = 0x0006
    Data                = 0x0006
    CreatePermission    = 0x0008
    ChannelBind         = 0x0009

    # https://tools.ietf.org/html/rfc6062#section-6.1
    Connect             = 0x000a # RFC6062
    ConnectionBind      = 0x000b # RFC6062
    ConnectionAttempt   = 0x000c # RFC6062

    get = classmethod(lambda cls, val, type_=int: _get_const_name(cls, val, type_))


class TurnMessageCode:
    Request     = 0x0000
    Indication  = 0x0010
    SuccessResp = 0x0100
    ErrorResp   = 0x0110

    get = classmethod(lambda cls, val, type_=int: _get_const_name(cls, val, type_))


class TurnAttribute:
    Reserved            = 0x0000 # RFC5389
    MappedAddress       = 0x0001 # RFC5389
    ResponseAddress     = 0x0002 # Reserved - RFC5389
    ChangeRequest       = 0x0003 # Reserved - RFC5389
    SourceAddress       = 0x0004 # Reserved - RFC5389
    ChangedAddress      = 0x0005 # Reserved - RFC5389
    Username            = 0x0006 # RFC5389
    Password            = 0x0007 # Reserved - RFC5389
    MessageIntegrity    = 0x0008 # RFC5389
    ErrorCode           = 0x0009 # RFC5389
    UnknownAttribute    = 0x000A # RFC5389
    ReflectedFrom       = 0x000B # Reserved - RFC5389

    ChannelNumber       = 0x000C # RFC5766
    Lifetime            = 0x000D # RFC5766
    Bandwidth           = 0x0010 # Reserved - RFC5766
    XorPeerAddress      = 0x0012 # RFC5766
    Data                = 0x0013 # RFC5766

    Realm               = 0x0014 # RFC5389
    Nonce               = 0x0015 # RFC5389

    XorRelayedAddress   = 0x0016 # RFC5766
    EvenPort            = 0x0018 # RFC5766
    RequestedTransport  = 0x0019 # RFC5766
    DontFragment        = 0x001A # RFC5766

    XorMappedAddress    = 0x0020 # RFC5389

    TimerVal            = 0x0021 # Reserved - RFC5766
    ReservationToken    = 0x0022 # RFC5766

    ConnectionID        = 0x002a # RFC6062

    XorMappedAddressX   = 0x8020
    Software            = 0x8022 # RFC5389
    AlternateServer     = 0x8023 # RFC5389
    Fingerprint         = 0x8028 # RFC5389
    UnknownAddress2     = 0x802b
    UnknownAddress3     = 0x802c

    get = classmethod(lambda cls, val, type_=int: _get_const_name(cls, val, type_))


class Address4:
    def __init__(self, **kargs):
        self.family = 1 # ipv4
        self.ip = None # type: str
        self.port = None # type: int
        for k, v in kargs.items():
            setattr(self, k, v)

    def _xor_cookie(self, a):
        b = TURN_MAGIC_XOR
        r = bytearray()
        for i in range(max(len(a), len(b))):
            r.append(a[i % len(a)] ^ b[i % len(b)])
        return bytes(r)

    def encode(self, xor: bool = True) -> bytes:
        data = pack('!H', self.family)
        data += pack('!H', self.port)
        data += socket.inet_pton(socket.AF_INET, self.ip)
        if xor: data = self._xor_cookie(data)
        return data

    def decode(self, data: bytes, xor: bool = True):
        if xor: data = self._xor_cookie(data)
        b2 = io.BytesIO(data)
        family = unpack('!H', b2.read(2))[0]
        port = unpack('!H', b2.read(2))[0]
        ip = socket.inet_ntop(socket.AF_INET, b2.read(4))
        self.family = family
        self.ip = ip
        self.port = port

    @classmethod
    def pack(cls, ip: str, port: int, xor=True) -> bytes:
        inst = cls(ip=ip, port=port)
        return inst.encode(xor)

    @classmethod
    def unpack(cls, data: bytes, xor: bool = True):
        inst = cls()
        inst.decode(data, xor)
        return inst

    def __str__(self):
        return '{}:{}'.format(self.ip, self.port)


class TurnMessage:
    def __init__(self, **kargs):
        self.msg_type = None # type: int
        self.msg_len = 0 # type: int
        self.magic_cookie = TURN_MAGIC_COOKIE
        self.txn_id = os.urandom(12) # type: bytes
        self.msg = io.BytesIO()
        self.attr_cursor = 0 # type: int
        for k, v in kargs.items():
            setattr(self, k, v)


    def reset_attr(self):
        self.msg_len = 0
        self.msg = io.BytesIO()


    def write_attr(self, attr: int, *data, fmt: str = None):
        # process data -> bytes
        if fmt:
            data = pack(fmt, *data)
        else:
            data = data[0]
            if isinstance(data, Address4):
                data = data.encode()

        msg = pack('!HH', attr, len(data))

        # Rule of 4:
        # https://tools.ietf.org/html/rfc5766#section-14
        if len(data) % 4 != 0:
            data += b'\x00' * (4 - len(data) % 4)

        msg += data
        self.msg_len += len(msg)

        # seek to end
        self.msg.seek(0, io.SEEK_END)
        self.msg.write(msg)


    def write_credential(self, username: str, realm: str, nonce: bytes = b''):
        self.write_attr(TurnAttribute.Username, username)
        self.write_attr(TurnAttribute.Realm, realm)
        self.write_attr(TurnAttribute.Nonce, nonce)


    def _hmac(self, key: bytes, msg: bytes) -> bytes:
        hashed = hmac.new(key, msg, sha1)
        return hashed.digest()


    def write_hmac(self, key: bytes):
        self.msg_len += 24
        msg_hmac = self.encode()
        self.msg_len -= 24
        self.write_attr(TurnAttribute.MessageIntegrity, self._hmac(key, msg_hmac))


    def eof(self) -> bool:
        return self.msg.tell() >= self.msg_len


    def read_attr(self) -> tuple:
        # seek to current attr cursor
        b = self.msg
        b.seek(self.attr_cursor, io.SEEK_SET)

        m_attr = unpack('!H', b.read(2))[0]
        m_len = unpack('!H', b.read(2))[0]
        m_data = b.read(m_len)

        # Rule of block 4:
        # https://tools.ietf.org/html/rfc5766#section-14
        if m_len % 4 != 0:
            b.read(4 - m_len % 4)

        # new cursor
        self.attr_cursor = b.tell()

        return m_attr, m_len, m_data


    def encode(self) -> bytes:
        m = pack('!HHI', self.msg_type, self.msg_len, self.magic_cookie)
        m += self.txn_id

        # seek to start
        self.msg.seek(0, io.SEEK_SET)
        m += self.msg.read()
        return m


    def decode(self, msg: bytes) -> bytes:
        b =  io.BytesIO(msg)
        self.msg_type, self.msg_len, self.magic_cookie = unpack('!HHI', b.read(8))
        self.txn_id = b.read(12)
        self.msg = io.BytesIO(b.read(self.msg_len))
        self.attr_cursor = 0

        # ret data left in buffer, usually NULL
        return b.read()


    @classmethod
    def pack(cls, msg_type: int, msg: bytes) -> bytes:
        inst = cls(msg_type=msg_type, msg=msg, msg_len=len(msg))
        return inst.encode()

    @classmethod
    def unpack(cls, msg: bytes) -> tuple:
        inst = cls()
        buf = inst.decode(msg)
        return inst, buf


class TurnClient(asyncio.Protocol):
    def __init__(
        self,
        is_control: bool,
        is_test: bool = False, # run in test mode

        # configs for control connection
        username: bytes = None, # turn username
        password: bytes = None, # turn password
        peer_host: str = None, # ipv4
        peer_port: int = None,
        socks_in = None, # run in socks mode

        # configs for data connection
        control_conn=None, # control connection instance
    ):
        self.is_control = is_control
        self.is_test = is_test

        if is_control:
            # control connection
            self.username = username
            self.password = password
            self.peer_host = peer_host
            self.peer_port = peer_port

            self.socks_in = socks_in

            self.realm = None
            self.key = None
            self.nonce = None
            self.connection_id = None

            self.data_conn = None
        else:
            # data connection
            # control_conn must be control connection instance and allocated tcp alr
            self.control_conn = control_conn
            self.socks_in = control_conn.socks_in

            self.username = control_conn.username
            self.realm = control_conn.realm
            self.key = control_conn.key
            self.nonce = control_conn.nonce
            self.connection_id = control_conn.connection_id

            self.is_data = False


    def connection_lost(self, exc):
        if self.is_control:
            if not self.is_test:
                # close data connection + socks
                if self.data_conn:
                    self.data_conn.transport.close()
                self.socks_in.transport.close()
        else:
            # data client disconnected, only need to close control client
            self.control_conn.data_conn = None
            self.control_conn.transport.close()

        super().connection_lost(exc)


    def send_msg(self, msg: TurnMessage, do_sign=False):
        if do_sign and self.key:
            msg.write_credential(self.username, self.realm, self.nonce)
            msg.write_hmac(self.key)

        m = msg.encode()

        if self.is_test:
            logging.debug('[SEND] - {}'.format(TurnMessageMethod.get(msg.msg_type)))
            logging.debug(hexdump(m))
            logging.debug('')
        else:
            logging.debug('{} - Turn>Send - {}'.format(
                self.socks_in.peer_str,
                TurnMessageMethod.get(msg.msg_type)
            ))

        self.transport.write(m)


    def connection_made(self, transport):
        self.transport = transport
        self.turn_host, self.turn_port = transport.get_extra_info('peername')

        if self.is_control:
            # first init for control connection

            # expect 'Unauthorized'
            self.expect_alloc_fail = True

            # send alloc-tcp without credential + nonce + message digest
            msg = TurnMessage(msg_type=TurnMessageMethod.Allocate)
            msg.write_attr(TurnAttribute.RequestedTransport, TURN_PROTOCOL_TCP, fmt='!I')
            self.send_msg(msg)
        else:
            self.control_conn.data_conn = self

            # first init for data connection
            # send connection id and data
            msg = TurnMessage(msg_type=TurnMessageMethod.ConnectionBind)
            msg.write_attr(TurnAttribute.ConnectionID, self.connection_id)
            self.send_msg(msg, do_sign=True)


    def _kill_socks(self):
        # If in Socks mode, reply 'General failure' to Socks client
        if not self.is_test:
            self.socks_in.transport.write(b'\x05\x01\x00\x01\x7f\x00\x00\x01\x80\x80')
            self.transport.close()
        else:
            loop = asyncio.get_event_loop()
            loop.stop()


    def data_received(self, data):
        if not self.is_control and self.is_data:
            self.socks_in.write(data)
            return

        """Parse data"""

        msg, _ = TurnMessage.unpack(data)

        m_method = msg.msg_type & 0xf
        m_code = msg.msg_type & 0x110

        if self.is_test:
            logging.debug('[RECV] - {} - {}'.format(
                TurnMessageMethod.get(m_method),
                TurnMessageCode.get(m_code)
            ))
            logging.debug(hexdump(data))
        else:
            logging.debug('{} - Turn<Recv - {} - {}'.format(
                self.socks_in.peer_str,
                TurnMessageMethod.get(m_method),
                TurnMessageCode.get(m_code)
            ))

        error_code = 0
        error_msg = b''


        while not msg.eof():
            attr_code, _, attr_data = msg.read_attr()

            attr_name = TurnAttribute.get(attr_code)

            logging.debug('> {} : {}'.format(attr_name, hex(attr_code)))
            logging.debug(hexdump(attr_data))

            if 'Address' in attr_name:
                # address attribute
                # addr = Address4.unpack(attr_data, attr_name.startswith('Xor'))
                # print(addr)
                pass

            elif attr_code == TurnAttribute.Realm:
                self.realm = attr_data
                self.key = md5(self.username + b':' + self.realm + b':' + self.password).digest()
            elif attr_code == TurnAttribute.Nonce:
                self.nonce = attr_data
            elif attr_code == TurnAttribute.ErrorCode:
                b2 = io.BytesIO(attr_data)
                d = b2.read(4)
                error_code = (d[2] & 0x7) * 100 + d[3]
                error_msg = b2.read()
            elif attr_code == TurnAttribute.ConnectionID:
                self.connection_id = attr_data

        logging.debug('')

        """Handlers"""

        # of control connection
        if m_method == TurnMessageMethod.Allocate:
            if m_code == TurnMessageCode.ErrorResp:
                if self.expect_alloc_fail:
                    # expect this error
                    self.expect_alloc_fail = False

                    # got nonce session => alloc-tcp again with valid credential
                    msg = TurnMessage(msg_type=TurnMessageMethod.Allocate)
                    msg.write_attr(TurnAttribute.RequestedTransport, TURN_PROTOCOL_TCP, fmt='!I')
                    self.send_msg(msg, do_sign=True)
                else:
                    # unexpected, print error and close socks client if connected
                    logging.error('Error {}: {}'.format(error_code, error_msg))
                    self._kill_socks()

            elif m_code == TurnMessageCode.SuccessResp:
                # tcp allocated, request turn server connects to peer
                msg = TurnMessage(msg_type=TurnMessageMethod.Connect)
                msg.write_attr(TurnAttribute.XorPeerAddress, Address4(ip=self.peer_host, port=self.peer_port))
                self.send_msg(msg, do_sign=True)

        elif m_method == TurnMessageMethod.Connect:
            if m_code == TurnMessageCode.SuccessResp:
                # turn server successfully connected to peer

                if self.is_test:
                    # in test mode, we just de-allocation and terminate connection
                    logging.info('Connection OK')
                    # TODO: remove allocation
                    loop = asyncio.get_event_loop()
                    loop.stop()
                    # self.transport.close()


                else:
                    # in socks mode,
                    # spawn another turn client as data connection
                    loop = asyncio.get_event_loop()
                    client = loop.create_connection(
                        lambda: TurnClient(
                            is_control=False,
                            control_conn=self,
                        ),
                        host=self.turn_host,
                        port=self.turn_port,
                    )
                    asyncio.ensure_future(client)
                    # TODO: maintain tcp alloc by refresh message

            elif m_code == TurnMessageCode.ErrorResp:
                # must be connection refused / or forbiden
                logging.error('Error {}: {}'.format(error_code, error_msg))
                self._kill_socks()


        # of data connection
        elif m_method == TurnMessageMethod.ConnectionBind:
            if m_code == TurnMessageCode.SuccessResp:
                # data connection - bind success
                # reply socks
                peer_host = self.control_conn.peer_host
                peer_port = self.control_conn.peer_port

                nw = socket.inet_aton(peer_host) + pack('!H', peer_port)
                self.socks_in.conn_out = self
                self.socks_in.transport.write(b'\x05\x00\x00\x01' + nw)
                logging.info('{} - SOCKS established'.format(self.socks_in.peer_str))

                # transfering raw data from now on
                self.is_data = True
            elif m_code == TurnMessageCode.ErrorResp:
                # why? unexpected
                logging.error('Error {}: {}'.format(error_code, error_msg))
                self._kill_socks()

        else:
            # others error
            if m_code == TurnMessageCode.ErrorResp:
                logging.error('Error {}: {}'.format(error_code, error_msg))
                self._kill_socks()



    def write(self, data):
        self.transport.write(data)


"""Partial SOCKS Server Implementation"""

class SocksIn(asyncio.Protocol):
    def __init__(self, turn_host, turn_port, username, password):
        self.turn_host = turn_host
        self.turn_port = turn_port
        self.username = username
        self.password = password

        self.state = 0 # init
        self.buf = b''


    def connection_made(self, transport):
        self.transport = transport
        self.conn_out = None
        peer = transport.get_extra_info('peername')
        self.peer_str = '{}:{}'.format(*peer)
        logging.info('{} - Connected'.format(self.peer_str))


    def data_received(self, data):
        if self.conn_out:
            self.conn_out.write(data)
            return

        self.buf += data
        if self.state == 0: # init
            b = io.BytesIO(self.buf)
            v, n_method = unpack('!BB', b.read(2))
            if v == 5 and n_method:
                methods = b.read(n_method)
                if 0 in methods: # no authen
                    self.buf = b.read() # reset buffer
                    self.transport.write(b'\x05\x00')
                    self.state = 1 # request
                else:
                    self._die('Error: invalid auth methods')
            else:
                self._die('Error: version or num auth method')
        elif self.state == 1: # request
            b = io.BytesIO(self.buf)
            v, cmd, _, atyp = unpack('!4B', b.read(4))
            if v == 5 and cmd == 1 and atyp in (1, 3): # connect + ipv4/domain
                if atyp == 1: # ipv4
                    host = socket.inet_ntoa(b.read(4))
                elif atyp == 3: # domain
                    host_len = b.read(1)[0]
                    host = b.read(host_len)
                port = unpack('!H', b.read(2))[0]
                self.buf = b.read()
                self.state = 3 # connecting

                asyncio.ensure_future(self._connector(atyp, host, port))
            else:
                self._die('Error: version or unsupported command or address type')


    async def _connector(self, atyp, host, port):
        loop = asyncio.get_event_loop()
        if atyp == 3:
            addrs = await loop.getaddrinfo(host, port, family=socket.AF_INET)
            try:
                if not len(addrs): # cant resolve
                    raise Exception()
                addr = addrs[0]
                if addr[0] != socket.AF_INET:
                    raise Exception()
                host = addrs[0][4][0] # put in try for unknown error
            except:
                self._die('Error: hostname invalid')
                return

        self.state = 4 # done
        # create turn client - control connection
        loop = asyncio.get_event_loop()
        client = loop.create_connection(
            lambda: TurnClient(
                is_control=True,
                username=self.username,
                password=self.password,
                socks_in=self,
                peer_host=host,
                peer_port=port,
            ),
            host=self.turn_host,
            port=self.turn_port,
        )
        asyncio.ensure_future(client)


    def _die(self, msg):
        self.state = -1 # die
        if msg:
            logging.error('{} - {}'.format(self.peer_str, msg))
        self.transport.close()


    def connection_lost(self, exc):
        logging.info('{} - Client disconnected'.format(self.peer_str))
        if self.conn_out:
            self.conn_out.transport.close()

        super().connection_lost(exc)


    def write(self, data):
        self.transport.write(data)


"""CLI"""

def cli_test(args):
    logging.basicConfig(format='%(message)s', level=logging.DEBUG if args.debug else logging.INFO)

    turn_host, turn_port = get_ip4_port(args.turn)
    peer_host, peer_port = get_ip4_port(args.connect)
    username = args.user.encode('utf-8')
    password = args.password.encode('utf-8')

    logging.info('Turn server == {}:{}'.format(turn_host, turn_port))
    logging.info('Connecting to peer --> {}:{}'.format(peer_host, peer_port))

    loop = asyncio.get_event_loop()
    loop.set_debug(args.debug)
    coro = loop.create_connection(
        lambda: TurnClient(
            is_control=True,
            username=username,
            password=password,
            peer_host=peer_host,
            peer_port=peer_port,
            is_test=True,
        ),
        host=turn_host,
        port=turn_port,
    )
    transport, _ = loop.run_until_complete(coro)

    try:
        loop.run_forever()
    except KeyboardInterrupt:
        pass
    transport.close()
    loop.close()


def cli_run(args):
    logging.basicConfig(format='%(message)s', level=logging.DEBUG if args.debug else logging.INFO)

    turn_host, turn_port = get_ip4_port(args.turn)
    socks_host, socks_port = get_ip4_port(args.socks)
    username = args.user.encode('utf-8')
    password = args.password.encode('utf-8')

    logging.info('Turn server == {}:{}'.format(turn_host, turn_port))
    logging.info('Socks server listening <-- {}:{}'.format(socks_host, socks_port))

    loop = asyncio.get_event_loop()
    loop.set_debug(args.debug)
    coro = loop.create_server(
        lambda: SocksIn(
            turn_host,
            turn_port,
            username,
            password,
        ),
        host=socks_host,
        port=socks_port,
    )
    server = loop.run_until_complete(coro)

    try:
        loop.run_forever()
    except KeyboardInterrupt:
        pass

    server.close()


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='test your turn-server tcp relay and use it as a proxy with socks interface', usage='turnproxy command')
    parser.set_defaults(func=lambda args: parser.print_help())

    subparsers = parser.add_subparsers(title='command', metavar='')
    desc = 'ask turn server to create a tcp connection to your peer host'
    parser_test = subparsers.add_parser('test', description=desc, help=desc, prog='turnproxy test')
    parser_test.add_argument('-d', '--debug', action='store_true', help='enable debug log')
    parser_test.add_argument('-t', '--turn', type=str, help='turn server address and port', required=True)
    parser_test.add_argument('-u', '--user', type=str, help='auth username', required=True)
    parser_test.add_argument('-p', '--password', type=str, help='auth password', required=True)
    parser_test.add_argument('-c', '--connect', type=str, help='peer ip address (default: %(default)s)', default='8.8.8.8:53')
    parser_test.set_defaults(func=cli_test)

    desc = 'run a socks proxy via your turn server'
    parser_run = subparsers.add_parser('run', description=desc, help=desc, prog='turnproxy run')
    parser_run.add_argument('-d', '--debug', action='store_true', help='enable debug log')
    parser_run.add_argument('-t', '--turn', type=str, help='turn server address and port', required=True)
    parser_run.add_argument('-u', '--user', type=str, help='auth username', required=True)
    parser_run.add_argument('-p', '--password', type=str, help='auth password', required=True)
    parser_run.add_argument('-s', '--socks', type=str, help='socks listen address (default: %(default)s)', default='127.0.0.1:8080')
    parser_run.set_defaults(func=cli_run)

    args = parser.parse_args()
    args.func(args)


## Notes:
# Keep loop running
# https://stackoverflow.com/questions/51079150/understanding-python-asyncio-protocol

# Task was destroyed but it is pending!
# https://stackoverflow.com/questions/40897428/please-explain-task-was-destroyed-but-it-is-pending
