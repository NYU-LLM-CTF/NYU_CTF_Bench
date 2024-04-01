package gamestate

import (
	"csaw_chall/nftdb"
	"csaw_chall/protocol"

	"encoding/json"
	"math/rand"
	"os"
	"path/filepath"
)

type GameState struct {
	Ntfs  []protocol.Nft  `json:"nfts"`
	Users []protocol.User `json:"users"`
}

func (g GameState) Print() {
	for i := range g.Ntfs {
		g.Ntfs[i].Print()

	}
}
func updatePrice(price float32) float32 {
	delta := rand.Int() % 4
	sign := rand.Int() % 2
	if sign == 0 {
		delta *= -1
	}

	return price + float32(delta)*(price/100)
}

func UpdateGamestate() error {
	db, err := nftdb.InitDb()
	defer db.Close()
	if err != nil {
		return err
	}
	gamestate := &GameState{}

	nfts, err := nftdb.GetAllNfts(db)
	if err != nil {
		return err
	}
	for i := range nfts {
		if nfts[i].Id != 1 {
			nfts[i].Price = updatePrice(nfts[i].Price)
		}
		nftdb.UpdateNFT(db, nfts[i])
		gamestate.Ntfs = append(gamestate.Ntfs, *nfts[i])
	}
	for i := range gamestate.Ntfs {
		gamestate.Ntfs[i].TrueLoc = "HIDDEN"
	}

	users, err := nftdb.GetAllUsers(db)
	if err != nil {
		return err
	}
	for i := range users {
		gamestate.Users = append(gamestate.Users, *users[i])
	}
	path, err := os.Getwd()
	if err != nil {
		return err
	}
	path = filepath.Join(path, "static", "gamestate.json")
	gsJson, err := json.Marshal(gamestate)
	if err != nil {
		return err
	}
	return os.WriteFile(path, []byte(string(gsJson)), 0644)

}
