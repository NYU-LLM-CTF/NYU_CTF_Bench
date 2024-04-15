#!/usr/bin/python3

import time
import subprocess

fds = [open('log/'+str(i), 'w') for i in range(16)]
p = [subprocess.Popen(['./p_remote.py', str(i), str(i+1)], stdout=fds[i]) for i in range(16)]

while None in map(lambda x: x.poll(), p):
    time.sleep(1)
