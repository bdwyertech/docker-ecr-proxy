// Encoding: UTF-8
//
// AWS ECR Proxy
//
// Copyright © 2021 Brian Dwyer - Intelligent Digital Services
//

package main

import (
	"flag"
	"fmt"
	"runtime"
)

var versionFlag bool

func init() {
	flag.BoolVar(&versionFlag, "version", false, "Display version")
}

var GitCommit, ReleaseDate string

func showVersion() {
	if GitCommit == "" {
		GitCommit = "DEVELOPMENT"
	}
	fmt.Println("commit:", GitCommit)
	fmt.Println("date:", ReleaseDate)
	fmt.Println("runtime:", runtime.Version())
}
