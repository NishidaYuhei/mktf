package lib

import "os"

// CheckExistDir is return true if directory exists, false otherwise.
func CheckExistDir(dirPath string) bool {
	if f, err := os.Stat(dirPath); os.IsNotExist(err) || !f.IsDir() {
		return false
	}
	return true
}
