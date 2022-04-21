#!/bin/bash
# @file shellcheck.sh
# @brief Wrapper to use shellcheck from Docker container when using the default ``shellcheck`` command.
#
# @description The script is a wrapper to use shellcheck from a Docker container when using the default ``shellcheck``
# command. The script delegates the all tasks to the shellcheck runtime inside a container using image
# ``link:https://hub.docker.com/r/koalaman/shellcheck[koalaman/shellcheck]``.
#
# In order to use the ``shellcheck`` command, the ``xref:src_main_vagrantboxes_pegasus_provision_configure.adoc[configure.sh]``
# script adds a symlink to access this script via ``/usr/bin/shellcheck``.
#
# ==== Arguments
#
# * *$@* (array): Original arguments


echo -e "$LOG_INFO Using the wrapper for shellcheck inside Docker from this Vagrantbox"
echo -e "$LOG_INFO Working dir = $(pwd)"

IMAGE="koalaman/shellcheck"
TAG="latest"

docker run -it --rm \
  --volume "$(pwd):$(pwd)" \
  --workdir "$(pwd)" \
  "$IMAGE:$TAG" "$@"

echo -e "$LOG_DONE Finished shellcheck"
