import random
import sys
from collections import namedtuple

from Crypto.Util.number import getPrime, bytes_to_long

with open("flag.txt", 'r') as f:
    flag = f.read()

with open("password.txt", 'r') as p:
    password = p.read().strip()

p_set = [getPrime(512) for _ in range(0, 10)]
q_set = [getPrime(512) for _ in range(0, 10)]
RSA = namedtuple("RSA", ' p q N d e phi')


# Not susceptible to Wiener attack since it is public exponent that is reduced, not exponent
def rsa_generator():
    random_index = random.randrange(len(p_set))
    while True:
        try:
            p, q = p_set[random_index], q_set[random_index]
            phi = (p - 1) * (q - 1)
            N = p * q
            # e < sqrt(N) for attack to work,
            # but ok to use Weiner formuation to reduce space even more
            e = random.randint(2, pow(phi, 1 / 4) // 3)
            d = pow(e, -1, phi)
            break
        except:
            continue
    return RSA(p, q, N, d, e, phi)


def common_attack():
    m_bytes = bytes(password, 'utf-8')
    m = bytes_to_long(m_bytes)
    rsa = rsa_generator()
    #print(rsa)
    print("N =", rsa.N)
    print("e =", rsa.e)
    print("c =", pow(m, rsa.e, rsa.N))

def challenge_common():
    print("**********   TOO MUCH IN COMMON      **********\n")
    print("   Have at it!\n")

    while True:
        print("/------------------------------\\")
        print("|           COMMANDS              |")
        print("|                                 |")
        print("|   1) ciphertext_info            |")
        print("|   2) solve_challenge <password> |")
        print("|   3) exit                       |")
        print("\\------------------------------/\n")
        print("> ", end="")
        sys.stdout.flush()
        parts = sys.stdin.readline()[:-1].split(" ")

        try:
            if parts[0] == "ciphertext_info" or parts[0] == "1":
                common_attack()
                print("> ", end="")
                sys.stdout.flush()
            elif parts[0] == "solve_challenge" or parts[0] == "2":
                candidate_password = parts[1]
                if candidate_password == password:
                    break
                else:
                    print("\nNope!\n")
            elif parts[0] == "exit" or parts[0] == "3":
                print("\nBye!")
                sys.stdout.flush()
                exit(0)
            else:
                print("\nUnknown command.")
                raise Exception()
        except:
            print("\nSomething went wrong...")
            print("...try again?\n")
            sys.stdout.flush()

def challenge_phi():
    print("\n********** What the Phi?  **********\n")
    print("Give me phi and I'll give you a flag\n")

    new_rsa = rsa_generator()
    print("\nN =", new_rsa.N)
    print("\ne =", new_rsa.e)
    print("\nd =", new_rsa.d)

    while True:
        print("/------------------------------\\")
        print("|           COMMANDS              |")
        print("|                                 |")
        print("|   1) try_again                  |")
        print("|   2) phi <phi_value>            |")
        print("|   3) exit                       |")
        print("\\------------------------------/\n")
        print("> ", end="")
        sys.stdout.flush()
        parts = sys.stdin.readline()[:-1].split(" ")

        try:
            if parts[0] == "try_again" or parts[0] == "1":
                new_rsa = rsa_generator()
                print("\nN =", new_rsa.N)
                print("\ne =", new_rsa.e)
                print("\nd =", new_rsa.d)
            elif parts[0] == "phi" or parts[0] == "2":
                cand_phi = int(parts[1])
                if cand_phi - new_rsa.phi == 0 :
                    print("\nWhat?! How did you do that??\n")
                    with open("flag.txt") as file:
                        print("".join(file.readlines()))
                    break
                else:
                    print("\nNope!\n")
            elif parts[0] == "exit" or parts[0] == "3":
                print("\nBye!")
                exit(0)
            else:
                print("\nUnknown command.")
                raise Exception()
        except:
            print("\nSomething went wrong...")
            print("...try again?\n")
            sys.stdout.flush()

if __name__ == "__main__":
    challenge_common()
    challenge_phi()
