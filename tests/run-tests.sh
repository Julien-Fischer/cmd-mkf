#!/usr/bin/env bash

# Copyright 2024 Julien Fischer
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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