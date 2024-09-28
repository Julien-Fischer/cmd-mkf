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

FROM debian:12
LABEL authors="Julien Fischer"

WORKDIR /app
ARG DIRECTORY='cmd-mkf'

ENV PATH="/usr/local/bin:${PATH}"

# Install coreutils which includes cat
RUN apt-get update && apt-get install -y coreutils && rm -rf /var/lib/apt/lists/*

RUN apt update && apt install -y sudo

COPY ./tests/tests.sh /app


## Copy the templates
RUN mkdir templates
COPY templates templates

## Copy the executables to the container in home
RUN mkdir src
COPY ./src /app/src

# Add tests.sh to the container and make it executable
COPY ./tests/tests.sh /app
RUN chmod +x /app/tests.sh

# Copy the source code to the container and make it executable
RUN mkdir $DIRECTORY
RUN mv /app/src "/app/${DIRECTORY}"
RUN chmod +x "/app/${DIRECTORY}/src/mkf"
RUN chmod +x "/app/${DIRECTORY}/src/install.sh"
RUN chmod +x "/app/${DIRECTORY}/src/mkf-uninstall.sh"

RUN mv templates /app/cmd-mkf

# Install mkf
RUN /app/${DIRECTORY}/src/install.sh -q

RUN mkdir 'runner'

# Run the automated tests
ENTRYPOINT ["/app/tests.sh"]
