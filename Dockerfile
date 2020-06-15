FROM golang:1.14-alpine as ecr-login
WORKDIR /code
COPY . .
RUN CGO_ENABLED=0 GOFLAGS=-mod=vendor go build .

FROM openresty/openresty:alpine

COPY --from=ecr-login /code/ecr-login /usr/local/bin/.

RUN apk add gettext

ADD /docker-manifest/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
ADD /docker-manifest/app.conf /etc/nginx/conf.d/default.conf
ADD /docker-manifest/entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT /usr/local/bin/entrypoint.sh
CMD ["/usr/local/openresty/bin/openresty", "-g", "daemon off;"]
