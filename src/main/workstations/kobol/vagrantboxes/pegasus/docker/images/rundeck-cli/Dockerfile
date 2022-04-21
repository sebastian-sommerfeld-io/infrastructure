FROM openjdk:18-slim-bullseye
LABEL maintainer="sebastian@sommerfeld.io"

USER root
RUN apt-get update \
    && apt-get install -y curl \
    && curl -s https://packagecloud.io/install/repositories/pagerduty/rundeck/script.deb.sh | os=any dist=any bash \
    && apt-get install -y rundeck-cli

USER "${uid}:${gid}"
ENV RD_URL="http://localhost:7440" \
    RD_USER="admin" \
    RD_PASSWORD="admin"
