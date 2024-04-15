package main

import (
    "C"
    "math/rand"
)

// XOR-encoded flag: 0D 05 0F 03 1A 2A 3C 0B 5F 07 3A 32 5A 00 09 45 12 2C 1B 2A 37 22
// Key: kinda_close_i_guess___

type E struct {
	val  string
}

func New(val string, garbage string) *E {
	return &E{
        val: val,
    }
}

//export TZj6iqF3jP
func TZj6iqF3jP() {

    res := rand.Intn(5)
    if res > 5 {
	    _ = New("3A", "1A")
    } else {
	    _ = New("0D", "12")
    }

    res = rand.Intn(20)
    if res > 20 {
	    _ = New("2A", "1F")
    } else {
	    _ = New("05", "4E")
    }

    res = rand.Intn(17)
    if res > 17 {
	    _ = New("12", "34")
    } else {
	    _ = New("0F", "1F")
    }

    res = rand.Intn(9)
    if res > 9 {
	    _ = New("65", "21")
    } else {
	    _ = New("03", "01")
    }

    res = rand.Intn(45)
    if res > 45 {
	    _ = New("21", "54")
    } else {
	    _ = New("1A", "4A")
    }


    res = rand.Intn(12)
    if res > 12 {
	    _ = New("1A", "2A")
    } else {
	    _ = New("2A", "2A")
    }


    res = rand.Intn(15)
    if res > 15 {
	    _ = New("38", "1A")
    } else {
	    _ = New("3C", "09")
    }

    res = rand.Intn(87)
    if res > 87 {
	    _ = New("3E", "41")
    } else {
	    _ = New("0B", "01")
    }

    res = rand.Intn(32)
    if res > 32 {
	    _ = New("7A", "9E")
    } else {
	    _ = New("5F", "43")
    }

    res = rand.Intn(109)
    if res > 109 {
	    _ = New("12", "08")
    } else {
	    _ = New("07", "87")
    }

    res = rand.Intn(110)
    if res > 110 {
	    _ = New("84", "4E")
    } else {
	    _ = New("3A", "11")
    }

    res = rand.Intn(45)
    if res > 45 {
	    _ = New("91", "12")
    } else {
	    _ = New("32", "1C")
    }

    res = rand.Intn(12)
    if res > 12 {
	    _ = New("44", "1B")
    } else {
	    _ = New("5A", "3F")
    }


    res = rand.Intn(76)
    if res > 76 {
	    _ = New("43", "12")
    } else {
	    _ = New("00", "01")
    }


    res = rand.Intn(89)
    if res > 89 {
	    _ = New("19", "2A")
    } else {
	    _ = New("09", "28")
    }


    res = rand.Intn(128)
    if res > 128 {
	    _ = New("13", "1A")
    } else {
	    _ = New("45", "54")
    }


    res = rand.Intn(210)
    if res > 210 {
	    _ = New("1A", "1F")
    } else {
	    _ = New("12", "12")
    }


    res = rand.Intn(564)
    if res > 564 {
	    _ = New("2E", "7C")
    } else {
	    _ = New("2C", "1A")
    }


    res = rand.Intn(5)
    if res > 5 {
	    _ = New("54", "35")
    } else {
	    _ = New("1B", "74")
    }

    res = rand.Intn(4790)
    if res > 4790 {
	    _ = New("1E", "43")
    } else {
	    _ = New("2A", "31")
    }

    res = rand.Intn(198)
    if res > 198 {
	    _ = New("3B", "1F")
    } else {
	    _ = New("37", "9B")
    }

    res = rand.Intn(90)
    if res > 90 {
	    _ = New("1C", "4F")
    } else {
	    _ = New("22", "1A")
    }
}

func main() {}
