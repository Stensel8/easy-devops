# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine AS build
WORKDIR /src

COPY frontend/easy-devops.csproj .
RUN dotnet restore

COPY frontend/ .
RUN dotnet publish -c Release -o /app/publish --self-contained false

# Runtime stage
FROM mcr.microsoft.com/dotnet/runtime:8.0-alpine
WORKDIR /app

RUN apk add --no-cache icu-libs iputils tzdata ncurses-terminfo-base && \
    cp /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime && \
    echo "Europe/Amsterdam" > /etc/timezone && \
    apk del tzdata

COPY --from=build /app/publish .

ENV TERM=xterm-256color

ENTRYPOINT ["dotnet", "easy-devops.dll"]
