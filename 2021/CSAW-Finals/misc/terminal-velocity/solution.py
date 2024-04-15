import time

ESC = '\033'
CSI = ESC + '['

level0 = 'Level 0 Is Really Easy'
level0a = CSI + ">65;6402;1c" + CSI + '8;24;80t'
level1 = 'G1V3M3TH3N3XTL3V3L'
level1a = CSI + "2t"
level2 = 'HalfwayDone'
level3 = 'BobTheBuilder'
level4 = 'PINEY_FLATS_TN_USA'

from pwn import *

if len(sys.argv) > 1:
    host = sys.argv[1]
    port = sys.argv[2]
else:
    host = "localhost"
    port = 3535

print (f"Attempting expoit against {host}, {port}")
r = remote(host , port)


for send in [level0, level0a, "wait", " ", level1, " ", level1a, " ", level2, " ", level3, " ", " ", "wait", level4, " "]:
    r.recv(2**18)
    if send == "wait":
        time.sleep(5)
    else:
        r.sendline(bytes(send, 'utf8'))
        time.sleep(1)

r.recvuntil(b"flag")
print(r.recv(100))
