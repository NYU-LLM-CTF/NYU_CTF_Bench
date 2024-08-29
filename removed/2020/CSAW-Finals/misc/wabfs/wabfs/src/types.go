package src

type ChunkServer struct {
	LocalAddress    string
	ExternalAddress string
	Available       bool
	Chunks          []string // ChunkIds
}

type FileNamespace struct {
	Name  string
	Files map[string]File
}

type ChunkReplica struct {
	ExternalAddress string // ChunkServer address
	LocalAddress    string // ChunkServer address
	Healthy         bool   // Whether it was broadcasted successfully
}

type FileChunk struct {
	FileId   string
	Id       string
	Seq      int
	Replicas []ChunkReplica
}

type File struct {
	Filename  string
	Namespace string
	Id        string
	Chunks    []FileChunk
}

type Chunk struct {
	FileChunk FileChunk
	Namespace string
	Data      string // base64 encoded data
}
