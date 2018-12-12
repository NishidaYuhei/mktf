package lib

import "testing"

func TestCheckExistDir(t *testing.T) {
	if !CheckExistDir("../include_tf_modules") {
		t.Fatal("Not found test dir")
	}
}
