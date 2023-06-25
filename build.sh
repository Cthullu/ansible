#!/usr/bin/env bash

VERSION=7.5.0-b1

podman build \
--force-rm \
--no-cache \
--platform linux/amd64 \
--quiet \
--rm \
--tag quay.io/cthullu/bind9:${VERSION} \
--file Dockerfile .
