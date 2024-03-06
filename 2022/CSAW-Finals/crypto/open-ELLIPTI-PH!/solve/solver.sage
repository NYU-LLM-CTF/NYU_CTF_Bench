set_verbose(-2)

load('../src/mv_ecc.sage')

import os
import binascii
from subprocess import call
os.environ['PWNLIB_NOTERM'] = '1'
from pwn import *


# [CONNECT TO SERVER]
host = "crypto.chal.csaw.io"
port = 5005         # 6000
server = remote(host, port)


# [GET CIPHER_ENC]
server.recvuntil(":")
server.recvline()
cipher_enc = server.recvline().lstrip().decode()
print('\nCE:', cipher_enc)


# [GET CURVE PUB_KEY (or Q)]
server.recvuntil("!:")
server.recvline()
q_ = server.recvline().rstrip().lstrip().decode().replace(':', ',')
q_ = q_[1:len(q_)-1]
q = [int(x.lstrip().rstrip()) for x in q_.split(',')]
Q = E(q)                            # EXPRESS PUBKEY AS POINT ON CURVE


# [PERFORM POHLIG HELMAN ATTCK -- basically just try to break dlp]
# Used Pohlig-Hellman attk: [http://shrek.unideb.hu/~tengely/crypto/section-6.html#subsection-26]

def POHLIG_HELLMAN(P, Q):
    print(P.order().factor())
    facs,exps = zip(*factor(P.order()))
    print("FACS: ", facs)
    print("EXPS: ", exps)

    primes = [facs[i]^exps[i] for i in range(len(facs))]
    print("PRIMES:", primes)

    dlogs = []
    for fac in primes:
        t = ZZ(P.order())//ZZ(fac)
        dlog = discrete_log(t*Q,t*P,operation="+")
        dlogs += [dlog]
    n = crt(dlogs,primes)
    print(n)
    return n

kpri = POHLIG_HELLMAN(G,Q)          # GREAT NOW WE HAVE THE CURVE PRIVATE KEY


# [GET SSL SECRET KEY -- CURVE ENCRYPTED ]

server.recvuntil("':")
server.recvline()
mv_elgamel = server.recvline().strip().decode()
print("\nThis the the AES key, encrypted via ECC: ",  mv_elgamel)

match = re.search(r'rG=\(\d.*?,', mv_elgamel)
rG_ = match.group()[:-2]
rG_ = rG_[4:].replace(':', ',')
rG_ = [int(x.lstrip().rstrip()) for x in rG_.split(',')]
rG_ = E(rG_)                        # EXPRESS PUBKEY AS POINT ON CURVE

match = re.search(r'c1=\d.*', mv_elgamel[:-1])
cs = match.group().split(',')
c1_,c2_ = int(cs[0][3:]), int(cs[1][4:])

print(rG_, c1_, c2_)
mv_elgamel = MV_elgamel(rG=rG_, c1=c1_, c2=c2_)     # RE-CREATE  THE CURVE ENCRYPTION

secret_key64 = decrypt_mv_eg(kpri, mv_elgamel)      # PREFORM THE CURVE DECRYPTION SINCE WE HAVE THE ECC KEY
print("\nSECRET KEY IS: ", secret_key64)              # NOW WE HAVE THE AES KEY


# [USE OPENSSL TO GET FLAG FROM CIPHER_ENC]
f = open('cipher.enc', 'w')                         # WE CAN 'ECHO XXX | openssl' as well
f.write(cipher_enc)
f.close()

call(['openssl', 'enc',  '-aes256', '-base64', '-k', secret_key64, '-d', '-in', 'cipher.enc', '-md', 'sha512'])


server.close()