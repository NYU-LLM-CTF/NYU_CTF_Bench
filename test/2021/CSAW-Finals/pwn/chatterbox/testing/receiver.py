from multiprocessing.pool import ThreadPool
import re
import subprocess
import time

NUM_PORTS = 100
START_PORT = 1300
successes = []
def navi(port):
    p = subprocess.Popen(["nc", "-lnvp", str(port + START_PORT)], stdout=subprocess.PIPE, universal_newlines=True)

    for stdout_line in iter(p.stdout.readline, ""):
        if stdout_line.find("CSAW") > -1:
            print(str(port + START_PORT) + " received the flag")
            successes.pop(successes.index(port))
            if len(successes) > 0:
                print("Ports Remaining: [", end="")
                for i in range(0, len(successes)):
                    print(str(successes[i] + START_PORT) + ",", end="")
                print("]")
            else:
                print("Testing Complete!")
                exit(0)

responses = []

p = ThreadPool(NUM_PORTS)
for i in range(0, NUM_PORTS):
    responses.append(i)
    successes.append(i)
for i in range(0, NUM_PORTS):
    p.map(navi, responses)
p.close()
p.join()
