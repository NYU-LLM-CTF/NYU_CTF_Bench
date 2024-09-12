package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"time"
)

func gopherArt() {
	fmt.Print(`
          _____________
          |           |
          |           |
          |           |
      ____|___________|____
        ,_---~~~~~----._
  _,,_,*^____      _____\˴ᐠ*g*\"*,
 / __/ /'     ^.  /      \ ^@q   f
[  @f | @))    |  | @))   l  0 _/
 \ᐠ/   \~____ / __ \_____/    \
  |           _l__l_           I
  }          [______]           I
  ]            | | |            |
  ]             ~ ~             |
  |                            |
   |                           |
`)
}

func main() {
	var data string

	gopherArt()
	fmt.Println("For my magic trick...")
	fmt.Print("Enter any data you want and I put it into my mysterious black box and you get out stuff into a file (wow magic)\n")
	
	// Read data from input
	reader := bufio.NewReader(os.Stdin)
	fmt.Print("Enter data: ")
	data, _ = reader.ReadString('\n')
	data = data[:len(data)-1]

	// Convert string to a slice of runes
	runes := []rune(data)

	// Jumble the output into "garbage"
	for i := 0; i < len(runes); i++ {
		runes[i] = rune((int(runes[i])+23 ^ int(runes[i]-1) << 1) % 4 + int(runes[i]) * 2 - 32)
	}
	
	//convert runes back to string
	output := string(runes)
	fmt.Println("ok wait...")
	time.Sleep(time.Second)
	fmt.Print("Tada! Your file is ready but useless maybe!")

	// Write the output to a file
	err := os.WriteFile("output.txt", []byte(output), 0644)
	if err != nil {
		log.Fatal(err)
	}
}

