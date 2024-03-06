set_verbose(-2)
import binascii

print("")
print("**********   What's in a Groebner? **********\n")
print("Welcome agent! Polly Cracker's (plaintext) secret admin code contains the desired flag!")
print("We've been informed her code is just the summation of the plaintext codes belonging to her 3 henchmen")
print("     -- 'Homer', 'Morris' and 'Phisem'")
print("")
print("You are provided Homer, Morris, and Phisem's encrypted codes. Good Luck!")
print("")
print("**********************************************\n")

with open("./flag.txt", 'r') as f:
    flag = f.readline().strip().encode()

admin_code = int(binascii.hexlify(flag),16)

homer_pt_code  =  randint(admin_code//4, admin_code//3)
morris_pt_code =  randint(admin_code//4, admin_code//3)
phisem_pt_code =  admin_code - (homer_pt_code + morris_pt_code)


# (POLYNOMIAL RING OVER FINITE FIELD)
p_ = 83297968285319659068199479277537600821638173621636418555341
K = GF(p_)
R = PolynomialRing(K,2,'x',order='degrevlex')
R.inject_variables()

# (PUBLIC KEY)
MAX_ATTMPTS = 10


key_create_attmpt, pub_key = 0,0
while not pub_key and not key_create_attmpt > MAX_ATTMPTS:
    key_create_attmpt += 1
    k = R.random_element(degree=2)
    secret_ideal = Ideal(k)
    f = R.random_element(degree=2)
    pub_key  = f - f.reduce(secret_ideal)

if key_create_attmpt > MAX_ATTMPTS:
    print("Error creating pub key. Please retry")
    exit(1)

print("\nNO WAY YOU'RE GETTING THE SECRET, BUT MAYBE GROEBNER CAN HELP YOU? >", secret_ideal.groebner_basis())

# (RANDOM POLYNOMIALS FROM POLY RING R)
rand_poly_1 = R.random_element(degree=2)
rand_poly_2 = R.random_element(degree=2)
rand_poly_3 = R.random_element(degree=2)

# (ENCRYPT)
randI = randint(1,999999999999999999)


homer_enc_code = 999 * (homer_pt_code +  rand_poly_1 * pub_key) - randI
print("\nHOMER'S CIPHERTEXT >", homer_enc_code)

morris_enc_code = 999 * (morris_pt_code +  rand_poly_2 * pub_key) + randI
print("\nMORRIS'S CIPHERTEXT > ", morris_enc_code)

phisem_enc_code = 999 * (phisem_pt_code +  rand_poly_3 * pub_key) + 123
print("\nPHISEM'S CIPHERTEXT > ", phisem_enc_code)


print("\n\nCHECK PLAINTEXT ADMIN CODE: (should be a long int...)\n")

attmpt = 0
while (attmpt < MAX_ATTMPTS):
    attmpt +=1
    print("ENTER PLAINTEXT ADMIN CODE TO CHECK: ")
    try:
        cand = int(input().strip())
        if cand == admin_code:
            print("You got the code! Now decode for the flag and submit it!")
            print("decoded code format is: flag{....}")
            exit()
        else:
            print("TRY #:", attmpt, " Wrong flag: ", cand)
    except Exception as ex:
        print("\nSomething went wrong......try again?\n")
        exit(1)

exit()