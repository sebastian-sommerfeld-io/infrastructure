#!/bin/bash
# @file yq.sh
# @brief Wrapper to use Groovy from Docker container when using the ``yq`` command.
#
# @description The script is a wrapper to use Groovy from a Docker container when using the ``yq`` command. The script
# delegates the all tasks to the yq installation runtime inside a custom container using image.
#
# In order to use the ``yq`` command, the ``xref:src_main_vagrantboxes_pegasus_provision_configure.adoc[configure.sh]``
# script adds a symlink to access this script via ``/usr/bin/yq``.
#
# yq a lightweight and portable command-line YAML, JSON and XML processor. For more details, see
# https://github.com/mikefarah/yq or https://mikefarah.gitbook.io/yq.
#
# ==== Arguments
#
# * *$@* (array): Original arguments


echo -e "$LOG_INFO Using the wrapper for Groovy inside Docker from this Vagrantbox"
echo -e "$LOG_INFO Working dir = $(pwd)"

IMAGE="pegasus/yq"
TAG="latest"

docker run -it --rm \
  --volume "$(pwd):$(pwd)" \
  --workdir "$(pwd)" \
  "$IMAGE:$TAG" yq "$@"
