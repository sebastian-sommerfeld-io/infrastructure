#!/bin/bash
# @file hadolint.sh
# @brief Wrapper to use hadolint from Docker container when using the default ``hadolint`` command.
#
# @description The script is a wrapper to use hadolint from a Docker container when using the default ``hadolint``
# command. The script delegates the all tasks to the hadolint runtime inside a container using image
# ``link:https://hub.docker.com/r/hadolint/hadolint[hadolint/hadolint]``.
#
# In order to use the ``hadolint`` command, the ``xref:src_main_vagrantboxes_pegasus_provision_configure.adoc[configure-wrappers.sh]``
# script adds a symlink to access this script via ``/usr/bin/hadolint``.
#
# ==== Arguments
#
# * *$@* (array): Original arguments


echo -e "$LOG_INFO Using the wrapper for hadolint inside Docker from this Vagrantbox"
echo -e "$LOG_INFO Working dir = $(pwd)"

IMAGE="hadolint/hadolint"
TAG="latest"

docker run -i --rm \
  --volume "$(pwd):$(pwd)" \
  --workdir "$(pwd)" \
  "$IMAGE:$TAG" "$@"

echo -e "$LOG_DONE Finished hadolint"
