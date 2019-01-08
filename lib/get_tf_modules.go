package lib

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"reflect"
)

const (
	GitHubContentsUrl    = "https://api.github.com/repos/NishidaYuhei/mktf/contents/include_tf_modules/providers/"
	ResourceFileBasePath = "https://raw.githubusercontent.com/NishidaYuhei/mktf/master/"
)

type GitHubContents []struct {
	Name        string      `json:"name"`
	Path        string      `json:"path"`
	Sha         string      `json:"sha"`
	Size        int         `json:"size"`
	URL         string      `json:"url"`
	HTMLURL     string      `json:"html_url"`
	GitURL      string      `json:"git_url"`
	DownloadURL interface{} `json:"download_url"`
	Type        string      `json:"type"`
	Links       struct {
		Self string `json:"self"`
		Git  string `json:"git"`
		HTML string `json:"html"`
	} `json:"_links"`
}

type ResourceFileContents []struct {
	TfModulesFilePath string
	Contents          string
}

func GetRespBody(url string) []byte {
	resp, err := http.Get(url)
	if err != nil {
		fmt.Println(err)
	}
	defer resp.Body.Close()
	byteArray, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		fmt.Println(err)
	}
	return byteArray
}

func GetRespJson(url string, expectStruct interface{}) (interface{}, error) {
	data := reflect.New(reflect.TypeOf(expectStruct)).Interface()
	if err := json.Unmarshal(GetRespBody(url), &data); err != nil {
		fmt.Println("JSON Unmarshal error:", err)
		return nil, err
	}
	return reflect.ValueOf(data).Elem().Interface(), nil
}

func GetResourcesOfProvider(providerName string) GitHubContents {
	resourceList, err := GetRespJson(GitHubContentsUrl+providerName, GitHubContents{})
	if err != nil {
		fmt.Println(err)
	}
	return resourceList.(GitHubContents)
}

func ReadResourceFileContents() ResourceFileContents {
	return ResourceFileContents{{}}
}

// func GetTfModules() []string {
// }
