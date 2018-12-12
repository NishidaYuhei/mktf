package lib

import (
	"testing"
)

var testVarCheckExistDir = []struct {
	in  string
	out bool
}{
	{"../lib", true},
	{"../hoge", false},
}

func TestCheckExistDir(t *testing.T) {
	for _, tt := range testVarCheckExistDir {
		t.Run(tt.in, func(t *testing.T) {
			ac := CheckExistDir(tt.in)
			if ac != tt.out {
				t.Errorf("got %v, want %v", ac, tt.out)
			}
		})
	}
}
