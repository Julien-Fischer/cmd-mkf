#!/usr/bin/env bash

################################################################
# Constants
################################################################

build_name=mkf-tests
dockerfile_directory=..

################################################################
# Cleanup
################################################################

if [[ $(docker ps -qa -f name=$build_name) ]]; then
    docker stop $build_name
    docker rm $build_name
fi

if [[ $(docker ps -aq -f name=$build_name) ]]; then
    docker rmi $build_name
fi

################################################################
# Build image and run tests
################################################################

docker build -t $build_name $dockerfile_directory
docker run --name $build_name $build_name


# Inspect the container via the CLI:
# docker exec -ti "mkf-tests" /bin/bash