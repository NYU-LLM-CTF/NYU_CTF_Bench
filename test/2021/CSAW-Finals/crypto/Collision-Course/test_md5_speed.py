import hashlib
import time
import math

iterations = 10000000

print(f'[*] Running hash test of {iterations:,} iterations')

starttime = time.perf_counter()
for i in range(iterations):
    s = str(i).encode()
    hashlib.md5(s).hexdigest()
endtime = time.perf_counter()

runtime_s = (endtime - starttime)

print (f'[*] Runtime of {runtime_s} seconds')
rate = math.floor((iterations/runtime_s)/1000)
print (f'[*] Estimated speed of {rate:,} Kmd5/s')
