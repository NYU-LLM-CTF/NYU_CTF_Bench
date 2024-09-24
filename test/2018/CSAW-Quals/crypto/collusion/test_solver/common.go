package main

import (
	"crypto/aes"
	"crypto/cipher"
	"crypto/rand"
	"crypto/sha256"
	"io"
	"math/big"
)

type devZero struct{}

func (dz devZero) Read(p []byte) (n int, err error) {
	for i := 0; i < len(p); i++ {
		p[i] = 0
	}
	return len(p), nil
}

// newReader returns a deterministic, cryptographically-secure source of random
// bytes seeded by `seed`.
func newReader(seed string) (io.Reader, error) {
	sum := sha256.Sum256([]byte(seed))
	block, err := aes.NewCipher(sum[:])
	if err != nil {
		return nil, err
	}

	iv := make([]byte, block.BlockSize())
	return cipher.StreamReader{
		S: cipher.NewCTR(block, iv),
		R: devZero{},
	}, nil
}

// DecrypterId deterministically maps a name to an integer modulo N.
func DecrypterId(id string, N *big.Int) (*big.Int, error) {
	r, err := newReader(id)
	if err != nil {
		return nil, err
	}
	n, err := rand.Int(r, N)
	if err != nil {
		return nil, err
	}
	n.SetBit(n, 0, 1)

	return n, nil
}

// phi returns Phi(N = p * q), where Phi is Euler's totient function.
func phi(p, q *big.Int) *big.Int {
	one := big.NewInt(1)

	a := new(big.Int).Sub(p, one)
	b := new(big.Int).Sub(q, one)

	return a.Mul(a, b)
}

// generateSafe generates a safe prime p=2q+1 where q is another prime.
//
// THIS FUNCTION IS VERY SLOW!
func generateSafe(src io.Reader, bits int) (*big.Int, error) {
	const level = 20
	var (
		one = big.NewInt(1)

		p    = new(big.Int)
		temp = new(big.Int)

		err error
	)

	for {
		p, err = rand.Prime(src, bits)
		if err != nil {
			return nil, err
		}

		// Check if 2p+1 is prime.
		temp.Lsh(p, 1)
		temp.Add(temp, one)

		if temp.Bit(0) != 0 && temp.ProbablyPrime(level) {
			return temp, nil
		}

		// Check if (p-1)/2 is also prime.
		temp.Sub(p, one)
		temp.Rsh(temp, 1)

		if temp.Bit(0) != 0 && temp.ProbablyPrime(level) {
			return p, nil
		}
	}
}

// Group is the group manager's private key. The group manager is capable of
// issuing decrypters' private key.
type Group struct {
	P, Q *big.Int
	X    *big.Int
}

func NewGroup(src io.Reader, bits int) (*Group, error) {
	p, err := generateSafe(src, bits/2)
	if err != nil {
		return nil, err
	}
	q, err := generateSafe(src, bits/2)
	if err != nil {
		return nil, err
	}

	x, err := rand.Int(src, phi(p, q))
	if err != nil {
		return nil, err
	}
	x.SetBit(x, 0, 0)

	return &Group{p, q, x}, nil
}

func (g *Group) Encrypter() *Encrypter {
	N := new(big.Int).Mul(g.P, g.Q)

	H := big.NewInt(3)
	H.Exp(H, g.X, N)

	return &Encrypter{N, H}
}

func (g *Group) Decrypter(id string) (*Decrypter, error) {
	N := new(big.Int).Mul(g.P, g.Q)

	n, err := DecrypterId(id, N)
	if err != nil {
		return nil, err
	}
	phiN := phi(g.P, g.Q)
	d := new(big.Int).Add(g.X, n)
	d.Mod(d, phiN).ModInverse(d, phiN)

	return &Decrypter{N, d}, nil
}

// Encrypter is a public key, used to encrypt messages to the set of decrypters.
type Encrypter struct {
	N *big.Int // N is the RSA modulus.
	H *big.Int // H is g^x (mod N), where g is a generator of (Z/NZ)* and x is the group manager's secret scalar.
}

// GenerateKey takes a random source as input and the identity of the recipient;
// it outputs the public KEM value and the shared secret.
func (e *Encrypter) GenerateKey(src io.Reader, id string) (*big.Int, []byte, error) {
	n, err := DecrypterId(id, e.N)
	if err != nil {
		return nil, nil, err
	}
	r, err := rand.Int(src, e.N)
	if err != nil {
		return nil, nil, err
	}

	V := big.NewInt(3)
	V.Exp(V, n, e.N).Mul(V, e.H).Mod(V, e.N).Exp(V, r, e.N)

	K := big.NewInt(3)
	K.Exp(K, r, e.N)
	shared := sha256.Sum256(K.Bytes())

	return V, shared[:], nil
}

// Decrypter is a decrypter's private key.
type Decrypter struct {
	N *big.Int // N is the RSA modulus.
	D *big.Int // D is the decrypter's private exponent.
}

// RecoverKey takes a public KEM value as input and outputs the shared secret.
func (d *Decrypter) RecoverKey(V *big.Int) []byte {
	K := new(big.Int).Exp(V, d.D, d.N)
	shared := sha256.Sum256(K.Bytes())
	return shared[:]
}

// Payload is a public-key encrypted message.
type Payload struct {
	V     *big.Int
	Nonce []byte
	Body  []byte
}

func Encrypt(e *Encrypter, recipient, message string) (*Payload, error) {
	V, shared, err := e.GenerateKey(rand.Reader, recipient)
	if err != nil {
		return nil, err
	}

	block, err := aes.NewCipher(shared)
	if err != nil {
		return nil, err
	}
	nonce := make([]byte, 12)
	if _, err := io.ReadFull(rand.Reader, nonce); err != nil {
		return nil, err
	}
	ciph, err := cipher.NewGCM(block)
	if err != nil {
		return nil, err
	}
	body := ciph.Seal(nil, nonce, []byte(message), nil)

	return &Payload{V, nonce, body}, nil
}
