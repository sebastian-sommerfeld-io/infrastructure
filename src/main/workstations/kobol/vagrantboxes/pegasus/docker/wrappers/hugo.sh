#!/bin/bash
# @file hugo.sh
# @brief Wrapper to use hugo from Docker container when using the default ``hugo`` command.
#
# @description The script is a wrapper to use hugo from a Docker container when using the default ``hugo`` command.
# The script delegates the hugo commands to a container using image ``link:https://hub.docker.com/r/klakegg/hugo[klakegg/hugo]``.
#
# In order to use the ``hugo`` command, the ``xref:src_main_vagrantboxes_pegasus_provision_configure.adoc[configure-wrappers.sh]``
# script adds a symlink to access this script via ``/usr/bin/hugo``.
#
# ==== Arguments
#
# * *$@* (array): Original arguments (e.g. ``clean install``)


echo -e "$LOG_INFO Using the wrapper for hugo inside Docker from this Vagrantbox"
echo -e "$LOG_INFO Working dir = $(pwd)"


IMAGE="klakegg/hugo"
TAG="asciidoctor"

docker run -it --rm -p 7313:1313 \
  --volume "$(pwd):$(pwd)" \
  --workdir "$(pwd)" \
  "$IMAGE:$TAG" "$@"
