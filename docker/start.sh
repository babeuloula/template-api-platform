#!/usr/bin/env bash

set -e

readonly DOCKER_PATH=$(dirname $(realpath $0))
cd ${DOCKER_PATH};

. ./lib/functions.sh
. ./.env

configure_env 'VERSION' "$(get_current_version)" '.env'

docker-compose -f "docker-compose.yml" -f "docker-compose.override.${APP_ENV}.yml" up -d --remove-orphans --build
