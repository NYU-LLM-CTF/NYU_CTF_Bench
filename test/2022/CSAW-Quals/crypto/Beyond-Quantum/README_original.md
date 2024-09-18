# ntru
**ntru** is a simple implementation of NTRUEncrypt cryptosystem, written in Python 3.6.
Polynomial operations are implemented using [SymPy](http://www.sympy.org) library.
It was made as a homework project for "Error-Correcting Codes and Cryptography" workshops on [Faculty of Mathematics and Information Science of Warsaw University of Technology](http://www.mini.pw.edu.pl).

**This package was made as an exercise. It shouldn't be used anywhere to secure data.**

## How to run?

### Install Python 3.x
You should have Python 3.x installed on your system. To do this on [Fedora OS](https://getfedora.org/ "Get Fedora") you need to execute
```
sudo dnf install python3
```

### Install dependencies
You should have [SymPy](http://www.sympy.org), [NumPy](http://www.numpy.org/) and [docopt](http://www.docopt.org/) package installed.
```
pip3 install --user sympy
pip3 install --user numpy
pip3 install --user docopt
```

## How to use it?
To print help screen execute `ntru.py` script with `-h` argument.
```
$ ./ntru.py -h
NTRU v0.1

Usage:
  ntru.py [options] enc PUB_KEY_FILE [FILE]
  ntru.py [options] dec PRIV_KEY_FILE [FILE]
  ntru.py [options] gen N P Q PRIV_KEY_FILE PUB_KEY_FILE
  ntru.py (-h | --help)
  ntru.py --version

Options:
  -b, --block        Interpret input/output as
                       block stream.
  -i, --poly-input   Interpret input as polynomial
                       represented by integer array.
  -o, --poly-output  Interpret output as polynomial
                       represented by integer array.
  -h, --help         Show this screen.
  --version          Show version.
  -d, --debug        Debug mode.
  -v, --verbose      Verbose mode.
```

As you can see there are few commands:
* `enc` - encrypt a file using public key
* `dec` - decrypt a file using private key
* `gen` - generate a key pair with given parameters

### Generating a key pair

To generate random public and private key pair execute:

```
$ ./ntru.py -v gen 167 3 128 myKey.priv myKey.pub
```

The `myKey.priv.npz` and `myKey.pub.npz` files should appear in current working directory. These are zip compressed NumPy files which contains:

* both keys:
    * N
    * p
    * q
* public key:
    * f
    * f_p
* private key:
    * h

One can see these parameters by running the program in verbose mode:

```
$ ./ntru.py -v gen 167 3 128 myKey.priv myKey.pub
NTRU(N=167,p=3,q=128) initiated
g: Poly(x**166 - x**157 + x**128 + x**127 - x**122 - x**121 + x**110 + x**101 + x**93 + x**78 - x**64 - x**63 - x**62 + x**61 - x**56 - x**50 + x**46 - x**44 - x**39 + x**36 + x**32 - x**5, x, domain='ZZ')
g coeffs: Counter({1: 11, -1: 11})
f: Poly(x**165 - x**164 - x**163 + x**158 + x**152 - x**151 - x**150 + x**149 - x**148 + x**147 + x**146 - x**145 + x**142 + x**141 - x**140 + x**139 + x**138 - x**136 - x**134 - x**132 - x**131 + x**130 + x**127 - x**126 - x**125 - x**124 - x**123 - x**121 + x**117 - x**116 + x**115 - x**114 - x**113 + x**112 - x**111 + x**110 - x**109 - x**107 + x**105 - x**104 + x**101 - x**100 - x**99 + x**97 + x**96 + x**94 - x**92 + x**90 + x**85 - x**84 + x**83 - x**82 + x**81 - x**79 - x**77 + x**76 + x**75 + x**74 - x**73 + x**72 + x**71 + x**69 + x**68 + x**67 - x**65 + x**64 + x**63 - x**62 + x**61 + x**60 + x**59 + x**58 - x**54 - x**53 + x**52 - x**51 + x**49 - x**47 - x**45 + x**44 + x**43 - x**41 + x**40 - x**36 + x**35 - x**34 + x**33 + x**31 + x**30 - x**29 + x**28 - x**26 - x**24 + x**22 - x**21 - x**20 - x**18 - x**17 - x**16 - x**15 + x**14 + x**11 - x**10 + x**8 + x**6 - x**5 - x**4 - x**2 + 1, x, domain='ZZ')
f coeffs: Counter({1: 55, -1: 54})
f_p: Poly(-x**166 + x**165 + x**164 - x**162 - x**161 + x**160 - x**159 + x**158 - x**156 - x**155 - x**153 + x**152 + x**151 - x**150 - x**149 + x**148 - x**146 - x**145 + x**144 + x**142 + x**141 + x**140 - x**139 + x**138 + x**137 - x**135 + x**134 - x**132 + x**130 - x**129 + x**128 - x**126 - x**124 - x**123 + x**121 + x**118 + x**116 - x**115 - x**113 - x**112 - x**111 - x**110 + x**109 + x**108 - x**107 + x**106 - x**105 + x**104 + x**103 + x**102 - x**101 + x**100 + x**99 - x**96 + x**94 + x**91 + x**90 + x**88 + x**87 - x**84 + x**83 + x**82 - x**81 - x**79 + x**78 - x**77 + x**71 + x**69 + x**66 - x**65 - x**64 + x**61 + x**59 - x**56 - x**55 - x**54 - x**53 + x**51 + x**49 - x**48 + x**45 - x**44 + x**43 + x**42 + x**40 - x**39 - x**38 - x**37 - x**36 - x**35 - x**34 + x**33 - x**32 + x**31 - x**30 + x**29 + x**27 + x**26 + x**25 + x**22 + x**21 + x**20 - x**19 - x**17 - x**14 + x**12 - x**9 + x**8 - x**6 + x**4 + x**3 - x**2 + 1, x, modulus=3)
f_q: Poly(-45*x**166 + 49*x**165 + 43*x**164 - 5*x**163 - 31*x**162 + 12*x**161 + 46*x**160 - 25*x**159 - 12*x**158 + 50*x**157 - 60*x**156 + 42*x**155 + 3*x**154 + 24*x**153 + 63*x**152 + 41*x**151 + x**150 - 50*x**149 + 16*x**148 + 48*x**147 + 62*x**146 + 59*x**145 - 36*x**144 + 54*x**143 - 16*x**142 + 36*x**141 - 34*x**140 - 43*x**139 + 16*x**138 + 64*x**137 + 36*x**136 - 33*x**135 - 40*x**134 + 11*x**133 - 16*x**132 - 49*x**131 + 51*x**130 + 40*x**129 + 10*x**128 - 53*x**127 - 33*x**126 + 16*x**125 + 64*x**124 - 50*x**123 + 35*x**122 - 59*x**121 - 59*x**120 + 35*x**119 - 58*x**118 + 43*x**117 + 28*x**116 + 5*x**115 - 45*x**114 - 33*x**113 - 14*x**112 - 56*x**111 - 24*x**110 + 31*x**109 + 53*x**108 + 30*x**107 + 59*x**106 + 23*x**105 - 30*x**104 + 50*x**103 - 41*x**102 - 23*x**101 - 51*x**100 - 56*x**99 + 40*x**98 + 25*x**97 + 50*x**96 - 12*x**95 + 11*x**94 - 6*x**93 + 45*x**92 - 2*x**91 - 43*x**90 - 7*x**89 - 51*x**88 + 16*x**87 + 39*x**86 - 57*x**85 + 31*x**83 + 41*x**82 - 40*x**81 + 38*x**80 + 25*x**79 + 49*x**78 - 30*x**77 - 35*x**76 + 22*x**75 + 23*x**74 + 57*x**73 - 45*x**72 - 9*x**71 + 26*x**70 + 41*x**69 + 59*x**68 - 19*x**67 + 17*x**66 - 41*x**65 - 12*x**64 - 60*x**63 + 25*x**62 + 14*x**61 - 26*x**60 + 30*x**59 - 44*x**58 - 19*x**57 - 39*x**56 + 59*x**55 - 42*x**54 + 17*x**53 + 58*x**52 - 40*x**51 + 42*x**50 + 51*x**49 - 30*x**48 + 19*x**47 - 44*x**46 - 45*x**45 + 15*x**44 - 15*x**43 - 48*x**42 - 9*x**41 + 62*x**40 + 25*x**39 - 25*x**38 - x**37 + 61*x**36 - 57*x**35 + 45*x**34 - 24*x**33 - 61*x**32 - 4*x**31 + 59*x**30 + 27*x**29 + 10*x**28 - 22*x**27 - 5*x**26 + 5*x**25 - 10*x**24 - 26*x**23 + 49*x**22 + 63*x**20 - 48*x**19 + 42*x**18 - 49*x**17 - 34*x**16 + 26*x**15 + 2*x**14 + 46*x**13 - 23*x**12 + 11*x**11 + 21*x**10 + 27*x**9 - 9*x**8 - 11*x**7 - 35*x**6 + 23*x**5 - 7*x**4 + 2*x**3 - 52*x**2 - 53*x + 51, x, domain='ZZ')
h: Poly(62*x**166 - 20*x**165 + 48*x**164 + 32*x**163 - 15*x**162 - 22*x**161 + 16*x**160 - 54*x**159 - 17*x**158 - 27*x**157 - 33*x**156 - 40*x**155 - 59*x**154 + 54*x**153 + 30*x**152 - 18*x**151 - 24*x**150 + 48*x**149 - 6*x**148 - 40*x**147 + 10*x**146 + 47*x**145 + 33*x**144 + 51*x**143 + 12*x**142 + 57*x**141 + 52*x**140 + 44*x**139 + 55*x**138 + 53*x**137 + 60*x**136 + 8*x**135 - 63*x**134 + 32*x**133 + 10*x**132 + 36*x**131 - 45*x**130 + 38*x**129 - 59*x**128 + 62*x**127 + 29*x**126 + 11*x**125 - 40*x**124 + 11*x**123 + 48*x**122 + 31*x**121 + 38*x**120 + 54*x**119 + 47*x**118 - 57*x**117 - 27*x**116 + x**115 + 6*x**114 - 24*x**113 - 15*x**112 - 59*x**111 + 45*x**110 - 35*x**109 - 58*x**108 - 43*x**107 + 15*x**106 - 25*x**105 + 4*x**104 - 4*x**103 - x**102 + 58*x**101 - 25*x**100 - 20*x**99 + 42*x**98 + 51*x**97 + 10*x**96 + 29*x**95 + x**94 + 23*x**93 - 40*x**92 - 5*x**91 - 56*x**90 + 21*x**89 - 55*x**88 + x**87 + x**86 + 29*x**85 - 9*x**84 - 47*x**83 + 19*x**82 + 39*x**81 + 47*x**80 + 46*x**79 + 26*x**78 - 19*x**77 + 37*x**76 - 22*x**75 + 25*x**74 - 19*x**73 - 43*x**72 + 22*x**71 + 34*x**70 + 42*x**69 - 36*x**68 + 61*x**67 - 37*x**66 + x**65 - 61*x**64 - 19*x**63 + 55*x**62 + 25*x**61 + 58*x**60 + 5*x**59 - 11*x**58 - 33*x**57 - 44*x**56 + 23*x**55 - 63*x**54 - 20*x**53 - 53*x**52 + 50*x**51 + 57*x**50 + 12*x**49 - 9*x**48 + 50*x**47 - 45*x**46 + 6*x**45 + 17*x**44 - 38*x**43 + 50*x**42 - 52*x**41 - 42*x**40 - 56*x**39 - 29*x**38 + 60*x**37 + 21*x**36 + 35*x**35 + 47*x**34 - 3*x**33 + 55*x**32 - 7*x**31 + 40*x**30 - 19*x**29 + 49*x**28 + 22*x**27 + 2*x**26 - 19*x**25 - 61*x**24 + 19*x**23 + 53*x**22 - 19*x**21 + 23*x**20 + 50*x**19 + 26*x**18 + 28*x**17 + 36*x**16 - 28*x**15 + 54*x**14 + 37*x**13 - 15*x**12 - 36*x**11 - 24*x**10 + 40*x**9 - 36*x**8 + 26*x**7 - 63*x**6 + 55*x**5 - 57*x**4 + 5*x**3 + 39*x**2 - 61*x - 31, x, domain='ZZ')
Private key saved to myKey.priv file
Private key saved to myKey.pub file
```

### Encrypting / decrypting

There are two ways of providing input to the program and two ways of interpreting this input.

Supported input:

* file

```
$ ./ntru.py enc myKey.pub.npz test.txt
!֘Tމ���c|���}3i1<pV�9�p��[E�VS��X1�4��ц4�6�A�ƚ�;����˔O)'�G8��5Mt[RXcj0]���y���hq�^1�ē���b944
                                                                                           (�n�'u���y4��W��	���6����5W�*��
```

* standard input

```
$ echo "hello!" | ./ntru.py enc myKey.pub.npz
|�w�T�a�V�"I�&�C�(�i��C���y��~���U��|8� Qg
                                          �f�(�B��?�c{r����giܝ���7LxQwH*�G*�
                                                                            ��Y'��7����f@�F�ɂ�9�TU�ʪ�Oܠ�l���(@�
                                                                                                               )e���$�(B���)�
```

Supported input/output types:

* binary encryption input (decryption output) is translated into (from a) polynomial with coefficients of ones and zeros (we can see the array of this polynomial using debug mode)

```
$ echo "hello!" | ./ntru.py -d enc myKey.pub.npz

...

---INPUT---
b'hello!\n'
-----------
POLYNOMIAL DEGREE: 54
BINARY: [0 1 1 0 1 0 0 0 0 1 1 0 0 1 0 1 0 1 1 0 1 1 0 0 0 1 1 0 1 1 0 0 0 1 1 0 1
 1 1 1 0 0 1 0 0 0 0 1 0 0 0 0 1 0 1]
```

* binary encryption output (decryption input) is translated from a polynomial with coefficients in Z_q field into binary stream where each coefficient is encoded into log(q) bits
* polynomial as integer array (e.g. `[1,0,1]`)

```
$ echo "hello!" | ./ntru.py -o enc myKey.pub.npz
[-13, 39, 0, 14, 7, 19, 40, 61, 45, -24, -32, 41, 12, -58, 42, 2, -48, 63, 14, -26, 22, 41, 35, 22, 16, 50, 62, -17, 30, -60, -20, 50, 17, 16, -58, 54, -45, 4, 20, -11, 33, 59, 43, -32, 60, -18, 60, 20, 57, 3, 47, 55, -54, 9, 37, -30, 43, 30, 55, -25, 17, -45, 37, -54, -56, -52, -49, 21, 24, 64, 9, 34, -59, -8, 64, -10, -49, 17, 2, 31, -48, 39, -20, 64, -42, -22, 7, 0, -34, -40, -20, 27, -9, 60, -25, -57, 45, -4, 62, -50, -22, -13, 59, 9, 15, -49, -60, 31, 2, 38, -13, -17, -55, -40, 36, -22, -42, 46, -63, -56, 28, -32, -51, 13, -27, -28, -57, -62, -17, -3, -9, 35, -6, 16, 56, 31, -14, 48, -20, 54, -30, 59, 61, -53, -44, 44, 49, -58, -20, -19, -9, -7, -55, 52, 10, 7, 18, 24, -49, -57, 61, -38, 48, 55, 11, -54, 43]
$ echo "[0,1,1,0,1,0,0,0,0,1,1,0,0,1,0,1,0,1,1,0,1,1,0,0,0,1,1,0,1,1,0,0,0,1,1,0,1,1,1,1,0,0,1,0,0,0,0,1,0,0,0,0,1,0,1]" | ./ntru.py -i enc myKey.pub.npz | ./ntru.py dec myKey.priv.npz
hello!
$ echo "[0,1,1,0,1,0,0,0,0,1,1,0,0,1,0,1,0,1,1,0,1,1,0,0,0,1,1,0,1,1,0,0,0,1,1,0,1,1,1,1,0,0,1,0,0,0,0,1,0,0,0,0,1,0,1]" | ./ntru.py -i enc myKey.pub.npz | ./ntru.py dec myKey.priv.npz | xxd -b
00000000: 01101000 01100101 01101100 01101100 01101111 00100001  hello!
00000006: 00001010    
```

The program always returns its output to standard output. You can save the output to file by redirecting standard output to file. Remember not to use verbose or debug mode in this case.

```
$ ./ntru.py enc myKey.pub.npz test.txt > encrypted_test.txt
$ ./ntru.py dec myKey.priv.npz encrypted_test.txt
hello!
$ cat test.txt
hello!
$ cat encrypted_test.txt
�o�K_�gi���f�H�qlnh�|{��w���r/��)HL)F���9}�8
                                            Ė�bX��pw@�.*�-۬����D!Au��&�@9��/S�J��q]�~�o�O�D��Yp����M�Ly%_��Ѩ*\;�����P!�iAs*��
```

#### Input size

If the input you provided is too large, the program will return this error.

```
$ ./ntru.py enc myKey.pub.npz test.txt
Traceback (most recent call last):
  File "./ntru.py", line 149, in <module>
    output = encrypt(args['PUB_KEY_FILE'], input_arr, bin_output=not poly_output, block=block)
  File "./ntru.py", line 58, in encrypt
    raise Exception("Input is too large for current N")
Exception: Input is too large for current N
```

In this case, you can use the block mode, which splits the input into blocks of the requested size. Make sure you are using this mode in both encrypting and decrypting process.

```
$ ./ntru.py -b enc myKey.pub.npz test.txt | ./ntru.py -b dec myKey.priv.npz
hello!
```

#### Verbose mode

When running each process in verbose mode, the program prints to standard output all important variables. Meaning of these could be found in papers about NTRUEncrypt (or even [Wikipedia](https://en.wikipedia.org/wiki/NTRUEncrypt)).

Most of variables are polynomials in form of:

```
g: Poly(-x**10 - x**8 + x**5 + x, x, domain='ZZ')
```

Some polynomials have particular coefficients counted:

```
g coeffs: Counter({-1: 2, 1: 2})
```

### Issues

* Using small N and q values don't work well and leads to the random success of encryption
* Encrypting even quite small files (~100kB) in block stream mode can take a lot of time
