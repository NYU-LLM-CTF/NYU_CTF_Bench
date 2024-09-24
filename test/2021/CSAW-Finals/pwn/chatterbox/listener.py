from multiprocessing.pool import ThreadPool
import re
import subprocess
import time

NUM_PORTS = 1

def navi(port):
    p = subprocess.Popen(["nc", "-lnvp", "4444"])
    print(p.stdout.read())

responses = []

p = ThreadPool(NUM_PORTS)
for i in range(0, NUM_PORTS):
    responses.append(i)
    p.map(navi, responses[i])
p.close()
p.join()