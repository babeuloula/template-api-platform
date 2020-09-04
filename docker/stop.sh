#!/usr/bin/env bash

set -e

readonly DOCKER_PATH=$(dirname $(realpath $0))
cd ${DOCKER_PATH};

. ./lib/functions.sh
. ./.env

docker-compose -f "docker-compose.yml" -f "docker-compose.override.${APP_ENV}.yml" stop
