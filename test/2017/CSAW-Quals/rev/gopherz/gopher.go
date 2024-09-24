package main

import (
	"log"
	"net"
	"bufio"
)


type GopherServer struct {}

func (s *GopherServer) Run(listenAddr string) error {
	ln, err := net.Listen("tcp", listenAddr)
	defer ln.Close()

	if err != nil {
		return err
	}

	for {
		conn, err := ln.Accept()
		if err != nil {
			// Handle err
		}

		go s.handleRequest(conn)
	}

	return nil
}

func caterpillar() string {
	return "icaterpillars grow\r\n.\r\n"
}

func butterfly() string {
	return "ibutterflies fly\r\n.\r\n"
}

func index() string {
	return "igophers rule\r\n1caterpillar\t/caterpillar\treversing.chal.csaw.io\t7070\r\n1butterfly\t/butterfly\treversing.chal.csaw.io\t7070\r\n.\r\n"
}

func (s *GopherServer) Route(value string) string {
	if value == "2668" {
		return caterpillar()
	}

	if value == "457872149190039938449409450797259650244955817397381468272138729997481631896039607738236" {
		return butterfly()
	}

	return "3\r\n"
}


func (s *GopherServer) handleRequest(conn net.Conn) error {
	reader := bufio.NewReader(conn)
	req, err := reader.ReadString('\n')
	if err != nil {
		return err
	}
	if req == "\r\n" {
		conn.Write([]byte(index()))
	} else {
		swiz := Swizzle(req[1:])
		conn.Write([]byte(s.Route(swiz)))
	}
	conn.Close()
	return nil
}

func main() {
	server := new(GopherServer)
	err := server.Run("0.0.0.0:7070")
	if err != nil {
		log.Fatal(err)
	}
}
