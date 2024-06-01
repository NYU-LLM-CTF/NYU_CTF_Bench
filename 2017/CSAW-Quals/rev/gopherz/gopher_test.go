package main

import (
	"math/big"
	"testing"
)

func TestPoly(t *testing.T) {
	s, _ := Poly(1)
	butterfly_swiz := Swizzle("butterfly\r\n")
	conv, _ := Poly(s.Add(s, big.NewInt(1)).Int64())
	if conv.String() != butterfly_swiz {
		t.Errorf("Failed butterfly")
	}

}
