package main

import (
	"crypto/aes"
	"crypto/cipher"
	"crypto/sha256"
	"encoding/json"
	"io/ioutil"
	"log"
	"math/big"
)

func main() {
	log.SetFlags(log.LstdFlags | log.Lshortfile)

	bobRaw, err := ioutil.ReadFile("bobs-key.json")
	if err != nil {
		log.Fatal(err)
	}
	bobsKey := &Decrypter{}
	if err := json.Unmarshal(bobRaw, bobsKey); err != nil {
		log.Fatal(err)
	}
	b, _ := DecrypterId("Bob", bobsKey.N)

	carolRaw, err := ioutil.ReadFile("carols-key.json")
	if err != nil {
		log.Fatal(err)
	}
	carolsKey := &Decrypter{}
	if err := json.Unmarshal(carolRaw, carolsKey); err != nil {
		log.Fatal(err)
	}
	c, _ := DecrypterId("Carol", carolsKey.N)

	// Use two different methods to compute something which is the same modulo
	// Phi(N), but gives different results prior to reduction. Subtract the two
	// values to get a random multiple of the group order, Phi(N).
	//
	// The two methods are:
	//   1/(x+b) - 1/(x+c) = (c-b) * 1/(x+b) * 1/(x+c).
	kPhiN := new(big.Int).Sub(c, b)
	kPhiN.Mul(kPhiN, bobsKey.D).Mul(kPhiN, carolsKey.D)
	kPhiN.Sub(kPhiN, bobsKey.D).Add(kPhiN, carolsKey.D)
	kPhiN.Abs(kPhiN)

	// We don't actually need to recover Phi(N) exactly to compute Alice's
	// private key, the random multiple is enough because there's an implicit
	// ring homomorphism from Z/(k*Phi(N))Z -> Z/(Phi(N))Z.
	//
	// However, we do need to remove any common factors between Bob's private
	// key and k*Phi(N) because that will hinder modular inversion.
	gcd := new(big.Int).GCD(nil, nil, bobsKey.D, kPhiN)
	kPhiN.Div(kPhiN, gcd)

	// Compute (something congruent to) Alice's private key in the trivial way:
	// invert Bob's key, subtract his decrypter id, add Alice's id, and invert
	// again.
	a, _ := DecrypterId("Alice", bobsKey.N)

	aliceD := new(big.Int).ModInverse(bobsKey.D, kPhiN)
	aliceD.Sub(aliceD, b).Add(aliceD, a)
	aliceD.ModInverse(aliceD, kPhiN)

	// Decrypt the message.
	msgRaw, err := ioutil.ReadFile("message.json")
	if err != nil {
		log.Fatal(err)
	}
	msg := &Payload{}
	if err := json.Unmarshal(msgRaw, msg); err != nil {
		log.Fatal(err)
	}
	out, err := decrypt(aliceD, bobsKey.N, msg)
	if err != nil {
		log.Fatal(err)
	}

	log.Println(out)
}

func decrypt(d, N *big.Int, p *Payload) (string, error) {
	K := new(big.Int).Exp(p.V, d, N)
	shared := sha256.Sum256(K.Bytes())

	block, err := aes.NewCipher(shared[:])
	if err != nil {
		return "", err
	}
	ciph, err := cipher.NewGCM(block)
	if err != nil {
		return "", err
	}
	message, err := ciph.Open(nil, p.Nonce, p.Body, nil)
	if err != nil {
		return "", err
	}

	return string(message), nil
}
