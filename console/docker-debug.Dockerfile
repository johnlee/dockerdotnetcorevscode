# Inspired by: https://github.com/sleemer/docker.dotnet.debug
FROM microsoft/dotnet:2.1-sdk AS base
ENV NUGET_XMLDOC_MODE skip

# Setup vsdbg
WORKDIR /vsdbg
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       unzip \
    && rm -rf /var/lib/apt/lists/* \
    && curl -sSL https://aka.ms/getvsdbgsh | bash /dev/stdin -v latest -l /vsdbg

# Set working directory
RUN mkdir /app
WORKDIR /app

COPY *.csproj /app
RUN dotnet restore

COPY . /app
RUN dotnet publish -c Debug -o out

# Kick off a container just to wait debugger to attach and run the app
ENTRYPOINT ["/bin/bash", "-c", "sleep infinity"]

# Docker commands (these can be called by runDocker.sh script):
# docker build --rm -f "docker-publish.Dockerfile" -t console:latest .
# docker run --rm -it -p 80:80/tcp console:latest