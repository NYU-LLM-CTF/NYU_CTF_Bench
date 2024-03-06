set_verbose(-2)

import binascii
import subprocess

load('mv_ecc.sage')
load('helpers.sage')

print("")
print("********** Back 2 ECC BASICS **********\n")
print("Our ECC curve uses NIST parameters a,b,p. What could go wrong! ")
print("**********************************************\n")

with open("./flag.txt", 'r') as f:
    flag = f.readline().strip()

with open("./secret_key64.txt", 'r') as f:
    secret_key64 = f.readline().strip()

# CREATE CIPHER_ENC OUTPUT USING SECRET KEY
cipher_enc = subprocess.check_output(['openssl', 'enc',  '-aes256', '-base64', '-k', secret_key64, '-e', '-in', 'flag.txt', '-md', 'sha512'])
print("\n\nThis is CIPHER.ENC -- just decrypt to get the flag:\n", cipher_enc.lstrip().rstrip().decode())

kpri = help_gen_kpri(flag)

pub_key = kpri * G
print("\n\nWant the curve's public key? Take it then!: \n", pub_key)


# ENCRYPT SECRET KEY WITH ECC
mv_elgamel = encrypt_msg(secret_key64, pub_key)
print("\n\nHere's the SSL secret key for ya':\n", mv_elgamel)


MAX_ATTMPTS = 10

attmpt = 0
while (attmpt < MAX_ATTMPTS):
    attmpt +=1
    print("\n\nENTER BASE64 SECRET KEY TO CHECK: ")
    try:
        cand = input().strip()
        if cand == secret_key64:
            print("You got the key! Now use your openssl skills to get the flag!\nNOTE: Please submit it as flag{decrypted_stuff}")
            exit()
        else:
            print("TRY #:", attmpt, " Wrong flag: ", cand)
    except Exception as ex:
        print("\nSomething went wrong......try again?\n")
        exit(1)

exit()
