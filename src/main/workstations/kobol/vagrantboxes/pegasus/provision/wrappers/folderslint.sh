#!/bin/bash
# @file folderslint.sh
# @brief Wrapper to use folderslint from Docker container when using the default ``folderslint`` command.
#
# @description The script is a wrapper to use folderslint from a Docker container when using the default ``folderslint``
# command. The script delegates the all tasks to the folderslint runtime inside a container.
#
# In order to use the ``folderslint`` command, the ``xref:src_main_vagrantboxes_pegasus_provision_configure.adoc[configure.sh]``
# script adds a symlink to access this script via ``/usr/bin/folderslint``.
#
# ==== Arguments
#
# * *$@* (array): Original arguments


echo -e "$LOG_INFO Using the wrapper for folderslint inside Docker from this Vagrantbox"
echo -e "$LOG_INFO Working dir = $(pwd)"

IMAGE="pegasus/folderslint"
TAG="latest"

docker run -i --rm \
  --volume "$(pwd):$(pwd)" \
  --workdir "$(pwd)" \
  "$IMAGE:$TAG" folderslint "$@"

echo -e "$LOG_DONE Finished folderslint"
