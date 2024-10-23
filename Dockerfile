ARG BASE_IMAGE_VERSION=base-latest

FROM ghcr.io/doguitar/updogg-docker:${BASE_IMAGE_VERSION}

COPY . /

RUN chmod +x /app/app.sh
