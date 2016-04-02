#!/bin/bash

export GOOS=linux
export GOARCH=amd64

BUILDDATE=$(date -u "+%Y%m%d%H%M%S")
VERSION="$(git describe)-$BUILDDATE-kapsi"
HOOKSPATH='/usr/local/acmetool/hooks'
STORAGEPATH='~/.acme/state'
WEBROOT='~/.acme/well-known'

# Build in ./build
mkdir -p build
cd build
export GOPATH=$PWD

rm -rf bin
mkdir -p src/github.com/hlandau
ln -sf ../../../.. src/github.com/hlandau/acme
go get github.com/hlandau/acme/cmd/acmetool
go build -o bin/acmetool \
    -ldflags "-X github.com/hlandau/acme/storage.RecommendedPath=$STORAGEPATH
              -X github.com/hlandau/acme/hooks.DefaultPath=$HOOKSPATH
              -X github.com/hlandau/acme/responder.StandardWebrootPath=$WEBROOT
              -X github.com/hlandau/degoutils/buildinfo.BuildInfo=$VERSION" \
    github.com/hlandau/acme/cmd/acmetool
