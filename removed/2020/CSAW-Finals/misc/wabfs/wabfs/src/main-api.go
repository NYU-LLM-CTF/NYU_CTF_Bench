package src

import (
	"crypto/sha256"
	"encoding/hex"
	"fmt"
	"github.com/gin-gonic/gin"
	"math/rand"
	"net/http"
)

func InitMainApi(mainAPI *gin.RouterGroup) {
	// Initialize main state
	InitMainState()

	// Authenticate chunkserver reads
	mainAPI.POST("/authenticate-read", func(context *gin.Context) {
		body := struct {
			FileId    string
			ChunkId   string
			APIKey    string
			Namespace string
		}{}

		mainState, _ := LoadMainState()

		if context.BindJSON(&body) != nil {
			context.String(406, "unable to parse request")
			return
		}

		namespace, exists := mainState.Namespaces[body.Namespace]
		if !exists {
			context.String(406, "Namespace not found")
			return
		}
		fmt.Println("YEET")

		file, exists := namespace.Files[body.FileId]
		if !exists {
			context.String(406, "FileId not found")
			return
		}

		fileChunk := FileChunk{Id: "-1"}
		for _, chunk := range file.Chunks {
			if chunk.Id == body.ChunkId {
				fileChunk = chunk
				break
			}
		}

		if fileChunk.Id == "-1" {
			context.String(406, "Chunk not found")
			return
		}

		// APIKEY only necessary for private reads
		if file.Namespace == "Private" && body.APIKey != APIKey {
			context.String(406, "APIKEY required for Private namespace")
			return
		}

		context.String(200, "Success")

	})

	// Chunkservers can join the cluster by hitting this
	mainAPI.POST("/join", func(context *gin.Context) {
		if !checkAPIKey(context) {
			return
		}

		mainState, _ := LoadMainState()

		body := struct {
			LocalAddress    string
			ExternalAddress string
		}{}

		if context.BindJSON(&body) != nil {
			fmt.Println(body)
			context.String(406, "unable to parse request")
			return
		}

		mainState.ChunkServers[body.LocalAddress] = ChunkServer{
			LocalAddress:    body.LocalAddress,
			ExternalAddress: body.ExternalAddress,
			Available:       true,
			Chunks:          []string{},
		}

		DumpMainState(*mainState)

		context.String(200, "Success")
	})

	// List availible chunkservers
	mainAPI.GET("/chunkservers", func(context *gin.Context) {
		userAPIKey := context.Request.Header.Get("APIKEY")
		mainState, _ := LoadMainState()
		if userAPIKey != APIKey {
			context.String(200, "Wrong APIKEY provided")
			return
		}

		context.JSON(200, mainState.ChunkServers)
	})

	// List files for a given namespace
	mainAPI.GET("/files/:namespace", func(context *gin.Context) {
		selectedNamespace := context.Param("namespace")
		mainState, _ := LoadMainState()
		namespace, exists := mainState.Namespaces[selectedNamespace]

		// Make sure it exists
		if !exists {
			context.JSON(200, gin.H{
				"error": "Not found",
			})
			return
		}

		// Set namespace
		context.JSON(200, gin.H{
			"namespace": namespace.Name,
			"files":     namespace.Files,
		})
	})

	// Upload and replicate a file
	mainAPI.POST("/upload/:namespace/:filename", func(context *gin.Context) {
		// Verify APIKEY
		userAPIKey := context.Request.Header.Get("APIKEY")
		if userAPIKey != APIKey {
			context.String(200, "Wrong APIKEY provided")
			return
		}
		mainState, _ := LoadMainState()

		// Load and verify filename
		filename := context.Param("filename")
		if len(filename) == 0 {
			context.String(406, "Filename Not Specified")
			return
		}

		// Load namespace
		selectedNamespace := context.Param("namespace")
		namespace, exists := mainState.Namespaces[selectedNamespace]

		// Make sure namespace exists
		if !exists {
			context.JSON(406, gin.H{
				"error": "Namespace Not found",
			})
			return
		}

		// Max f data size 8 MB
		data := make([]byte, 8<<20)

		// Create seed with random data
		seed := make([]byte, 64)
		rand.Read(seed)
		h := sha256.New()
		h.Write(seed)

		// Get file
		f, _, err := context.Request.FormFile("file")
		if err != nil {
			context.String(http.StatusBadRequest, fmt.Sprintf("get form err: %s", err.Error()))
			return
		}

		// Read file buffer
		n, err := f.Read(data)
		if err != nil {
			context.String(http.StatusBadRequest, fmt.Sprintf("f read err: %s", err.Error()))
			return
		}

		// Init file
		file := File{
			Filename:  filename,
			Namespace: namespace.Name,
			Id:        hex.EncodeToString(h.Sum(nil)),
			Chunks:    make([]FileChunk, n/ChunkSize),
		}

		// Push the file out to the chunkservers
		file = *broadcastFile(&file, &data, n, &h)

		namespace.Files[file.Id] = file
		mainState.Namespaces[selectedNamespace] = namespace

		DumpMainState(*mainState)

		context.JSON(200, file)
	})
}
