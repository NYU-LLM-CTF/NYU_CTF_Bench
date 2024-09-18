func (g *Generator) getbits() *big.Int {
    t := g.Seed
    s, _ := g.Curve.ScalarBaseMult(t)
    g.Seed = s.Bytes()
    r, _ := g.Curve.ScalarMult(g.Q.X, g.Q.Y, s.Bytes())
    val := new(big.Int)
    val.Exp(big.NewInt(2), big.NewInt(8 * 30), nil)
    val.Sub(val, big.NewInt(1))
    r.And(r, val)
    return r
}
