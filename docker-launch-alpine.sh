#!/usr/bin/env bash

if [ $1 -eq 'debug' ]; then
  docker run -e "DEBUG=*" --rm -it \
    --entrypoint='' \
    -v ~/.aws:/root/.aws \
    -v ${PWD}:/aws-azure-login \
    aws-azure-login:alpine "$@" \
    sh
else
 docker run --rm -it \
    -v ~/.aws:/root/.aws \
    -v ${PWD}:/aws-azure-login \
    aws-azure-login:alpine "$@"
fi
