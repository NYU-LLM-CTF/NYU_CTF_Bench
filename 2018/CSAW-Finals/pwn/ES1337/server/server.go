//
// Original Code Copyright (c) 2017 Samuel Groß
//

package main

import (
	"bufio"
	"bytes"
	"context"
	"crypto/rand"
	"crypto/sha256"
	//"encoding/binary"
	"encoding/hex"
	"errors"
	"fmt"
	"github.com/docker/docker/api/types"
	"github.com/docker/docker/api/types/container"
	dockerapi "github.com/docker/docker/client"
	"log"
	//"math"
	"math/big"
	"net"
	"net/url"
	"os"
	"os/exec"
	//"strconv"
	"strings"
	"time"
)

type Client = bufio.ReadWriter

const (
	host = "0.0.0.0"
	port = "1337"

	containerTimeout  = 120 // in seconds
	connectionTimeout = 30 * time.Minute

	powHardness = 24 // number of leading zero bits in a sha256 hash
	//powHardness = 16 // number of leading zero bits in a sha256 hash

	greeting = `
	Welcome to pwn2csaw!

As you are not onsite we'll have to do things this way:

We are running the modified version of up-to-date v8. The patch, compiled binary, and dockerfile are included with the challenge.

Once you have your exploit ready:
	* You solve our proof of work
	* You give us your url
	* We'll run chrome in the container like this:
		/release/chrome --headless --disable-gpu --no-sandbox --virtual-time-budget=60000 <your_url>
	* You grab the flag by running /read_flag in the container

You have %d seconds to run your exploit.

Right now there are %d users ahead of you.
`
)

var (
	workdir   string
	workQueue chan string
	docker    *dockerapi.Client
)

var running = 0

func main() {
	var err error

	workdir, err = os.Getwd()
	if err != nil {
		log.Fatalf("Could not determine working directory: %v", err)
	}
	log.Printf("Working directory: %s", workdir)

	docker, err = dockerapi.NewEnvClient()
	if err != nil {
		log.Fatal("Failed to create docker environment: %v", err)
	}

	workQueue = make(chan string, 1024)
	go dockerWorker()

	socket, err := net.Listen("tcp", host+":"+port)
	if err != nil {
		log.Fatalf("Error listening: %v", err)
	}
	defer socket.Close()

	log.Printf("Listening on %v", host+":"+port)

	for {
		conn, err := socket.Accept()
		if err != nil {
			log.Fatalf("Error accepting: %v", err)
		}

		log.Printf("New connection from %v", conn.RemoteAddr())

		conn.SetDeadline(time.Now().Add(connectionTimeout))

		go handleClient(conn)
	}
}

func dockerWorker() {
	for {
		url := <-workQueue
		running = 1
		startContainer(url)
		running = 0
	}
}

func startContainer(url string) {
	log.Printf("Running exploit %s", url)
	ctx := context.Background()

	resp, err := docker.ContainerCreate(ctx, &container.Config{
		Image: "itszn/v8_csaw",
		Cmd:   []string{"/release/chrome", "--headless", "--disable-gpu", "--no-sandbox", "--virtual-time-budget=60000", url},
	}, nil, nil, "")
	if err != nil {
		log.Printf("Failed to create container: %v", err)
		return
	}

	if err := docker.ContainerStart(ctx, resp.ID, types.ContainerStartOptions{}); err != nil {
		log.Printf("Failed to start container %s: %v", resp.ID, err)
		return
	}

	waitCtx, cancel := context.WithTimeout(ctx, containerTimeout*time.Second)
	defer cancel()

	statusCh, errCh := docker.ContainerWait(waitCtx, resp.ID, container.WaitConditionNotRunning)
	select {
	case err := <-errCh:
		log.Printf("Container %s timed out: %v", resp.ID, err)
		if err := docker.ContainerKill(ctx, resp.ID, "SIGKILL"); err != nil {
			log.Printf("Failed to kill container %s: %v", resp.ID, err)
		}
	case <-statusCh:
	}

	if err := docker.ContainerRemove(ctx, resp.ID, types.ContainerRemoveOptions{}); err != nil {
		log.Printf("Failed to remove container %s: %v", resp.ID, err)
	}
}

func randomString(n int) string {
	b := make([]byte, (n+1)/2)
	if _, err := rand.Read(b); err != nil {
		log.Fatal("Failed to obtain random bytes")
	}
	return hex.EncodeToString(b)[:n]
}

func proofOfWork(client *Client) error {
	challenge := randomString(16)
	zeroesHex := strings.Repeat("0", powHardness/4)

	client.WriteString("=== Proof Of Work ===\n")
	client.WriteString(fmt.Sprintf("Please find a data X such that sha256(%s.X) starts with %s\n",
		challenge, zeroesHex))

	client.WriteString("Your solution (hex encoded): ")
	client.Flush()

	response, err := client.Reader.ReadString('\n')
	if err != nil {
		return err
	}

	response = strings.TrimSpace(response)

	var buf bytes.Buffer
	buf.Write([]byte(challenge))

	b, err := hex.DecodeString(response)
	buf.Write(b)
	if err != nil {
		client.WriteString("Could not hex decode")
		return errors.New("Invalid solution")
	}

	hashBytes := sha256.Sum256(buf.Bytes())
	hash := big.NewInt(0)
	hash.SetBytes(hashBytes[:])
	zeroes := strings.Repeat("0", powHardness)

	if !strings.HasPrefix(fmt.Sprintf("%0256b", hash), zeroes) {
		client.WriteString("Invalid POW....")
		return errors.New("Invalid solution")
	}

	return nil
}

func handleClient(conn net.Conn) {
	defer conn.Close()

	client := bufio.NewReadWriter(bufio.NewReader(conn), bufio.NewWriter(conn))
	defer client.Flush()

	client.WriteString(fmt.Sprintf(greeting, containerTimeout, len(workQueue)+running))
	client.Flush()

	err := proofOfWork(client)
	if err != nil {
		return
	}

	client.WriteString("=== Exploit ===\n")
	client.WriteString("Give me the URL of your exploit: ")
	client.Flush()

	rawUrl, err := client.ReadString('\n')
	if err != nil {
		return
	}

	url, err := url.Parse(strings.TrimSuffix(rawUrl, "\n"))
	if err != nil || !url.IsAbs() {
		client.WriteString("Thats not a vaild url :(")
		return
	}
	log.Printf("Got URL: %v", url)

	// Fetch the URL once to verify it is reachable
	cmd := exec.Command("wget",
		"-p",                                                             // fetch all required files
		"-k",                                                             // rewrite links
		"-P", fmt.Sprintf("%s/attempts/%d/", workdir, time.Now().Unix()), // set directory prefix
		url.String())

	if err := cmd.Start(); err != nil {
		log.Printf("Failed to start wget: %v. This is probably bad...", err)
	}

	timer := time.AfterFunc(10*time.Second, func() { cmd.Process.Kill() })
	if err := cmd.Wait(); err != nil {
		client.WriteString("Cannot reach URL")
		return
	}
	timer.Stop()

	client.WriteString("Alright! We will be visiting your site very soon!\n")
	client.WriteString(fmt.Sprintf("You are %d in line right now\n", len(workQueue)+1+running))
	client.Flush()

	workQueue <- url.String()
}
