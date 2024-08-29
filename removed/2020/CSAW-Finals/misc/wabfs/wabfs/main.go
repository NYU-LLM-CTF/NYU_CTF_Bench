package main

import (
	"flag"
	"fmt"
	"github.com/gin-gonic/gin"
	"wabfs/src"
)

func main() {
	// Load apikey from args
	var (
		apikey          string
		mainAddress     string
		localAddress    string
		externalAddress string
		chunkPath       string
		port            string
		isMain          bool
	)
	flag.StringVar(&apikey, "key", "", "apikey")
	flag.StringVar(&mainAddress, "mainAddress", "", "address of main server")
	flag.StringVar(&localAddress, "localAddress", "", "local address of server")
	flag.StringVar(&externalAddress, "externalAddress", "", "external address of server")
	flag.StringVar(&chunkPath, "chunkPath", ".chunks", "path to chunk storage")
	flag.StringVar(&port, "port", "5000", "port for server to listen on")
	flag.BoolVar(&isMain, "main", false, "")
	flag.Parse()

	fmt.Printf("Starting with APIKEY=%s\n", apikey)
	if isMain {
		fmt.Println("Starting as main server")
	} else {
		fmt.Println("Starting as chunk server")
		fmt.Printf("MainAddress=%s\n", mainAddress)
	}

	// Initialize state
	src.APIKey = apikey

	/////////////////////////////////////////////////////
	// Gin setup
	// Gimme that pretty output
	gin.ForceConsoleColor()
	router := gin.Default()
	router.MaxMultipartMemory = 8 << 20 // 8 MiB

	// Add ping for health checks
	router.GET("/ping", func(context *gin.Context) {
		context.String(200, "pong\n")
	})

	if isMain {
		// Add mainAPI group
		mainAPI := router.Group("/main")
		src.InitMainApi(mainAPI)
	} else {
		// Add chunkServerAPI
		chunkServerAPI := router.Group("/chunkserver")
		src.InitChunkServerApi(chunkServerAPI, mainAddress, localAddress, externalAddress, chunkPath)

		// Join main
		src.JoinMain()
	}
	/////////////////////////////////////////////////////

	_ = router.Run("0.0.0.0:" + port)
}
