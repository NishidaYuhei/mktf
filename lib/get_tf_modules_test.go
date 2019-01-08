package lib

import (
	"testing"
)

var mktfTestApi string = GitHubContentsUrl + "mktf_test"

var testVarGetResourcesOfProvider = []struct {
	in  string
	out GitHubContents
}{
	{"mktf_test", GitHubContents{{}}},
}

func TestGetResourcesOfProvider(t *testing.T) {
	for _, tt := range testVarGetResourcesOfProvider {
		t.Run("Check the length of array", func(t *testing.T) {
			ac := len(GetResourcesOfProvider(tt.in))
			ex := len(tt.out)
			if ac != ex {
				t.Errorf("got %q, want %q", ac, ex)
			}
		})
	}
}

var testVarGetRespBody = []struct {
	in  string
	out string
}{
	{"https://raw.githubusercontent.com/NishidaYuhei/mktf/master/include_tf_modules/providers/mktf_test/test/test.tf", "scraping test\n"},
}

func TestGetRespBody(t *testing.T) {
	for _, tt := range testVarGetRespBody {
		t.Run("Check if it matches the test character string", func(t *testing.T) {
			ac := string(GetRespBody(tt.in))
			ex := tt.out
			if ac != ex {
				t.Errorf("got %q, want %q", ac, ex)
			}
		})
	}
}

var testVarGetRespJson = []struct {
	in  string
	out GitHubContents
}{
	{mktfTestApi, GitHubContents{{Name: "test"}}},
}

func TestGetRespJson(t *testing.T) {
	for _, tt := range testVarGetRespJson {
		t.Run("Check the length of json you expect", func(t *testing.T) {
			ac, _ := GetRespJson(tt.in, GitHubContents{})
			ex := tt.out
			if len(ac.(GitHubContents)) != len(ex) {
				t.Errorf("got %q, want %q", ac, ex)
			}
		})
		t.Run("Check if the expected Name matches", func(t *testing.T) {
			ac, _ := GetRespJson(tt.in, GitHubContents{})
			ex := tt.out
			if ac.(GitHubContents)[0].Name != ex[0].Name {
				t.Errorf("got %q, want %q", ac, ex)
			}
		})
	}
}

var testVarReadResourceFile = []struct {
	in  string
	out string
}{
	{"input", "expect output"},
}

func TestReadResourceFile(t *testing.T) {
	for _, tt := range testVarReadResourceFile {
		t.Run("Description", func(t *testing.T) {
			ac := ReadResourceFile()
			ex := tt.out
			if ac != ex {
				t.Errorf("got %q, want %q", ac, ex)
			}
		})
	}
}
