package main

import (
	"fmt"
	"mime"
	"net/http"
	"os"
	"path"
)

func init() {
	cmds["storage-upload"] = cmd{storageUpload, "<file>", "upload a file to the temporary storage"}
	cmdHelp["storage-upload"] = `Uploads a given file to the Sauce Labs temporary storage to make available inside Sauce.

This uses the SAUCE_USERNAME and SAUCE_ACCESS_KEY environment variables for authentication.`
}

func storageUpload(fileName string) {
	file, err := os.Open(fileName)
	if err != nil {
		bail(err)
	}

	url := fmt.Sprintf("http://saucelabs.com/rest/v1/storage/%s/%s?overwrite=true", os.Getenv("SAUCE_USERNAME"), path.Base(fileName))

	request, err := http.NewRequest("POST", url, file)
	if err != nil {
		bail(err)
	}

	request.SetBasicAuth(os.Getenv("SAUCE_USERNAME"), os.Getenv("SAUCE_ACCESS_KEY"))

	mimetype := mime.TypeByExtension(path.Ext(fileName))
	if mimetype == "" {
		mimetype = "text/plain"
	}
	request.Header.Set("Content-Type", mimetype)

	fileinfo, err := file.Stat()
	if err != nil {
		bail(err)
	}
	request.ContentLength = fileinfo.Size()

	var client http.Client
	resp, err := client.Do(request)
	if err != nil {
		bail(err)
	}

	if resp.StatusCode >= 400 {
		fmt.Fprintf(os.Stderr, "storage-upload: Got an error while uploading file: %s\n", resp.Status)
		os.Exit(1)
	}
	fmt.Printf("File %s uploaded and can be downloaded as sauce-storage:%s\n", fileName, path.Base(fileName))
}
