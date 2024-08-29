import hashlib
import json
import string
import os

"""
==================================
  Global parameters for protocol
==================================
"""

with open(os.path.join(os.path.abspath(os.path.dirname(__file__)), "flag.txt")) as f:
    FLAG = f.read().strip()

# Safe prime
g_commit = 0x2
p_commit = 0x1b1177aadf10a3868443d5b4e6384d914f8c2eb51d1ebec4511d05ed22d8006a65cb4fc0442334e4ad5e2b11cd65cb82efec327d234f034321a818cfc9c71d48f

# BLS12-381 Parameters
# https://github.com/zkcrypto/bls12_381
p = 0x1a0111ea397fe69a4b1ba7b6434bacd764774b84f38512bf6730d2a0f6b0f6241eabfffeb153ffffb9feffffffffaaab
r = 0x73eda753299d7d483339d80809a1d80553bda402fffe5bfeffffffff00000001
h1 = 0x396c8c005555e1568c00aaab0000aaab
h2 = 0x5d543a95414e7f1091d50792876a202cd91de4547085abaa68a205b2e5a7ddfa628f1cb4d9e82ef21537e293a6691ae1616ec6e786f0c70cf1c38e31c7238e5

# Define base fields
F1 = GF(p)
F2.<u> = GF(p^2, x, x^2 + 1)
F12.<w> = GF(p^12, x, x^12 - 2*x^6 + 2)

# Define the Elliptic Curves
E1 = EllipticCurve(F1, [0, 4])
E2 = EllipticCurve(F2, [0, 4*(1 + u)])
E12 = EllipticCurve(F12, [0, 4])

# Generator of order r in E1 / F1
G1x = 0x17f1d3a73197d7942695638c4fa9ac0fc3688c4f9774b905a14e3a3f171bac586c55e83ff97a1aeffb3af00adb22c6bb
G1y = 0x8b3f481e3aaa0f1a09e30ed741d8ae4fcf5e095d5d00af600db18cb2c04b3edd03cc744a2888ae40caa232946c5e7e1
G1 = E1(G1x, G1y)

# Generator of order r in E2 / F2
G2x0 = 0x24aa2b2f08f0a91260805272dc51051c6e47ad4fa403b02b4510b647ae3d1770bac0326a805bbefd48056c8c121bdb8
G2x1 = 0x13e02b6052719f607dacd3a088274f65596bd0d09920b61ab5da61bbdc7f5049334cf11213945d57e5ac7d055d042b7e
G2y0 = 0xce5d527727d6e118cc9cdc6da2e351aadfd9baa8cbdd3a76d429a695160d12c923ac9cc3baca289e193548608b82801
G2y1 = 0x606c4a02ea734cc32acd2b02bc28b99cb3e287e85a763af267492ab572e99ab3f370d275cec1da1aaa9075ff05f79be
G2 = E2(G2x0 + u*G2x1, G2y0 + u*G2y1)


"""
==================================
       BLS Signature Class
==================================
"""


class BLSSign():
    def __init__(self):
        self.d = randint(2, 2^70)
        self.public = self.public()

    def lift_E1_to_E12(self, P):
        """
        Lift point on E/F_q to E/F_{q^12} using the natural lift
        """
        assert P.curve() == E1, "Attempting to lift a point from the wrong curve."
        return E12(P)

    def lift_E2_to_E12(self, P):
        """
        Lift point on E/F_{q^2} to E/F_{q_12} through the sextic twist
        """
        assert P.curve() == E2, "Attempting to lift a point from the wrong curve."
        xs, ys = [c.polynomial().coefficients() for c in (h2*P).xy()]
        nx = F12(xs[0] - xs[1] + w ^ 6*xs[1])
        ny = F12(ys[0] - ys[1] + w ^ 6*ys[1])
        return E12(nx / (w ^ 2), ny / (w ^ 3))

    def point_to_integer(self, P):
        """
        Extracts an integer from a point for
        commitment.
        """
        if P.is_zero():
            return 0
        x,y = P.xy()

        s = Integer(x.polynomial().coefficients()[0])
        t = Integer(y.polynomial().coefficients()[0])
        n = s << (t & 1)
        return n

    def public(self):
        return self.d*G1

    def hash(self, i, msg):
        m = bytes.fromhex(msg)
        return hashlib.sha512(bytes([i]) + m).hexdigest()

    def hash_to_point(self, msg):
        i = 0
        m = int(msg, 16)
        Hm = self.hash(i, msg)
        while True:
            try:
                Hmx = int(Hm, 16) % p
                return m*E2.lift_x(Hmx)
            except:
                i += 1
                i %= 256
                Hm = self.hash(i, Hm)

    def pairing(self, A, B):
        return A.ate_pairing(B, r, 12, E12.trace_of_frobenius())

    def sign(self, msg):
        P = self.hash_to_point(msg)
        return self.d*P

    def verify(self, msg, sig):
        P = self.hash_to_point(msg)
        lhs = self.pairing(self.lift_E1_to_E12(self.public), self.lift_E2_to_E12(P))
        rhs = self.pairing(self.lift_E1_to_E12(G1), self.lift_E2_to_E12(sig))
        return lhs == rhs

    def commitment(self, msg):
        sig = self.sign(msg)
        x = self.point_to_integer(sig)
        return pow(g_commit, x, p_commit)


"""
==================================
  Util functions
==================================
"""


def recv_json():
    """
    Parse user input, expecting it as valid json
    """
    try:
        return json.loads(input("> "))
    except:
        exit("Please send data as json using the expected format.")


def commit_to_message(bls):
    """
    To be extra cautious, we will only give users our commitment
    to our signatures, we don't want people to be able to sign
    arbitary messages!
    """
    print("Please send your message to sign, encoded as a hex string.")
    resp = recv_json()
    if "message" in resp:
        msg = resp["message"]
        assert all(
            c in string.hexdigits for c in msg), "Invalid message. Please use hex encoding."
        commitment = bls.commitment(msg)
        print(f"Our commitment: {commitment}")
    else:
        print("You must send a message to see our commitment.")


def verify_signature(bls):
    """
    We'll give a flag to anyone who can supply a valid
    signature to the challenge message
    """
    challenge = b"https://cryptohack.org"
    print("Please send the valid signature for our challenge: {challenge}.")

    resp = recv_json()
    expected_coords = ["Sx0", "Sx1", "Sy0", "Sy1"]
    if all(s in resp for s in expected_coords):
        coords = [int(x, 16) for x in resp.values()]
        try:
            sig = E2(coords[0] + u*coords[1], coords[2] + u*coords[3])
        except:
            exit("You must send a point on the curve E2.")

        if bls.verify(challenge.hex(), sig):
            print(f"Flag: {FLAG}")
        else:
            exit("Fraudulent signature detected.")
    else:
        print("You must send the x and y coordinates of the signature.")


def main():
    bls = BLSSign()

    while True:
        print("Please send an option.")
        resp = recv_json()
        if "option" in resp:
            option = resp["option"]
            if option == "sign":
                commit_to_message(bls)
            elif option == "verify":
                verify_signature(bls)
            else:
                print("Invalid option")
        else:
            print("Invalid request.\nAvailable options: sign, verify.")


if __name__ == '__main__':
    main()
