# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine3.22 AS build
WORKDIR /src

COPY frontend/easy-devops.csproj .
RUN dotnet restore

COPY frontend/ .
RUN dotnet publish -c Release -o /app/publish --self-contained false

# Runtime stage - Alpine 3.22 for CVE mitigation
FROM mcr.microsoft.com/dotnet/runtime:8.0-alpine3.22

# Security: Create non-root user
RUN addgroup -g 1000 appgroup && \
    adduser -D -u 1000 -G appgroup appuser

WORKDIR /app

# Install runtime dependencies with no-cache to reduce image size
RUN apk add --no-cache icu-libs iputils tzdata ncurses-terminfo-base && \
    cp /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime && \
    echo "Europe/Amsterdam" > /etc/timezone && \
    apk del tzdata && \
    rm -rf /var/cache/apk/*

# Copy application files and set ownership
COPY --from=build --chown=appuser:appgroup /app/publish .

ENV TERM=xterm-256color

# Security: Run as non-root user
USER appuser

ENTRYPOINT ["dotnet", "easy-devops.dll"]
