package main

import (
    "os"
    "fmt"
    "bufio"
    "bytes"
    "strings"
    "math/big"
    "encoding/hex"
    "crypto/rand"
    "crypto/elliptic"
)


type Point struct {
    X *big.Int
    Y *big.Int
}

func NewPoint(X *big.Int, Y *big.Int) Point {
    return Point {X, Y}
}

type Generator struct {
    Seed []byte
    Curve *elliptic.CurveParams
    Q Point
}

func NewGenerator(seed []byte) (*Generator, error) {

    // get P256 curve params
    curveParams := elliptic.P256().Params()

    // generate a random p param
    d, err := rand.Int(rand.Reader, curveParams.P)
    if err != nil {
        return nil, err
    }

    // STATIC TEST:
    //d = NewBigInt("35150b25e49bd13d1bef27dba9452bceb4c6358a6893ce30a2b02e3300d7a825", 16)
    //  => 3d7e1a1919209b6631dc439791071c470de7c98a38da1242a932bd4ff335

    // get inverse of the number in the field of the base points order
    e := new(big.Int)
    e.ModInverse(d, curveParams.N)

    // initialize Q point for P256 curve
    Qx, Qy := curveParams.ScalarBaseMult(e.Bytes())
    Q := NewPoint(Qx, Qy)

    fmt.Println(hex.EncodeToString(d.Bytes()))
    fmt.Println("(", hex.EncodeToString(Qx.Bytes()), ",", hex.EncodeToString(Qy.Bytes()), ")")

    // check if dQ = P

    return &Generator {
        Seed: seed,
        Curve: curveParams,
        Q: Q,
    }, nil
}

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

func win() {
    file, err := os.Open("flag.txt")
    if err != nil {
        return
    }
    var b bytes.Buffer
    b.ReadFrom(file)
    fmt.Print(b.String())
}


func main() {

    // initialize seed value
    val := []byte("1fc95c3714652fe2")
    seed := make([]byte, hex.DecodedLen(len(val)))
    if _, err := hex.Decode(seed, val); err != nil {
        fmt.Println(err)
        return
    }

    for i := 1; i <= 10; i++ {

        // create random number generation
        gen, err := NewGenerator(seed)
        if err != nil {
            fmt.Println(err)
            return
        }

        bits1 := gen.getbits()
        bits2 := gen.getbits()

        res1 := new(big.Int)
        res1.Lsh(bits1, (2 * 8))

        res2 := new(big.Int)
        res2.Rsh(bits2, (28 * 8))

        res := new(big.Int)
        res.Or(res1, res2)
        fmt.Println(hex.EncodeToString(res.Bytes()))

        // take input
        reader := bufio.NewReader(os.Stdin)
        fmt.Print("Guess? ")
        text, _ := reader.ReadString('\n')
        text = strings.TrimSuffix(text, "\n")

        // compare with bits2
        actual := hex.EncodeToString(bits2.Bytes())
        if actual != text {
            fmt.Println("Nope!")
            return
        }
    }

    // print flag
    win();
}
