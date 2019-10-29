#!/usr/bin/env bash

_version="v1.7.1";
image_name="searchmetrics/aws-azure-login";

if [ "${1}" = 'debug' ]; then
  docker run -e "DEBUG=*" --rm -it \
    --entrypoint='' \
    -v ~/.aws:/root/.aws \
    -v ${PWD}:/aws-azure-login \
    ${image_name}:${_version} "$@" \
    sh
elif [ "${1}" = 'latest' ]; then
 docker run --rm -it \
    -v ~/.aws:/root/.aws \
    ${image_name}:latest "$@"
else
 docker run --rm -it \
    -v ~/.aws:/root/.aws \
    ${image_name}:${_version} "$@"
fi
