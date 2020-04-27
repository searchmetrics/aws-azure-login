#!/usr/bin/env bash

_version="latest";
image_name="searchmetrics/aws-azure-login";

if [ "${1}" = 'debug' ]; then
  shift
  docker run -e "DEBUG=aws-azure-login" --rm -it \
    -v ~/.aws:/.aws \
    -e "HOME=/"
    -w /aws-azure-login \
    -v ${PWD}:/aws-azure-login \
    --user $(id -u) \
    ${image_name}:${_version} "$@"
    #sh
elif [ "${1}" = 'latest' ]; then
 docker run --rm -it \
    -v ~/.aws:/.aws \
    -e "HOME=/"
    --user $(id -u) \
    ${image_name}:latest "$@"
else
 docker run --rm -it \
    -v ~/.aws:/.aws \
    -e "HOME=/"
    --user $(id -u) \
    ${image_name}:${_version} "$@"
fi
