#!/bin/bash
# @file yamllint.sh
# @brief Wrapper to use yamllint from Docker container when using the default ``yamllint`` command.
#
# @description The script is a wrapper to use yamllint from a Docker container when using the default ``yamllint``
# command. The script delegates the all tasks to the yamllint runtime inside a container using image
# ``link:https://hub.docker.com/r/cytopia/yamllint[cytopia/yamllint]``.
#
# In order to use the ``yamllint`` command, the ``xref:src_main_vagrantboxes_pegasus_provision_configure.adoc[configure-wrappers.sh]``
# script adds a symlink to access this script via ``/usr/bin/yamllint``.
#
# ==== Arguments
#
# * *$@* (array): Original arguments


echo -e "$LOG_INFO Using the wrapper for yamllint inside Docker from this Vagrantbox"
echo -e "$LOG_INFO Working dir = $(pwd)"

IMAGE="cytopia/yamllint"
TAG="latest"

docker run -it --rm \
  --volume "$(pwd):$(pwd)" \
  --workdir "$(pwd)" \
  "$IMAGE:$TAG" "$@"

echo -e "$LOG_DONE Finished yamllint"
