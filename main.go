package main

import (
	"flag"
	"fmt"
	"log"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/ecr"
)

var awsAccount = flag.String("account", "", "AWS Account (ECR Registry ID)")

func main() {
	flag.Parse()

	// AWS Session
	sess := session.Must(session.NewSessionWithOptions(session.Options{
		Config:            *aws.NewConfig().WithCredentialsChainVerboseErrors(true),
		SharedConfigState: session.SharedConfigEnable,
	}))

	// ECR Client
	ecrclient := ecr.New(sess)

	input := &ecr.GetAuthorizationTokenInput{}
	if *awsAccount != "" {
		input.RegistryIds = []*string{awsAccount}
	}
	result, err := ecrclient.GetAuthorizationToken(input)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Printf(*result.AuthorizationData[0].AuthorizationToken)
}
