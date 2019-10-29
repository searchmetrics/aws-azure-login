#!/usr/bin/env bash

tag=$(git describe --abbrev=0 --tags);
image_name="searchmetrics/aws-azure-login";
docker build -f Dockerfile-alpine . -t "${image_name}:${tag}";
docker push "${image_name}:${tag}";
docker tag "${image_name}:${tag}" "${image_name}:latest";
docker push "${image_name}:latest";
