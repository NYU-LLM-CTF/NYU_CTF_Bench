package main

import (
	"bytes"
	"html/template"
	"io"
	"io/ioutil"
	"log"
	"net/http"

	"github.com/buger/jsonparser"
	"github.com/gorilla/mux"
)

var templates = template.Must(template.ParseFiles("index.html"))
var files []map[string]interface{}
var requestURL = "http://localhost:8000"

func retrieveFile(w http.ResponseWriter, r *http.Request) {
	data, err := io.ReadAll(r.Body)
	if err != nil {
		panic(err)
	}

	fn, err := jsonparser.GetString(data, "filename")
	if err != nil {
		panic(err)
	}

	subject, err := jsonparser.GetString(data, "subject")

	if err != nil {
		panic(err)
	}

	check := false

	// check for existing files
	for _, m := range files {
		if (m["filename"] == fn) && (m["subject"] == subject) {
			check = true
		}
	}

	if check {
		bodyReader := bytes.NewReader(data)
		res, err := http.Post(requestURL+"/retrieve", "application/json", bodyReader)
		if err != nil {
			panic(err)
		}
		resBody, err := ioutil.ReadAll(res.Body)
		if err != nil {
			panic(err)
		}
		w.Write(resBody)
	} else {
		w.Write([]byte("homework not found :("))
	}
}

// retrieves available homeworks on the server
func getHomeworks() {

	res, err := http.Get(requestURL + "/directory")
	if err != nil {
		panic(err)
	}

	resBody, err := ioutil.ReadAll(res.Body)
	if err != nil {
		panic(err)
	}

	jsonparser.ArrayEach(resBody, func(value []byte, dataType jsonparser.ValueType, offset int, err error) {
		m := make(map[string]interface{})
		m["filename"], _ = jsonparser.GetString(value, "filename")
		m["subject"], _ = jsonparser.GetString(value, "subject")
		files = append(files, m)
	})
}

func index(w http.ResponseWriter, r *http.Request) {

	var err = templates.ExecuteTemplate(w, "index.html", files)
	if err != nil {
		panic(err)
	}
}

func main() {
	getHomeworks()

	r := mux.NewRouter()
	r.HandleFunc("/", index)
	r.HandleFunc("/homework", retrieveFile)
	log.Fatal(http.ListenAndServe(":1234", r))
}
