FROM dotnet21sdk.vsdbg:latest AS base
ENV NUGET_XMLDOC_MODE skip

# Set working directory
RUN mkdir /app
WORKDIR /app

COPY *.csproj /app
RUN dotnet restore

COPY . /app
RUN dotnet publish -c Debug -o out

# Kick off a container just to wait debugger to attach and run the app
ENTRYPOINT ["/bin/bash", "-c", "sleep infinity"]

# Docker debugger commands (these can be called by runDockerDebug.sh script):
# docker build --rm -f "docker-debug.Dockerfile" -t webapi .
# docker run --rm -it -p 80:80/tcp webapi