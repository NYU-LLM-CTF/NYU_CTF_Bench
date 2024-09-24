package main

import (
	"io/ioutil"
	"os"
	"math/big"
)

func Poly(x int64) (*big.Int, error) {
	out := big.NewInt(0)

	x_fac := big.NewInt(x)

	file, err := os.Open("flag.txt")
	if err != nil {
		return out, err
	}

	flag, err := ioutil.ReadAll(file)
	if err != nil {
		return out, err
	}
	for power, b := range(flag) {
		x_fac.Exp(x_fac, big.NewInt(int64(power)), nil)

		big_b := big.NewInt(int64(b))
		big_b.Mul(big_b, x_fac)

		out.Add(out, big_b)
		x_fac = big.NewInt(x)
	}

	return out, nil
}

func Swizzle(s string) (string) {
	var n int64
	var acc int64
	acc = 0
	for _, c := range s {
		acc += int64(c)
	}
	if acc > 1100 {
		n = 1
	} else {
		n = (acc + 1653) % 2670
	}
	to_num, _ := Poly(n)

	return to_num.String()
}
