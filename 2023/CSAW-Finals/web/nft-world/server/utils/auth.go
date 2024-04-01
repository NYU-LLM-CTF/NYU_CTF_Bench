package utils

import (
	"bytes"
	"crypto/aes"
	"crypto/cipher"
	"crypto/md5"
	"crypto/sha256"
	"csaw_chall/nftdb"
	"csaw_chall/protocol"
	"database/sql"
	"fmt"

	"golang.org/x/crypto/pbkdf2"
)

// AES-128 encryption
// key is userId + username + CreationTimestamp + padding
// admin userId is 0x00000000

func pkcs7pad(data []byte, blockSize int) ([]byte, error) {
	if blockSize <= 1 || blockSize >= 256 {
		return nil, fmt.Errorf("pkcs7: Invalid block size %d", blockSize)
	} else {
		padLen := blockSize - len(data)%blockSize
		padding := bytes.Repeat([]byte{byte(padLen)}, padLen)
		return append(data, padding...), nil
	}
}
func bytesRepeating(n int, b byte) []byte {
	bs := make([]byte, n)
	for i := range bs {
		bs[i] = b
	}
	return bs
}

func deriveKey(passPhrase []byte, salt []byte) []byte {
	if salt == nil {
		salt = make([]byte, 4)
		// http://www.ietf.org/rfc/rfc2898.txt
		// Salt.
	}
	return pbkdf2.Key(passPhrase, salt, 100, 32, sha256.New)

}
func VerifyMessage(db *sql.DB, m *protocol.Message) bool {

	user, err := nftdb.GetUser(db, m.UserId)
	if err != nil {
		fmt.Println(err.Error())
		return false
	}
	user.Print()

	message, originalHash := m.GetBytes()
	padText, err := pkcs7pad(message, aes.BlockSize)
	if err != nil {
		fmt.Println(err.Error())
		return false
	}

	passPhrase := []byte(fmt.Sprintf("%d", user.CreatedAt))
	key := deriveKey(passPhrase, nil)

	block, err := aes.NewCipher(key)
	if err != nil {
		fmt.Println(err.Error())
		return false
	}

	iv := make([]byte, aes.BlockSize)

	stream := cipher.NewCFBEncrypter(block, iv)
	cipherText := make([]byte, len(padText))
	stream.XORKeyStream(cipherText, padText)

	computedHash := md5.Sum(cipherText)
	if !bytes.Equal(originalHash, computedHash[0:16]) {
		return false
	}

	return true
}
