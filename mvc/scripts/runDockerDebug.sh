# Inspired by: https://github.com/sleemer/docker.dotnet.debug
$baseImageName = "dotnet21sdk.vsdbg"
$imageName = "mvc.vsdbg"
$containerName = "mvc"

killContainers () {
  docker rm --force $(docker ps -q -a --filter "ancestor=$containerName")
}

# Removes the Docker image
removeImage () {
  docker rmi $imageName
}

# Builds the Docker image.
buildImage () {
  if [[ "docker images -q $baseImageName" == "" ]]; then
    echo "Building $baseImageName"
    docker build --rm -f "docker-vsdbg.Dockerfile" -t $baseImageName .
  fi
  echo "Building $imageName"
  docker build --rm -f "docker-debug.Dockerfile" -t $imageName .
}

# Runs a new container
runContainer () {
  echo "Running $containerName"
  docker run --rm -d -p 80:80/tcp --name $containerName $imageName
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
            echo "Starting cleanup"
            killContainers
            removeImage
            ;;
    "debug")
            echo "Starting debugger"
            killContainers
            buildImage
            runContainer
            ;;
    *)
            showUsage
            ;;
  esac
fi