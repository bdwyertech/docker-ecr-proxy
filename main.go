// Encoding: UTF-8
//
// AWS ECR Proxy
//
// Copyright © 2023 Brian Dwyer - Intelligent Digital Services
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
	"github.com/aws/aws-sdk-go-v2/service/sts"
)

var accountFlag bool

func init() {
	flag.BoolVar(&accountFlag, "account", false, "Display AWS Account")
}

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

	// Emit AWS Account ID
	if accountFlag {
		result, err := sts.NewFromConfig(cfg).GetCallerIdentity(ctx, &sts.GetCallerIdentityInput{})
		if err != nil {
			log.Fatal(err)
		}
		if _, err = fmt.Println(*result.Account); err != nil {
			log.Fatal(err)
		}
		return
	}

	// ECR Client
	result, err := ecr.NewFromConfig(cfg).GetAuthorizationToken(ctx, &ecr.GetAuthorizationTokenInput{})
	if err != nil {
		log.Fatal(err)
	}

	if _, err = fmt.Print(*result.AuthorizationData[0].AuthorizationToken); err != nil {
		log.Fatal(err)
	}
}
