FROM ubuntu:24.10

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    iputils-ping libicu74 tzdata && \
    ln -snf /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime && \
    echo "Europe/Amsterdam" > /etc/timezone && \
    rm -rf /var/lib/apt/lists/*

# Copy the self-contained binaries into the image
COPY out/docker/ .

# Set up the directory for .NET single-file bundle extraction
ENV DOTNET_BUNDLE_EXTRACT_BASE_DIR=/tmp/dotnetbundle
RUN mkdir -p /tmp/dotnetbundle && chmod -R 777 /tmp/dotnetbundle

# Set terminal type to support ANSI colors
ENV TERM=xterm-256color

ENTRYPOINT ["/app/easy-devops"]
