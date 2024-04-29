#!/usr/bin/env python3

import os
import struct
import json
import sys

import logging
logging.basicConfig(filename='/tmp/host.log',level=logging.DEBUG)

from pygdbmi.gdbcontroller import GdbController
from pprint import pprint

from crackme import CrackMe


# Helper function that sends a message to the webapp.
def send_message(message):
    # Write message size.
    bmessage = message.encode('utf-8')
    size = struct.pack('I', len(bmessage))
    logging.info('Sending '+repr(list(map(hex,size))))
    sys.stdout.buffer.write(size)
    logging.info('Sending '+message)
    # Write the message itself.
    sys.stdout.buffer.write(bmessage)
    sys.stdout.flush()

instances = {}

def new_instance(msg):
    inst = CrackMe(msg['args'])
    instances[inst.uid] = inst
    return {'uid':inst.uid}

class MsgError(Exception):
    pass

def require(msg, **kargs):
    for k,v in kargs.items():
        if not k in msg:
            raise MsgError({'error':'Missing key %s'%(k)})
        if type(msg[k]) != v:
            raise MsgError({'error':'%s should be a %s'%(k,v)})

def inst(msg):
    require(msg,uid=str)

    inst_uid = msg['uid']
    if not inst_uid in instances:
        raise MsgError({'error':'No such instance'})

    return instances[inst_uid]

def rpc_process(msg):
    if msg['type'] == 'status':
        return {'rpc':True}

    if msg['type'] == 'new_instance':
        return new_instance(msg)

    if msg['type'] == 'run':
        return inst(msg).run()

    if msg['type'] == 'continue':
        return inst(msg).cont()

    if msg['type'] == 'si':
        return inst(msg).si()

    if msg['type'] == 'ni':
        return inst(msg).ni()

    if msg['type'] == 'breakpoint':
        require(msg, addr=str)
        return inst(msg).breakpoint(msg['addr'])

    if msg['type'] == 'memory':
        require(msg, arg=str)
        return inst(msg).memory(msg['arg'])

    if msg['type'] == 'registers':
        return inst(msg).registers()

    if msg['type'] == 'disassemble':
        require(msg, addr=str)
        return inst(msg).disassemble(msg['addr'])

    if msg['type'] == 'flavor':
        require(msg, flavor=str)
        return inst(msg).set(msg['flavor'])
    if msg['type'] == 'flavor':
        require(msg, flavor=str)
        return inst(msg).set(msg['flavor'])

    return None

def do_rpc(msg):
    try:
        resp = rpc_process(msg)
    except MsgError as e:
        resp = e.args[0]
    return resp

def wrap_msg(data, resp):
    if resp is None:
        return {'id': data.get('id',0)}
    else:
        resp['id'] = data.get('id',0)
    return resp

def read_loop():
    while 1:
        # Read the message length (first 4 bytes).
        text_length_bytes = sys.stdin.buffer.read(4)

        if len(text_length_bytes) == 0:
            break

        # Unpack message length as 4 byte integer.
        text_length = struct.unpack('i', text_length_bytes)[0]

        # Read the text (JSON object) of the message.
        text = sys.stdin.buffer.read(text_length).decode('utf-8')

        logging.info('got '+text)
        data = json.loads(text)

        resp = wrap_msg(data, do_rpc(data))

        send_message(json.dumps(resp))

def Main():
    logging.info('Starting in '+os.getcwd())
    try:
        read_loop()
    except Exception as e:
        logging.exception(str(e))


if __name__ == '__main__':
    Main()
