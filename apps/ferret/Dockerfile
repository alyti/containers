# syntax=docker/dockerfile:1

FROM docker.io/library/node:22-alpine AS ferret
ARG VERSION

ENV PRODUCTION=true

USER root
WORKDIR /app

RUN apk add --no-cache \
        bash \
        ca-certificates \
        catatonit \
        coreutils \
        curl \
        jq \
        nano \
        tzdata \
    && \
    apk add --no-cache --virtual=.build-deps \
        build-base \
        libffi-dev \
        openssl-dev \
        musl-dev \
        git \
    && \
    git clone --single-branch --branch "${VERSION}" https://github.com/ferretsys/Ferret.git . \
    && \
    npm install \
    && chown -R root:root /app && chmod -R 755 /app \
    && apk del --purge .build-deps \
    && rm -rf /root/.cache /root/.cargo /tmp/*

COPY . /

USER nobody:nogroup
WORKDIR /data
VOLUME ["/data"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]