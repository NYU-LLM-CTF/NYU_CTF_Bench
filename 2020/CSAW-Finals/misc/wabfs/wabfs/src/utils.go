package src

import (
	"bytes"
	"encoding/json"
	"github.com/gin-gonic/gin"
	"net/http"
)

// How tf is this not built into golang's http module
func PostJSON(url string, body interface{}, headers map[string]string) (*http.Response, error) {
	payloadBuf := new(bytes.Buffer)
	json.NewEncoder(payloadBuf).Encode(body)
	client := new(http.Client)
	req, err := http.NewRequest("POST", url, payloadBuf)

	if err != nil {
		return nil, err
	}

	for header, value := range headers {
		req.Header.Add(header, value)
	}
	resp, err := client.Do(req)

	return resp, err
}

// Check the user provided APIKEY
func checkAPIKey(context *gin.Context) bool {
	userAPIKey := context.Request.Header.Get("APIKEY")
	if userAPIKey != APIKey {
		context.String(200, "Wrong APIKEY provided")
		return false
	}
	return true
}
