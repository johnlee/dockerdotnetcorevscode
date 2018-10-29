<#
.SYNOPSIS
Executes docker commands

.DESCRIPTION
Executes docker commands to cleanup or buildup containers

.Parameter command
Accepted commands are 'debug' or 'cleanup'

.Parameter srcpath
Path to the source files

.EXAMPLE
C:\PS> .\runDocker.ps1 -command debug -srcpath c:\project\src
#>

Param (
    [Parameter(Mandatory = $true, ParameterSetName = "ByName")]
    [string]
    [ValidateSet("debug", "cleanup")]
    $command,

    [Parameter(Mandatory = $true, ParameterSetName = "ByName")]
    [string]
    $srcpath
)

function killContainers([string]$arg) {
    docker ps -aq --filter "ancestor=console" | ForEach-Object { docker rm --force $_ }
}
  
function removeImage () {
    docker rmi console
}
  
function  buildImage () {
    $dockerfile = $srcpath + "\docker-debug.Dockerfile"
    Write-Host "Building with dockerfile: '$dockerfile'"
    Set-Location $srcpath
    docker build --rm -f "$dockerfile" -t console:latest .
}
  
function runContainer () {
    docker run --rm -d -p 80:80/tcp --name console console:latest
}
  
if ($command -eq "debug") {
    Write-Host "Running debug at path '$srcpath'"
    killContainers
    buildImage
    runContainer
}
else {
    Write-Host "Running cleanup"
    killContainers
    removeImage
}