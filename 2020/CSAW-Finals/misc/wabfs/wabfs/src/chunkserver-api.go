package src

import (
	"encoding/hex"
	"encoding/json"
	"fmt"
	"github.com/gin-gonic/gin"
	"io/ioutil"
	"os"
	"path"
	"time"
)

// Attempt to join cluster via main
func JoinMain() {
	chunkServerState, _ := LoadChunkServerState()

	body := struct {
		LocalAddress    string
		ExternalAddress string
	}{
		LocalAddress:    chunkServerState.LocalAddress,
		ExternalAddress: chunkServerState.ExternalAddress,
	}

	resp, err := PostJSON(
		chunkServerState.MainAddress+"/main/join", body,
		map[string]string{"APIKEY": APIKey},
	)

	// Table flip moment if we can't join the cluster
	if err != nil || resp.StatusCode != 200 {
		fmt.Println("Unable to join main")
		os.Exit(1)
	}

	fmt.Println("Successfully joined main")
}

func InitChunkServerApi(api *gin.RouterGroup, mainAddress string, localAddress string, externalAddress string, chunkPath string) {
	InitChunkServerState(mainAddress, localAddress, externalAddress, chunkPath)

	// main will hit this route when it wants to replicate a chunk on current node
	api.POST("/replica", func(context *gin.Context) {
		if !checkAPIKey(context) {
			return
		}
		chunkServerState, _ := LoadChunkServerState()

		var body Chunk

		if context.BindJSON(&body) != nil {
			fmt.Println(body)
			context.String(406, "unable to parse request")
			return
		}

		fileData, _ := json.MarshalIndent(body, "", " ")
		_ = ioutil.WriteFile(
			chunkServerState.ChunkPath+"/"+body.FileChunk.Id+".json",
			fileData, 0644)

		context.String(200, "Success\n")
	})

	// Read a chunk from a namespace
	api.GET("/read/:namespace/:chunkId", func(context *gin.Context) {
		rawChunkId := context.Param("chunkId")
		namespace := context.Param("namespace")
		userAPIKey := context.Request.Header.Get("APIKEY")
		chunkServerState, _ := LoadChunkServerState()

		// Make sure provided chunk id is base 16
		_, err := hex.DecodeString(rawChunkId)
		if err != nil {
			context.String(406, "ChunkID is not hex")
			return
		}

		filePath := chunkServerState.ChunkPath + "/" + path.Clean(rawChunkId) + ".json"

		_, err = os.Stat(filePath)
		if os.IsNotExist(err) {
			context.String(406, "Chunk not found")
			return
		}

		data, err := ioutil.ReadFile(filePath)
		if err != nil {
			context.String(406, "Unable to open chunk file")
			return
		}

		var chunk Chunk
		err = json.Unmarshal(data, &chunk)

		if err != nil {
			context.String(406, "Unable to parse chunk file")
			return
		}

		// Authenticate read with main
		res, err := PostJSON(chunkServerState.MainAddress+"/main/authenticate-read", struct {
			FileId    string
			ChunkId   string
			APIKey    string
			Namespace string
		}{
			FileId:    chunk.FileChunk.FileId,
			ChunkId:   chunk.FileChunk.Id,
			APIKey:    userAPIKey,
			Namespace: namespace,
		}, map[string]string{})

		if err != nil {
			context.String(400, "Error authenticating")
			return
		}

		if res.StatusCode != 200 {
			context.String(401, "Unable to authenticate request with main")
			return
		}

		context.JSON(200, chunk)
	})

	// In gfs, they have to deal with main going down.
	// Other chunkservers can hit this to reach quarum
	// on which node is main.
	api.POST("/new-main", func(context *gin.Context) {
		if StartTime.Add(time.Second * 10).After(time.Now()) {
			return
		}

		chunkServerState, _ := LoadChunkServerState()

		body := struct {
			Address string
			APIKey  string
		}{}

		if context.BindJSON(&body) != nil {
			context.String(406, "Unable to parse request")
			return
		}

		go TestMain()

		chunkServerState.MainAddress = body.Address
		DumpChunkServerState(*chunkServerState)

		context.String(200, "Testing main")
	})
}
