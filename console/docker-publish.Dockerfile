FROM microsoft/dotnet:2.1-runtime AS base
ENV NUGET_XMLDOC_MODE skip

# Download vsdbg
WORKDIR /vsdbg
RUN apt-get update
RUN apt-get install -y --no-install-recommends unzip


# Set working directory
WORKDIR /app
EXPOSE 80

FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /src
COPY ["console.csproj", "./"]
RUN dotnet restore "./console.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "console.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "console.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "console.dll"]
