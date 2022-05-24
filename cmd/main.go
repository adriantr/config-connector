package main

import (
	"io/ioutil"
	"net/http"
	"os"

	"cloud.google.com/go/storage"
	"github.com/gin-gonic/gin"
)

func main() {
	r := gin.Default()

	r.GET("/", getFile)

	r.Run()
}

func getFile(c *gin.Context) {
	client, err := storage.NewClient(c)

	if err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		return
	}

	rc, err := client.Bucket(os.Getenv("BUCKET_NAME")).Object(os.Getenv("FILE_NAME")).NewReader(c)
	if err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		return
	}
	slurp, err := ioutil.ReadAll(rc)
	rc.Close()
	if err != nil {
		c.JSON(http.StatusInternalServerError, err.Error())
		return
	}

	c.JSON(http.StatusOK, string(slurp))
}
