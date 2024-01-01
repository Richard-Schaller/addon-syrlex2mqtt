ARG BUILD_FROM=hassioaddons/base:edge
FROM $BUILD_FROM

ENV LANG C.UTF-8
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base
RUN \
    apk add --no-cache --virtual .build-deps python3 make g++ linux-headers
RUN \
    apk add --no-cache npm

# Copy data for add-on
RUN mkdir /syrlex2mqtt
COPY rootfs/syrlex2mqtt/package-lock.json /syrlex2mqtt
COPY rootfs/syrlex2mqtt/package.json /syrlex2mqtt

WORKDIR /syrlex2mqtt

RUN npm ci

RUN apk del --no-cache --purge .build-deps && rm -rf /root/.npm /root/.cache

COPY rootfs/ /
