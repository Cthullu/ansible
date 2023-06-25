#!/usr/bin/env bash

VERSION=0.1.0

podman build \
--force-rm \
--no-cache \
--platform linux/amd64 \
--quiet \
--rm \
--tag quay.io/cthullu/bind9:${VERSION} \
--file Dockerfile .
