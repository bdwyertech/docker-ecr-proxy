#!/bin/sh -e
# Magic to Provision the Container
# Brian Dwyer - Intelligent Digital Services

envsubst '\$RESOLVER \$AWS_ACCOUNT \$AWS_REGION' < /etc/nginx/conf.d/default.conf | tee /etc/nginx/conf.d/default.conf

# Passthrough
echo "$@"
# exec "$@"

/usr/local/openresty/bin/openresty -g 'daemon off;'
