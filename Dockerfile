ARG BASE_IMAGE_VERSION=base-nvidia-latest
FROM ghcr.io/doguitar/updogg-docker:${BASE_IMAGE_VERSION}

RUN  apt-get update && apt-get install -y \
        git \
        python3-pip \
        python3-dev \
        python3-opencv \
        libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/* \
    && python3 -m pip install --upgrade pip \
    && pip3 install \
        torch \
        torchvision \
        torchaudio \
        -f https://download.pytorch.org/whl/cu111/torch_stable.html \
    && pip3 cache purge

COPY . /

RUN chmod +x /app/app.sh
