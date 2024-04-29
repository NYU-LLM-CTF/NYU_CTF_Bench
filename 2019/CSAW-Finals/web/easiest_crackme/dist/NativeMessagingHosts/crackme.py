import uuid
import string

from pprint import pprint
from types import SimpleNamespace

import logging

from pygdbmi.gdbcontroller import GdbController

def to_namespace(d):
    d = d.copy()
    for k,v in d.items():
        if type(v) == dict:
            d[k] = to_namespace(v)
    return SimpleNamespace(**d)

def filter_str(inp):
    alph = string.printable.split('\t')[0]
    return ''.join(filter(lambda x: x in alph, inp))

class CrackMe():
    def __init__(self, args=[]):
        self.uid = str(uuid.uuid4())
        # Start gdb process
        gdb_args = (['--nx', '--quiet', '--interpreter=mi2'] +
                    ['--args','./crackme'] +
                    args)

        self.gdbmi = GdbController(gdb_args=gdb_args)
        logging.info('Starting gdb with '+repr(self.gdbmi.get_subprocess_cmd()))

    def wait_for_resp(self):
        msgs = []
        out = {}

        while True:
            resp = self.gdbmi.get_gdb_response(
                    timeout_sec=4,
                    raise_error_on_timeout=False)
            msgs += resp

            for m in resp:
                m = to_namespace(m)
                if m.type != 'result':
                    continue
                out['result'] = m.message
                return msgs, out

    def run(self):
        self.gdbmi.write('run', read_response=False)
        return self.process_execution()

    def cont(self):
        self.gdbmi.write('continue', read_response=False)
        return self.process_execution()

    def si(self):
        self.gdbmi.write('si', read_response=False)
        return self.process_execution()

    def ni(self):
        self.gdbmi.write('ni', read_response=False)
        return self.process_execution()

    def breakpoint(self, addr):
        addr = filter_str(addr)
        self.gdbmi.write('break *'+addr, read_response=False)
        msgs, out = self.wait_for_resp()
        return out

    def set(self, arg):
        arg = filter_str(arg)
        self.gdbmi.write('set '+arg, read_response=False)
        msgs, out = self.wait_for_resp()
        return out

    def disassemble(self, arg):
        arg = filter_str(arg)
        self.gdbmi.write('disassemble '+arg, read_response=False)
        msgs, out = self.wait_for_resp()
        data = ''
        for m in msgs:
            m = to_namespace(m)
            if m.type == 'console':
                data += m.payload

        data = data.encode('latin-1').decode('unicode_escape')
        out['data'] = data
        return out
    
    def memory(self, arg):
        arg = filter_str(arg)
        self.gdbmi.write('x/'+arg, read_response=False)
        msgs, out = self.wait_for_resp()
        data = ''
        for m in msgs:
            m = to_namespace(m)
            if m.type == 'console':
                data += m.payload

        data = data.encode('latin-1').decode('unicode_escape')
        out['data'] = data
        return out

    def registers(self):
        self.gdbmi.write('i r', read_response=False)
        msgs, out = self.wait_for_resp()
        data = ''
        for m in msgs:
            m = to_namespace(m)
            if m.type == 'console':
                data += m.payload

        data = data.encode('latin-1').decode('unicode_escape')
        data = data.strip().split('\n')
        regs = {x[0]:x[1] for x in (y.split() for y in data) if len(x) >= 2}
        out['registers'] = regs
        return out


    def process_execution(self):

        run_output = ''
        running = True

        out = {}

        # Loop until execution stops
        while running:
            resp = self.gdbmi.get_gdb_response(
                    timeout_sec=4,
                    raise_error_on_timeout=False)

            for m in resp:
                m = to_namespace(m)

                # Console output
                if m.type == 'output':
                    run_output += m.payload

                if m.type == 'result' and m.message == 'error':
                    running = False
                    out['stop_reason'] = m.payload.msg

                # Program stopped
                if m.type == 'notify':
                    if m.message == 'stopped':
                        running = False
                        reason = m.payload.reason
                        out['stop_reason'] = reason
                        if reason == 'breakpoint-hit':
                            out['bp_addr'] = m.payload.frame.addr

        out['output'] = run_output

        return out


if __name__ == '__main__':
    p = CrackMe(['itszn'])
    pprint(p.breakpoint('main'))
    input()
    pprint(p.run())
    input()
    pprint(p.registers())
    input()
    pprint(p.memory('1s 0x555555554704'))
    input()
    pprint(p.disassemble('$rip'))
    input()
    pprint(p.cont())




