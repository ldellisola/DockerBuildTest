﻿FROM mcr.microsoft.com/dotnet/sdk:7.0-alpine AS build-env
WORKDIR /app
# Copy everything
COPY . ./
# Restore as distinct layers
RUN dotnet restore dockerTest.csproj
# Build and publish a release
RUN dotnet publish dockerTest.csproj  \
    -c Release \
    -o out \
    --no-restore

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:7.0-alpine

ENV OTEL_ATTRIBUTE_VALUE_LENGTH_LIMIT=4094

EXPOSE 80
EXPOSE 443
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet","dockerTest.dll"]
