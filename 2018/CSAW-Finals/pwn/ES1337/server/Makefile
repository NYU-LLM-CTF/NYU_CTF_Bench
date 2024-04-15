OS := $(shell uname -s)
ARCH := $(shell uname -m)

GODIR = go-$(ARCH)-$(OS)

export GOPATH = $(shell pwd)/.gopath

.gopath:
	mkdir -p .gopath/src/github.com/itszn
	ln -s ../../../.. .gopath/src/github.com/itszn/v8server

$(GOPATH)/gotdeps:
	cd .gopath/src/github.com/itszn/v8server && sh -c "go get"
	touch $(GOPATH)/gotdeps

.PHONY: server
server: .gopath $(GOPATH)/gotdeps
	sh -c "go build -o v8server"

docker/read_flag: read_flag/read_flag.c
	gcc -o docker/read_flag read_flag/read_flag.c --static

.DEFAULT_GOAL := server

all: server

