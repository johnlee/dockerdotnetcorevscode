# Inspired by: https://github.com/sleemer/docker.dotnet.debug
FROM microsoft/dotnet:2.1-sdk AS base

# Setup vsdbg
WORKDIR /vsdbg
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       unzip \
    && rm -rf /var/lib/apt/lists/* \
    && curl -sSL https://aka.ms/getvsdbgsh | bash /dev/stdin -v latest -l /vsdbg

ENTRYPOINT [ "/bin/bash" ]

# docker build --rm -f "docker-vsdbg.Dockerfile" -t dotnet21sdk.vsdbg .
# docker run --rm -it -p 80:80/tcp dotnet21sdk.vsdbg