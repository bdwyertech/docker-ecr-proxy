#!/bin/sh -e
# Magic to Provision the Container
# Brian Dwyer - Intelligent Digital Services

export AWS_REGION="${AWS_REGION:-${AWS_DEFAULT_REGION:-'us-east-1'}}"

export AWS_ACCOUNT="${AWS_ACCOUNT:-$(/usr/local/bin/ecr-login -account)}"

# Default to the AWS Resolver
export RESOLVER="${RESOLVER:-'169.254.169.253'}"

envsubst '\$RESOLVER \$AWS_ACCOUNT \$AWS_REGION' < /etc/nginx/conf.d/default.conf > /tmp/config && mv /tmp/config /etc/nginx/conf.d/default.conf

cat /etc/nginx/conf.d/default.conf

# Create SSL Certificate
if [ ! -f /etc/nginx/ssl/cert.pem ]; then
	mkdir -p /etc/nginx/ssl
	openssl ecparam -genkey -name secp384r1 | openssl ec -out /etc/nginx/ssl/key.pem 2>/dev/null
	openssl req -new -x509 -key /etc/nginx/ssl/key.pem -out /etc/nginx/ssl/cert.pem -days 3650 -subj "/CN=docker-ecr-proxy"
fi

/usr/local/openresty/bin/openresty -g 'daemon off;'
