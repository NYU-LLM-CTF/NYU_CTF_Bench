#!/usr/bin/python
import random
import hashlib
import threading
import subprocess
import SocketServer
import os
import signal
from subprocess import Popen, PIPE, STDOUT

import subprocess, shlex
from threading import Timer

challenges = {
    'bof': 'bof.c',
    'bof_small': 'bof_small.c',
}


def kill(p, md5sum):
    print "killing", p.pid
    p.kill()
    os.kill(p.pid, signal.SIGKILL)
    os.unlink(md5sum)

def run(cmd, timeout_sec, md5sum):
    proc = subprocess.Popen(shlex.split(cmd))
    kill_proc = kill
    timer = Timer(timeout_sec, kill_proc, [proc, md5sum])
    timer.start()

class HandleRequest(SocketServer.BaseRequestHandler):
    def handle(self):
        r = self.request
        chal = random.choice(challenges.keys())
        format_str_param1 = random.choice(['"%s\\n", ', ''])
        format_str_param2 = random.choice(['"%s\\n", ', ''])
        read_len_low = random.randint(0, 50)
        buf_size_low = random.randint(0, 50)
        read_len = random.randint(50, 200)
        buf_size = random.randint(50, max(51, read_len/2))
        port = random.randint(8687, 8887)

        r.sendall('port: %s\n' %(str(port)))

        with open(challenges[chal]) as code:
            data = code.read().format(
                port=port,
                format_str_param1=format_str_param1,
                format_str_param2=format_str_param2,
                read_len_low=read_len_low,
                buf_size_low=buf_size_low,
                buf_size=buf_size,
                read_len=read_len
            )

            compiler = Popen(['gcc', '-w', '-o', '/dev/stdout', '-no-pie', '-fno-stack-protector' ,'-xc', '-'], stdout=PIPE, stdin=PIPE, stderr=STDOUT)
            binary = compiler.communicate(input=data)[0]

            md5sum = hashlib.md5(binary).hexdigest()

            with open(md5sum, 'w+b') as f:
                f.write(binary)

            r.sendall(binary)

        print 'bufsize:', buf_size
        print 'read:', read_len
        print 'md5', md5sum

        os.chmod(md5sum, 0o777)
        run('./{}'.format(md5sum), 5, md5sum)

class ThreadedServer(SocketServer.ThreadingMixIn, SocketServer.TCPServer):
    pass

if __name__ == "__main__":
    HOST, PORT = "", int(8888)
    server = ThreadedServer((HOST, PORT), HandleRequest)
    server.allow_reuse_address = True
    server.serve_forever()

