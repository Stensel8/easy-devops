FROM alpine:latest

WORKDIR /app

RUN apk add --no-cache \
    iputils \
    icu-libs \
    tzdata && \
    cp /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime && \
    echo "Europe/Amsterdam" > /etc/timezone && \
    apk del tzdata

# Copy the self-contained binaries into the image
COPY out/docker/ .

# Set up the directory for .NET single-file bundle extraction
ENV DOTNET_BUNDLE_EXTRACT_BASE_DIR=/tmp/dotnetbundle
RUN mkdir -p /tmp/dotnetbundle && chmod -R 777 /tmp/dotnetbundle

# Set terminal type to support ANSI colors
ENV TERM=xterm-256color

ENTRYPOINT ["/app/easy-devops"]
