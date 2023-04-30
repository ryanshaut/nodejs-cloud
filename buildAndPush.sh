#!/usr/bin/env bash

tag="${1:-latest}"
image="shaurm/nodejs-cloud:$tag"

docker build . -t $image
docker push $image