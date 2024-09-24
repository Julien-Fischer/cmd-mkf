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
