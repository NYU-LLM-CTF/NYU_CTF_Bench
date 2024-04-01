package actions

import (
	"csaw_chall/gamestate"
	"csaw_chall/nftdb"
	"csaw_chall/protocol"
	"database/sql"
	"encoding/json"
	"errors"
	"fmt"
	"os/exec"
	"regexp"
	"strings"
)

func Debug(cmd string, args []string) ([]byte, error) {
	return exec.Command(cmd, args...).Output()
}
func validateString(username string) error {
	if !regexp.MustCompile(`^[a-z_]{3,15}$`).MatchString(username) {
		return errors.New("invalid string: r'^[a-z_]{3,15}$'")
	}
	return nil
}

func CreateAccount(db *sql.DB, username string) protocol.Response {
	err := validateString(username)
	if err != nil {
		return protocol.Response{ResponseCode: 1, Response: []byte(err.Error())}
	}
	id, err := nftdb.AddUser(db, username, 1.0)
	if err != nil {
		fmt.Println(err)
		if strings.Contains(err.Error(), "Duplicate entry") {
			return protocol.Response{ResponseCode: 1, Response: []byte("Username Taken")}

		}
		return protocol.Response{ResponseCode: 1, Response: []byte("internal error")}
	}
	user, err := nftdb.GetUser(db, id)
	if err != nil {
		fmt.Println(err)
		return protocol.Response{ResponseCode: 1, Response: []byte("user creation failed")}
	}
	userJson, err := json.Marshal(user)
	if err != nil {
		fmt.Println(err)
		return protocol.Response{ResponseCode: 1, Response: []byte("invalid user object")}
	}
	gamestate.UpdateGamestate()
	return protocol.Response{ResponseCode: 0, Response: []byte(userJson)}
}

func GetUser(db *sql.DB, userId uint32) protocol.Response {
	user, err := nftdb.GetUser(db, userId)
	if err != nil {
		fmt.Println(err)
		return protocol.Response{ResponseCode: 1, Response: []byte("user not found")}
	}
	userJson, err := json.Marshal(user)
	if err != nil {
		fmt.Println(err)
		return protocol.Response{ResponseCode: 1, Response: []byte("invalid user object")}
	}
	return protocol.Response{ResponseCode: 0, Response: []byte(userJson)}
}

func LookupUser(db *sql.DB, username string) protocol.Response {
	user, err := nftdb.GetUserByName(db, username)
	if err != nil || user.Id == 0 {
		fmt.Println(err)
		return protocol.Response{ResponseCode: 1, Response: []byte("user not found")}
	}
	userJson, err := json.Marshal(user)
	if err != nil {
		fmt.Println(err)
		return protocol.Response{ResponseCode: 1, Response: []byte("invalid user object")}
	}
	return protocol.Response{ResponseCode: 0, Response: []byte(userJson)}

}

func BuyNFT(db *sql.DB, userId uint32, nftId uint32) protocol.Response {
	user, err := nftdb.GetUser(db, userId)
	if err != nil {
		fmt.Println(err)
		return protocol.Response{ResponseCode: 1, Response: []byte("user not found")}
	}
	nft, err := nftdb.GetNFT(db, nftId)
	if err != nil {
		fmt.Println(err)
		return protocol.Response{ResponseCode: 1, Response: []byte("nft not found")}
	}
	if nft.Price > user.AccountBalance {
		return protocol.Response{ResponseCode: 1, Response: []byte("insufficient funds")}
	}
	if nft.OwnedBy == user.Id {
		return protocol.Response{ResponseCode: 1, Response: []byte("nft already owned")}
	}
	originalOwner, err := nftdb.GetUser(db, nft.OwnedBy)
	if err != nil {
		fmt.Println(err)
		return protocol.Response{ResponseCode: 1, Response: []byte("internal error")}
	}
	originalOwner.AccountBalance = originalOwner.AccountBalance + nft.Price
	err = nftdb.UpdateUser(db, originalOwner)
	if err != nil {
		fmt.Println(err)
		return protocol.Response{ResponseCode: 1, Response: []byte("internal error")}
	}

	user.AccountBalance = user.AccountBalance - nft.Price
	err = nftdb.UpdateUser(db, user)
	if err != nil {
		fmt.Println(err)
		return protocol.Response{ResponseCode: 1, Response: []byte("internal error")}
	}

	nft.OwnedBy = user.Id
	nft.OwnedByName = user.UserName
	err = nftdb.UpdateNFT(db, nft)
	if err != nil {
		fmt.Println(err)
		return protocol.Response{ResponseCode: 1, Response: []byte("internal error")}
	}
	gamestate.UpdateGamestate()
	return protocol.Response{ResponseCode: 0}
}

func UpdateNFTName(db *sql.DB, userId uint32, nftId uint32, newName string) protocol.Response {
	err := validateString(newName)
	if err != nil {
		fmt.Println(err)
		return protocol.Response{ResponseCode: 1, Response: []byte(err.Error())}
	}
	nft, err := nftdb.GetNFT(db, nftId)
	if err != nil {
		fmt.Println(err)
		return protocol.Response{ResponseCode: 1, Response: []byte("nft not found")}
	}
	if nft.OwnedBy != userId {
		return protocol.Response{ResponseCode: 1, Response: []byte("You must own an NFT to rename it.")}
	}
	nft.NftName = newName
	err = nftdb.UpdateNFT(db, nft)
	if err != nil {
		fmt.Println(err)
		return protocol.Response{ResponseCode: 1, Response: []byte("internal error")}
	}
	gamestate.UpdateGamestate()
	return protocol.Response{ResponseCode: 0}
}

func GetNFTLoc(db *sql.DB, userId uint32, nftId uint32) protocol.Response {
	nft, err := nftdb.GetNFT(db, nftId)
	if err != nil {
		fmt.Println(err)
		return protocol.Response{ResponseCode: 1, Response: []byte("nft not found")}
	}
	if nft.OwnedBy != userId {
		return protocol.Response{ResponseCode: 1, Response: []byte("You do not own this NFT")}
	}
	gamestate.UpdateGamestate()
	return protocol.Response{ResponseCode: 0, Response: []byte(nft.TrueLoc)}
}

func GetAllNFTS() {}
