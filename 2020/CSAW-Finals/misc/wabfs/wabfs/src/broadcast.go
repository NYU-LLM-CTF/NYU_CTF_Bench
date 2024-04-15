package src

import (
	"bytes"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"hash"
	"math/rand"
	"net/http"
)

// Replicate chunk to chunkservers
func broadcastChunk(fileChunk *FileChunk, chunk *[]byte, namespace string) {
	mainState, _ := LoadMainState()
	chunkServers := []ChunkServer{}
	for _, chunkServer := range mainState.ChunkServers {
		chunkServers = append(chunkServers, chunkServer)
	}

	body := Chunk{
		FileChunk: *fileChunk,
		Namespace: namespace,
		Data:      hex.EncodeToString(*chunk),
	}

	payloadBuf := new(bytes.Buffer)
	_ = json.NewEncoder(payloadBuf).Encode(body)

	startIdx := rand.Intn(len(chunkServers))
	for i := 0; i < ReplicaCount; i++ {
		replica := ChunkReplica{
			ExternalAddress: chunkServers[(startIdx+i)%len(chunkServers)].ExternalAddress,
			LocalAddress:    chunkServers[(startIdx+i)%len(chunkServers)].LocalAddress,
			Healthy:         true,
		}

		_, err := PostJSON(replica.LocalAddress+"/chunkserver/replica", body, map[string]string{"APIKEY": APIKey})
		if err != nil {
			fmt.Println("Failed to propagate chunk")
			replica.Healthy = false
		}

		fileChunk.Replicas = append(fileChunk.Replicas, replica)
	}
}

// Split file into chunks then broadcast replicas
func broadcastFile(file *File, data *[]byte, n int, h *hash.Hash) *File {
	// Broadcast chunks
	for chunkIndex := 0; chunkIndex < n/ChunkSize; chunkIndex++ {
		// Calculate chunk start and end indices
		chunkStart := chunkIndex * ChunkSize
		chunkEnd := (chunkIndex + 1) * ChunkSize

		// Get chunk splice
		chunk := (*data)[chunkStart:chunkEnd]

		// Hash chunk
		(*h).Write(chunk)
		sum := hex.EncodeToString((*h).Sum(nil))

		// Create FileChunk
		fileChunk := FileChunk{
			FileId: file.Id,
			Id:     sum,
			Seq:    chunkIndex,
		}

		// Push that chunk out
		broadcastChunk(&fileChunk, &chunk, file.Namespace)

		// Add to global state
		file.Chunks[chunkIndex] = fileChunk
	}

	return file
}

func TestMain() bool {
	res, err := http.Get(OriginalMain + "/ping")
	if err != nil {
		return false
	}

	if res.StatusCode != 200 {
		return false
	}

	chunkServerState, err := LoadChunkServerState()
	if err != nil {
		go TestMain()
		return false
	}
	chunkServerState.MainAddress = OriginalMain
	DumpChunkServerState(*chunkServerState)

	return true
}
