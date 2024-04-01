package main

import (
	"os"
	"path/filepath"
	"time"

	"csaw_chall/gamestate"
	"csaw_chall/http_handlers"
	"fmt"
	"net/http"
)

type NoListFile struct {
	http.File
}

func (f NoListFile) Readdir(count int) ([]os.FileInfo, error) {
	return nil, nil
}

type NoListFileSystem struct {
	base http.FileSystem
}

func (fs NoListFileSystem) Open(name string) (http.File, error) {
	f, err := fs.base.Open(name)
	if err != nil {
		return nil, err
	}
	return NoListFile{f}, nil
}
func updateGamestate() {
	for {
		err := gamestate.UpdateGamestate()
		if err != nil {
			fmt.Println(err)
		}
		time.Sleep(30 * time.Second)
	}

}
func main() {
	go updateGamestate()
	http.HandleFunc("/cmd", http_handlers.HandleReq)
	http.HandleFunc("/create_account", http_handlers.CreateAccount)
	path, err := os.Getwd()
	if err != nil {
		fmt.Println(err.Error())
		return
	}

	fs := NoListFileSystem{http.Dir(path)}
	http.Handle("/static/", http.FileServer(fs))

	path = filepath.Join(path, "dist")
	http.Handle("/", http.FileServer(http.Dir(path)))
	if err := http.ListenAndServe(":3333", nil); err != nil {
		fmt.Println(err)
		return
	}

}
