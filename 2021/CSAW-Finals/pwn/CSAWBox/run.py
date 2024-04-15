from multiprocessing.pool import ThreadPool
import re
import subprocess
import time

start = time.time()


# run a single execution of "exp.py"
def run_exp(_):
    #print(f"[-] Starting attempt at {time.strftime('%H:%M:%S', time.gmtime())}")
    output = subprocess.check_output(["python3", "threaded_exp.py"])

    if b"flag" in output:
        elapsed = time.time() - start
        mins = int(elapsed // 60)
        secs = int(elapsed % 60)

        flag = re.search("flag{.*}", output.decode()).group()
        print(f"[+] Found in {mins}m{secs}s: {flag}")

p = ThreadPool(10) # max number of concurrent connections from single IP is 10
p.map(run_exp, range(10000))
p.close()
p.join()
