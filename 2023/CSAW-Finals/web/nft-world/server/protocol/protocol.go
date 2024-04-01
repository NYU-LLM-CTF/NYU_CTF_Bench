package protocol

import (
	"encoding/base64"
	"encoding/binary"
	"fmt"
)

type Arg struct {
	ArgSize uint8
	Arg     []byte
}

type Message struct {
	UserId  uint32
	Cmd     uint8
	NumArgs uint8
	Args    []Arg
	Hash    []byte
}

func (m Message) Build() *Message {
	return &Message{
		UserId:  m.UserId,
		Cmd:     m.Cmd,
		NumArgs: m.NumArgs,
		Args:    m.Args,
		Hash:    m.Hash,
	}
}

func (m Message) GetBytes() (message []byte, hash []byte) {
	var result []byte
	result = binary.BigEndian.AppendUint32(result, m.UserId)
	result = append(result, m.Cmd)
	result = append(result, m.NumArgs)
	for i := 0; i < int(m.NumArgs); i++ {
		result = append(result, m.Args[i].ArgSize)
		result = append(result, m.Args[i].Arg...)
	}
	return result, m.Hash
}

func (m Message) Print() {
	fmt.Printf("\n  Uid => %d", m.UserId)
	fmt.Printf("\n  cmd => %d", m.Cmd)
	fmt.Printf("\n  numArgs => %d", m.NumArgs)

	for i := 0; i < int(m.NumArgs); i++ {
		m.Args[i].Print()
	}
	fmt.Printf("\n  hash => %x", m.Hash)
	fmt.Println()

}

type User struct {
	Id             uint32
	CreatedAt      uint32
	UserName       string
	AccountBalance float32
}

type Nft struct {
	Id          uint32  `json:"id"`
	NftName     string  `json:"name"`
	PreviewLoc  string  `json:"preview_loc"`
	TrueLoc     string  `json:"true_loc"`
	Price       float32 `json:"price"`
	OwnedBy     uint32  `json:"owned_by"`
	OwnedByName string  `json:"owned_by_name"`
}

type Response struct {
	ResponseCode byte
	Response     []byte
}

func (r Response) Serialize() string {
	var result []byte
	result = append(result, r.ResponseCode)
	result = append(result, byte(len(r.Response)))
	result = append(result, r.Response...)
	return base64.StdEncoding.EncodeToString(result)
}

func (a Arg) Print() {
	fmt.Printf("\n  ArgSize => %d", a.ArgSize)
	fmt.Printf("\n  Arg => %s", a.Arg)
}

func (u User) Build() *User {
	return &User{}
}

func (u User) Print() {
	fmt.Printf(
		"\nUser: \nid => %d\ncreatedAt => %d\nuserName => %s\naccountBalance => %f\n\n",
		u.Id,
		u.CreatedAt,
		u.UserName,
		u.AccountBalance,
	)
}

func (n Nft) Print() {
	fmt.Printf(
		"\nNFT: \nid => %d\nName => %s\nPreviewLoc => %s\nTrueLoc => %s\nPrice => %f\nOwnedBy => %d\n\n",
		n.Id,
		n.NftName,
		n.PreviewLoc,
		n.TrueLoc,
		n.Price,
		n.OwnedBy,
	)

}
