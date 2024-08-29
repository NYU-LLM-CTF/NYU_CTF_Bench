package src

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"
	"time"
)

type MainStateT struct {
	Namespaces   map[string]FileNamespace
	ChunkServers map[string]ChunkServer
}

type ChunkServerStateT struct {
	MainAddress     string
	Chunks          []FileChunk
	LocalAddress    string // Cluster address
	ExternalAddress string // Externally accessable address
	ChunkPath       string
}

// Global state variables
var (
	ChunkSize    int = 12
	ReplicaCount int = 5
	APIKey       string
	OriginalMain string
	StartTime    = time.Now()
)

// Initialize main state
func InitMainState() *MainStateT {
	var mainState MainStateT
	if _, err := os.Stat("MainState.json"); os.IsNotExist(err) {
		mainState = MainStateT{
			Namespaces: map[string]FileNamespace{
				"Public": {
					Name:  "Public",
					Files: make(map[string]File),
				},
				"Private": {
					Name:  "Private",
					Files: make(map[string]File),
				},
			},
			ChunkServers: map[string]ChunkServer{},
		}

		DumpMainState(mainState)
	} else {
		mainStateP, _ := LoadMainState()
		mainState = *mainStateP
	}

	return &mainState
}

// Initialize chunkserver state
func InitChunkServerState(mainAddress string, localAddress string, externalAddress string, chunkPath string) *ChunkServerStateT {
	var chunkServerState ChunkServerStateT
	if _, err := os.Stat("ChunkServerState.json"); os.IsNotExist(err) {
		chunkServerState = ChunkServerStateT{
			MainAddress:     mainAddress,
			LocalAddress:    localAddress,
			ExternalAddress: externalAddress,
			Chunks:          []FileChunk{},
			ChunkPath:       chunkPath,
		}
		DumpChunkServerState(chunkServerState)
	} else {
		chunkServerStateP, _ := LoadChunkServerState()
		chunkServerState = *chunkServerStateP
	}

	// Create the chunk path directory if it doesn't exist
	_, err := os.Stat(chunkServerState.ChunkPath)
	if os.IsNotExist(err) {
		_ = os.Mkdir(chunkServerState.ChunkPath, 0755)
	}

	OriginalMain = mainAddress

	return &chunkServerState
}

func LoadMainState() (*MainStateT, error) {
	var mainState MainStateT
	data, err := ioutil.ReadFile("MainState.json")
	if err != nil {
		return nil, err
	}

	err = json.Unmarshal(data, &mainState)
	if err != nil {
		return nil, err
	}

	return &mainState, nil
}

func DumpMainState(mainState MainStateT) {
	fileData, _ := json.MarshalIndent(mainState, "", " ")
	_ = ioutil.WriteFile(
		"MainState.json",
		fileData, 0644)
}

func LoadChunkServerState() (*ChunkServerStateT, error) {
	var chunkServerState ChunkServerStateT
	data, err := ioutil.ReadFile("ChunkServerState.json")
	if err != nil {
		return nil, err
	}

	err = json.Unmarshal(data, &chunkServerState)
	if err != nil {
		fmt.Println(err)
		return nil, err
	}

	return &chunkServerState, nil
}

func DumpChunkServerState(chunkServerState ChunkServerStateT) {
	fileData, _ := json.MarshalIndent(chunkServerState, "", " ")
	_ = ioutil.WriteFile(
		"ChunkServerState.json",
		fileData, 0644)
}
