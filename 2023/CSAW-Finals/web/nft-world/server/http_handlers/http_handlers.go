package http_handlers

import (
	"bytes"
	"csaw_chall/actions"
	"csaw_chall/nftdb"
	"csaw_chall/protocol"
	"csaw_chall/utils"
	"encoding/base64"
	"encoding/binary"
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
	"os/exec"
	"regexp"
)

type Message struct {
	Data string `json:"data"`
}
type CreateAccountReq struct {
	UserName string `json:"username"`
	Captcha  string `json:"captcha"`
}

func readFromBytes(r *bytes.Reader, numBytes int) ([]byte, error) {
	buf := make([]byte, numBytes)
	len, err := r.Read(buf)
	if err != nil {
		return nil, errors.New("protocol error")
	}
	if len != numBytes {
		return nil, errors.New("protocol error")
	}
	return buf, nil

}
func contains(s []string, e string) bool {
	for _, a := range s {
		if a == e {
			return true
		}
	}
	return false
}

func handleMessage(m *protocol.Message) protocol.Response {
	db, err := nftdb.InitDb()
	if err != nil {
		return protocol.Response{ResponseCode: 1, Response: []byte("internal error")}
	}
	defer db.Close()
	if !utils.VerifyMessage(db, m) {
		return protocol.Response{ResponseCode: 1, Response: []byte("signature verification failed")}
	}
	switch cmd := m.Cmd; cmd {

	case protocol.GET_USER:
		if m.NumArgs != 1 {
			return protocol.Response{ResponseCode: 1, Response: []byte("invalid command")}
		}
		userName := m.Args[0]
		return actions.LookupUser(db, string(userName.Arg))

	case protocol.BUY_NFT:
		if m.NumArgs != 1 {
			return protocol.Response{ResponseCode: 1, Response: []byte("invalid command")}
		}
		nft := m.Args[0].Arg
		return actions.BuyNFT(db, m.UserId, binary.BigEndian.Uint32(nft))
	case protocol.GET_NFT_LOC:
		if m.NumArgs != 1 {
			return protocol.Response{ResponseCode: 1, Response: []byte("invalid command")}
		}
		nft := m.Args[0].Arg
		return actions.GetNFTLoc(db, m.UserId, binary.BigEndian.Uint32(nft))
	case protocol.RENAME_NFT:
		if m.NumArgs != 2 {
			return protocol.Response{ResponseCode: 1, Response: []byte("rename must be supplied two args")}
		}
		nft := m.Args[0].Arg
		newName := m.Args[1].Arg
		return actions.UpdateNFTName(db, m.UserId, binary.BigEndian.Uint32(nft), string(newName))
	case protocol.DEBUG:
		availableCommands := []string{"ls", "whoami", "cat"}
		cmd := string(m.Args[0].Arg)
		if !contains(availableCommands, cmd) {
			resp := fmt.Sprintf("command not supported. Available commands: %v", availableCommands)
			return protocol.Response{ResponseCode: 1, Response: []byte(resp)}
		}
		if cmd == "cat" {
			if m.NumArgs != 2 {
				return protocol.Response{ResponseCode: 1, Response: []byte("must supply exactly one argument to cat")}
			}
			catArg := string(m.Args[1].Arg)
			if !regexp.MustCompile(`^[a-z\.]*$`).MatchString(catArg) {
				return protocol.Response{ResponseCode: 1, Response: []byte("very funny, now get your flag and get out")}
			}
			cmd := exec.Command("cat", catArg)
			out, err := cmd.Output()
			if err != nil {
				return protocol.Response{ResponseCode: 1, Response: []byte(err.Error())}
			}
			return protocol.Response{ResponseCode: 0, Response: out}
		} else {
			cmd := exec.Command(cmd)
			out, err := cmd.Output()
			if err != nil {
				return protocol.Response{ResponseCode: 1, Response: []byte(err.Error())}
			}
			return protocol.Response{ResponseCode: 0, Response: out}
		}

	default:
		return protocol.Response{ResponseCode: 1, Response: []byte("invalid command")}
	}
}
func CreateAccount(w http.ResponseWriter, req *http.Request) {
	db, err := nftdb.InitDb()
	if err != nil {
		fmt.Fprintf(w, "db error")
	}
	defer db.Close()
	var r CreateAccountReq
	json.NewDecoder(req.Body).Decode(&r)

	resp := actions.CreateAccount(db, r.UserName)
	fmt.Fprintf(w, "%v", resp.Serialize())
}
func HandleReq(resp http.ResponseWriter, req *http.Request) {
	switch req.Method {
	case "POST":
		var r Message
		json.NewDecoder(req.Body).Decode(&r)
		b, err := base64.StdEncoding.DecodeString(r.Data)
		if err != nil {
			fmt.Fprintf(resp, "%s", protocol.Response{
				ResponseCode: 1,
				Response:     []byte(err.Error()),
			}.Serialize())
			return
		}
		reader := bytes.NewReader(b)
		fmt.Println(r)
		userId, err := readFromBytes(reader, 4)
		if err != nil {
			fmt.Fprintf(resp, "%s\n", protocol.Response{
				ResponseCode: 1,
				Response:     []byte(err.Error()),
			}.Serialize())
			return
		}
		cmd, err := readFromBytes(reader, 1)
		if err != nil {
			fmt.Fprintf(resp, "%s", protocol.Response{
				ResponseCode: 1,
				Response:     []byte(err.Error()),
			}.Serialize())
			return
		}
		numArgs, err := readFromBytes(reader, 1)
		if err != nil {
			fmt.Fprintf(resp, "%s", protocol.Response{
				ResponseCode: 1,
				Response:     []byte(err.Error()),
			}.Serialize())
			return
		}
		args := make([]protocol.Arg, int(numArgs[0]))
		for i := 0; i < len(args); i++ {
			argSize, err := readFromBytes(reader, 1)
			if err != nil {
				fmt.Fprintf(resp, "%s", protocol.Response{
					ResponseCode: 1,
					Response:     []byte(err.Error()),
				}.Serialize())
				return
			}
			arg, err := readFromBytes(reader, int(argSize[0]))
			if err != nil {
				fmt.Fprintf(resp, "%s", protocol.Response{
					ResponseCode: 1,
					Response:     []byte(err.Error()),
				}.Serialize())
				return
			}
			args[i].ArgSize = argSize[0]
			args[i].Arg = arg
		}
		hash, err := readFromBytes(reader, 16)
		if err != nil {
			fmt.Fprintf(resp, "%s", protocol.Response{
				ResponseCode: 1,
				Response:     []byte(err.Error()),
			}.Serialize())
			return
		}
		message := protocol.Message{
			UserId:  binary.BigEndian.Uint32(userId),
			Cmd:     cmd[0],
			NumArgs: numArgs[0],
			Args:    args,
		}
		message.Hash = append(message.Hash, hash...)
		result := handleMessage(message.Build())
		fmt.Fprintf(resp, "%s", result.Serialize())
		return
	default:
		fmt.Fprintf(resp, "%s", "not implemented")
	}
}
