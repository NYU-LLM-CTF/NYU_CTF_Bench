from base64 import b64encode, b64decode
from bls.scheme import *
from bplib.bp import G1Elem, G2Elem
from petlib.bn import Bn


def pretty_point(x):
    return b64encode(x.export())


class Threshold:
    def __init__(self):
        self.params = setup()
        (sks, vks) = ttp_keygen(self.params, 2, 3)
        self.sks = sks
        self.vks = vks
        pvks = list(map(pretty_point, vks))
        print(
            "hi welcome to chili's\nauthorized admins and keys:\nAbraham\n{}\nBernice\n{}\nChester\n{}".format(
                pvks[0], pvks[1], pvks[2]
            )
        )

    def abe_sign(self):
        tosign = str(raw_input("you want me to sign what? is it ham? I love ham!\n"))
        if tosign == "ham":
            print("sure thing")
            print(pretty_point(sign(self.params, self.sks[0], "ham")))
        else:
            print('mmm, I was thinking something more along the lines of "ham"')

    def bernice_sign(self):
        print("you don't even have to ask. the answer is NO!")

    def chester_sign(self):
        tosign = str(
            raw_input(
                (
                    "you want me to sign what? you sure this is legal? are you with the atf? the fda? are you high right now? do you ever get nervous?\n"
                )
            )
        )
        print("ok, sure")
        print(pretty_point(sign(self.params, self.sks[2], tosign)))

    def getsignature(self, ask, who):
        ask_s = b64decode(str(raw_input(ask)))
        s = G1Elem.from_bytes(ask_s, self.params[0])
        ask_p = b64decode(str(raw_input(who)))
        p = G2Elem.from_bytes(ask_p, self.params[0])
        assert p in self.vks
        return (s, p)

    def getflag(self):
        print(
            "gonna have to see some credentials, you know at least two admins gotta sign off on this stuff:"
        )
        (s0, p0) = self.getsignature(
            "first signature, please\n",
            "and who is this from (the public key, if you please)?\n",
        )
        (s1, p1) = self.getsignature(
            "OK, and the second?\n", "who gave you this one (again, by public key)?\n"
        )
        assert s0 != s1
        p2 = G2Elem.from_bytes(
            b64decode(
                str(
                    raw_input(
                        "who didn't sign? We need their public key to run everything\n"
                    )
                )
            ),
            self.params[0],
        )
        if verify(
            self.params,
            aggregate_vk(self.params, [p0, p1, p2], threshold=True),
            aggregate_sigma(self.params, [s0, s1], threshold=True),
            "this stuff",
        ):
            with open("flag.txt") as f:
                print(f.read())
        else:
            print("lol nice try")

    def dispatch(self):
        i = int(
            raw_input(
                "what do you want to do? (1) talk to Abe, (2) talk to Bernie, (3) talk to C-money, (4) see the flag\n"
            )
        )
        if i == 1:
            self.abe_sign()
            self.dispatch()
        elif i == 2:
            self.bernice_sign()
            self.dispatch()
        elif i == 3:
            self.chester_sign()
            self.dispatch()
        elif i == 4:
            self.getflag()
        else:
            print("not sure what you mean...")


if __name__ == "__main__":
    s = Threshold()
    s.dispatch()
