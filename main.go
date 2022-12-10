// Encoding: UTF-8
//
// AWS ECR Proxy
//
// Copyright © 2022 Brian Dwyer - Intelligent Digital Services
//

package main

import (
	"context"
	"flag"
	"fmt"
	"log"
	"os"
	"time"

	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/ecr"
)

func main() {
	flag.Parse()

	if versionFlag {
		showVersion()
		os.Exit(0)
	}

	// AWS Session
	ctx, cancel := context.WithTimeout(context.Background(), 8*time.Second)
	defer cancel()
	cfg, err := config.LoadDefaultConfig(ctx)
	if err != nil {
		log.Fatal(err)
	}

	// ECR Client
	ecrclient := ecr.NewFromConfig(cfg)

	result, err := ecrclient.GetAuthorizationToken(ctx, &ecr.GetAuthorizationTokenInput{})
	if err != nil {
		log.Fatal(err)
	}

	fmt.Printf(*result.AuthorizationData[0].AuthorizationToken)
}
