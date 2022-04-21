FROM rundeck/rundeck:3.4.10
LABEL maintainer="sebastian@sommerfeld.io"

USER root
RUN apt-get update \
    && apt-get install -y git \
    && apt-get install -y sshpass

#USER "${uid}:${gid}"
USER rundeck:0
RUN mkdir -p /home/rundeck/repos

COPY assets/.gitconfig /home/rundeck/.gitconfig

ENV SERVER_URL=http://localhost:7440 \
    RUNDECK_GRAILS_URL=http://localhost:7440 \
    RUNDECK_SERVER_ADDRESS=0.0.0.0
