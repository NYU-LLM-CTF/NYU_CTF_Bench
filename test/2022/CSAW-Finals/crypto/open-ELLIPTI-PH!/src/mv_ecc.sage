from collections import namedtuple
MV_elgamel = namedtuple("MV_elgamel", 'rG c1 c2')

p = 6277101735386680763835789423207666416083908700390324961279
b = 2455155546008943817740293915197451784769108058161191238065

E = EllipticCurve(GF(p),  [-3,b])
G = E([602046282375688656758213480587526111916698976636884684818, 174050332293622031404857552280219410364023488927386650641])

def encode(msg):
        result = 0
        for c in msg:
                result = 256 * result + ord (c)
        return result

def decode(number):
        number = Integer(number)
        result = ''
        for i in number.digits(256):
                result = chr(i) + result
        return result

def encrypt_msg(msg, pub_key):
        k = floor (log (p ,256))                    # Max mesg size 2*k
        m1 = encode(msg[:k])
        m2 = encode(msg[k : 2*k ])
        x , y = 0 ,0
        while not (x and y):
                r = floor ( p * random())
                x, y, _ = r * pub_key
        return MV_elgamel(r*G, m1 * x, m2* y)


def decrypt_mv_eg (kpri, mv_elgamel):
        x = (kpri * mv_elgamel.rG)[0]
        y = (kpri * mv_elgamel.rG)[1]
        m1_raw, m2_raw = mv_elgamel.c1 * x ^ -1 , mv_elgamel.c2 * y ^ -1
        m1,m2 = decode(m1_raw), decode(m2_raw)
        return m1+m2
