# Default value for the version of the base image (can be overridden at build time)
ARG BUILD_BASE_IMAGE_VERSION=bullseye-slim

# Use the specified or default Debian slim version
FROM debian:${BUILD_BASE_IMAGE_VERSION}

# Install necessary packages
RUN apt-get update && apt-get install -y \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Create the user 'updogg' with the default UID and GID of 69
RUN groupadd -g 69 updogg && \
    useradd -u 69 -g 69 -m updogg && \
    mkdir -p /config /app /root && \
    chown updogg:updogg /config /app

# Set default environment variables for UID and GID
ENV UID=69
ENV GID=69

# Copy everything in the repository to the root of the container
COPY . /

RUN chmod +x /root/entrypoint.sh

# Set /config folder to be used as a volume for user overrides
VOLUME ["/config"]

ENTRYPOINT ["/root/entrypoint.sh"]
