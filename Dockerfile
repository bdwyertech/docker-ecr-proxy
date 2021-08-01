FROM golang:1.16.6-alpine as ecr-login
WORKDIR /code
ARG BUILD_DATE
ARG VCS_REF
COPY . .
RUN CGO_ENABLED=0 GOFLAGS=-mod=vendor go build -ldflags "-s -w -X main.GitCommit=$VCS_REF -X main.ReleaseDate=$BUILD_DATE" .

FROM openresty/openresty:alpine

COPY --from=ecr-login /code/ecr-login /usr/local/bin/.

ARG BUILD_DATE
ARG VCS_REF

LABEL org.opencontainers.image.title="bdwyertech/ecr-proxy" \
      org.opencontainers.image.version=$C7N_VERSION \
      org.opencontainers.image.description="For using ECR to serve public images" \
      org.opencontainers.image.authors="Brian Dwyer <bdwyertech@github.com>" \
      org.opencontainers.image.url="https://hub.docker.com/r/bdwyertech/ecr-proxy" \
      org.opencontainers.image.source="https://github.com/bdwyertech/docker-ecr-proxy.git" \
      org.opencontainers.image.revision=$VCS_REF \
      org.opencontainers.image.created=$BUILD_DATE \
      org.label-schema.name="bdwyertech/ecr-proxy" \
      org.label-schema.description="For using ECR to serve public images" \
      org.label-schema.url="https://hub.docker.com/r/bdwyertech/ecr-proxy" \
      org.label-schema.vcs-url="https://github.com/bdwyertech/docker-ecr-proxy.git" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.build-date=$BUILD_DATE

RUN apk add gettext openssl \
    && mkdir -p /var/cache/nginx

ADD /docker-manifest/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
ADD /docker-manifest/app.conf /etc/nginx/conf.d/default.conf
ADD /docker-manifest/log_format.conf /etc/nginx/conf.d/010_log_format.conf
ADD /docker-manifest/entrypoint.sh /usr/local/bin/entrypoint.sh

ADD /docker-manifest/ecr.lua /usr/local/openresty/site/ecr.lua

ENTRYPOINT /usr/local/bin/entrypoint.sh
CMD ["/usr/local/openresty/bin/openresty", "-g", "daemon off;"]
