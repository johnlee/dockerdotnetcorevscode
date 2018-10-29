# Inspired by: https://github.com/sleemer/docker.dotnet.debug
killContainers () {
  docker rm --force $(docker ps -q -a --filter "ancestor=console")
}

# Removes the Docker image
removeImage () {
  docker rmi console
}

# Builds the Docker image.
buildImage () {
  docker build --rm -f "docker-debug.Dockerfile" -t console:latest .
}

# Runs a new container
runContainer () {
  docker run --rm -d -p 80:80/tcp --name console console:latest
}

# Shows the usage for the script.
showUsage () {
  echo "Usage: runDocker.sh [COMMAND]"
  echo "    Runs command"
  echo ""
  echo "Commands:"
  echo "    cleanup: Kill and remove docker image(s)."
  echo "    debug: Builds the debug image and runs docker container."
  echo ""
  echo "Example:"
  echo "    ./runDocker.sh debug"
  echo ""
}

if [ $# -eq 0 ]; then
  showUsage
else
  case "$1" in
    "cleanup")
            killContainers
            removeImage
            ;;
    "debug")
            killContainers
            buildImage
            runContainer
            ;;
    *)
            showUsage
            ;;
  esac
fi