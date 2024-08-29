package nftdb

import (
	"csaw_chall/protocol"
	"database/sql"
	"errors"
	"fmt"
	"os"

	_ "github.com/go-sql-driver/mysql"
)

func InitDb() (*sql.DB, error) {
	env := os.Getenv("SERVER_ENV")
	var (
		sqlUser string
		sqlPass string
		host    string
		port    int
	)
	if env == "prod" {
		host = "nft.db"
		sqlUser = "root"
		sqlPass = "password"
		port = 3306
	} else {
		host = "localhost"
		sqlUser = "root"
		sqlPass = "password"
		port = 3306
	}
	url := fmt.Sprintf("%s:%s@tcp(%s:%d)/csaw_chall", sqlUser, sqlPass, host, port)
	return sql.Open("mysql", url)
}

func CloseDatabase(db *sql.DB) {
	defer db.Close()
}

func GetAllUsers(db *sql.DB) ([]*protocol.User, error) {
	rows, err := db.Query(`
		SELECT 
			id,
			UNIX_TIMESTAMP(created_at),
			user_name,
			account_balance
		FROM users`)
	if err != nil {
		fmt.Println(err)
		return nil, err
	}
	users := make([]*protocol.User, 0)
	for rows.Next() {
		user := &protocol.User{}
		err := rows.Scan(&user.Id, &user.CreatedAt, &user.UserName, &user.AccountBalance)
		if err != nil {
			fmt.Println(err)
			return nil, err
		}
		users = append(users, user)
	}
	return users, nil
}

func AddUser(db *sql.DB, username string, initBalance float32) (uint32, error) {

	q := `
		INSERT INTO users VALUES(NULL, NOW(), ?, ?)`
	statement, err := db.Prepare(q)
	if err != nil {
		return 0, err
	}
	rows, err := statement.Exec(username, initBalance)
	if err != nil {
		return 0, err
	}
	userId, err := rows.LastInsertId()
	return uint32(userId), err
}

func GetUser(db *sql.DB, userId uint32) (*protocol.User, error) {
	q := `
		SELECT id, UNIX_TIMESTAMP(created_at), user_name, account_balance FROM users WHERE id = ?
	`
	statement, err := db.Prepare(q)
	if err != nil {
		return nil, err
	}
	rows, err := statement.Query(userId)
	if err != nil {
		return nil, err
	}
	res := &protocol.User{}
	for rows.Next() {
		err = rows.Scan(&res.Id, &res.CreatedAt, &res.UserName, &res.AccountBalance)
		if err != nil {
			return nil, err
		}
	}
	return res, nil
}
func GetUserByName(db *sql.DB, username string) (*protocol.User, error) {
	q := `
		SELECT id, UNIX_TIMESTAMP(created_at), user_name, account_balance FROM users WHERE user_name = ?
	`
	statement, err := db.Prepare(q)
	if err != nil {
		return nil, err
	}
	rows, err := statement.Query(username)
	if err != nil {
		return nil, err
	}
	res := &protocol.User{}
	for rows.Next() {
		err = rows.Scan(&res.Id, &res.CreatedAt, &res.UserName, &res.AccountBalance)
		if err != nil {
			return nil, err
		}
	}
	return res, nil
}

func UpdateUser(db *sql.DB, user *protocol.User) error {
	q := `
		UPDATE users 
		SET account_balance = ?, user_name = ?
		WHERE id = ?
		`
	statement, err := db.Prepare(q)
	if err != nil {
		return err
	}
	rows, err := statement.Exec(user.AccountBalance, user.UserName, user.Id)
	if err != nil {
		return err
	}
	numRowsAffected, err := rows.RowsAffected()
	if err != nil {
		return err
	}
	if numRowsAffected != 1 {
		return errors.New("something is wrong")
	}
	return nil
}

func GetNFT(db *sql.DB, nftId uint32) (*protocol.Nft, error) {
	q := `
		SELECT id, nft_name, preview_loc, true_loc, price, owned_by_id, owned_by_name FROM nfts WHERE id = ?
		`
	statement, err := db.Prepare(q)
	if err != nil {
		return nil, err
	}
	rows, err := statement.Query(nftId)
	if err != nil {
		return nil, err
	}
	res := &protocol.Nft{}
	for rows.Next() {
		err = rows.Scan(&res.Id, &res.NftName, &res.PreviewLoc, &res.TrueLoc, &res.Price, &res.OwnedBy, &res.OwnedByName)
		if err != nil {
			return nil, err
		}

	}
	return res, nil
}

func UpdateNFT(db *sql.DB, nft *protocol.Nft) error {
	q := `
		UPDATE nfts 
		SET 
			nft_name = ?,
			price = ?,
			owned_by_id = ?,
			owned_by_name = ?
		WHERE id = ?
		`
	statement, err := db.Prepare(q)
	if err != nil {
		return err
	}
	rows, err := statement.Exec(nft.NftName, nft.Price, nft.OwnedBy, nft.OwnedByName, nft.Id)
	if err != nil {
		return err
	}
	numRowsAffected, err := rows.RowsAffected()
	if err != nil {
		return err
	}
	if numRowsAffected != 1 {
		return errors.New("something is wrong")
	}
	return nil
}

func GetAllNfts(db *sql.DB) ([]*protocol.Nft, error) {
	q := `SELECT * FROM nfts`
	statement, err := db.Prepare(q)
	if err != nil {
		return nil, err
	}
	rows, err := statement.Query()
	if err != nil {
		return nil, err
	}
	res := []*protocol.Nft{}
	for rows.Next() {
		nft := &protocol.Nft{}
		err = rows.Scan(&nft.Id, &nft.NftName, &nft.PreviewLoc, &nft.TrueLoc, &nft.Price, &nft.OwnedBy, &nft.OwnedByName)
		if err != nil {
			return nil, err
		}
		res = append(res, nft)

	}
	return res, nil

}
