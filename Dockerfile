ARG BASE_IMAGE_VERSION=base-latest

FROM ghcr.io/doguitar/updogg-docker:${BASE_IMAGE_VERSION}

RUN  apt-get update && apt-get install -y \
        curl \
        gnupg \
    && rm -rf /var/lib/apt/lists/*

# Install necessary packages
RUN distribution=$(. /etc/os-release;echo  $ID$VERSION_ID)  \
    && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -  \
    && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list \
    && apt-get update && apt-get install -y \
        nvidia-container-toolkit \
    && rm -rf /var/lib/apt/lists/*

COPY . /

RUN chmod +x /app/app.sh
