#!/usr/bin/env bash

set -e

readonly DOCKER_PATH=$(dirname $(realpath $0))
cd ${DOCKER_PATH};

. ./lib/functions.sh

block_info "Welcome to Template API Platform installer!"

check_requirements
parse_env ".env.dist" ".env"
. ./.env
echo -e "${GREEN}Configuration done!${RESET}" > /dev/tty

if [ "${APP_ENV}" == "dev" ]; then
    ./mkcert.sh
fi

block_info "Build & start Docker"
./stop.sh
./start.sh
echo -e "${GREEN}Docker is started with success!${RESET}" > /dev/tty

block_info "Install dependencies"
install_composer "${APP_ENV}"
echo -e "${GREEN}Dependencies installed with success!${RESET}" > /dev/tty

wait_mysql
database_and_migrations

if [ "${APP_ENV}" == "dev" ]; then
    add_host "${HTTP_HOST}"
fi
block_success "Template is started https://${HTTP_HOST}"
