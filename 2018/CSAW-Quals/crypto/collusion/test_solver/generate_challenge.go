package main

import (
	"crypto/rand"
	"encoding/json"
	"io/ioutil"
	"log"
)

func main() {
	log.SetFlags(log.LstdFlags | log.Lshortfile)

	g, err := NewGroup(rand.Reader, 1024)
	if err != nil {
		log.Fatal(err)
	}
	e := g.Encrypter()

	if err := saveToFile("encrypter.json", e); err != nil {
		log.Fatal(err)
	}

	payload, err := Encrypt(e, "Alice", "flag{flag_created_in_validation_mission_payload")
	if err != nil {
		log.Fatal(err)
	} else if err := saveToFile("message.json", payload); err != nil {
		log.Fatal(err)
	}

	dB, err := g.Decrypter("Bob")
	if err != nil {
		log.Fatal(err)
	} else if err := saveToFile("bobs-key.json", dB); err != nil {
		log.Fatal(err)
	}

	dC, err := g.Decrypter("Carol")
	if err != nil {
		log.Fatal(err)
	} else if err := saveToFile("carols-key.json", dC); err != nil {
		log.Fatal(err)
	}
}

// saveToFile json-encodes x and writes to a file with the given name.
func saveToFile(name string, x interface{}) error {
	raw, err := json.Marshal(x)
	if err != nil {
		return err
	}
	return ioutil.WriteFile(name, raw, 0777)
}
