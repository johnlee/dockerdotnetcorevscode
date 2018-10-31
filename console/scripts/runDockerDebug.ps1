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
    [Parameter(Mandatory = $true)]
    [string]
    [ValidateSet("debug", "cleanup")]
    $command,

    [Parameter(Mandatory = $true)]
    [string]
    $srcpath
)

$global:baseImageName = "dotnet21sdk.vsdbg"
$global:imageName = "console.vsdbg"
$global:containerName = "console"

function killContainers([string]$arg) {
    docker ps -aq --filter "ancestor=$global:containerName" | ForEach-Object { docker rm --force $_ }
}
  
function removeImage () {
    docker rmi $global:imageName
}
  
function  buildImage () {
    Set-Location $srcpath
    $baseImageId = docker images -q $global:baseImageName
    if (-not $baseImageId) {
        $dockerfile = $srcpath + "\docker-vsdbg.Dockerfile"
        Write-Host "Building $global:baseImageName"
        docker build --rm -f "$dockerfile" -t $global:baseImageName .
    }
    $dockerfile = $srcpath + "\docker-debug.Dockerfile"
    Write-Host "Building $global:imageName"
    docker build --rm -f "$dockerfile" -t $global:imageName .
}
  
function runContainer () {
    docker run --rm -d -p 80:80/tcp --name $global:containerName $global:imageName
}
  
if ($command -eq "debug") {
    Write-Host "Starting debug at '$srcpath'"
    killContainers
    buildImage
    runContainer
}
else {
    Write-Host "Starting cleanup"
    killContainers
    removeImage
}