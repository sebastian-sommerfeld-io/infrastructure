#!/bin/bash
# @file mvn.sh
# @brief Wrapper to use Maven from Docker container when using the default ``mvn`` command.
#
# @description The script is a wrapper to use Maven from a Docker container when using the default ``mvn`` command.
# The script delegates the Maven commands to a container using image ``link:https://hub.docker.com/_/maven[maven]``.
#
# image::https://raw.githubusercontent.com/docker-library/docs/e2782b8942c1af41419536078c8d0176665a005d/maven/logo.png[]
#
# In order to use the ``mvn`` command, the ``xref:src_main_vagrantboxes_pegasus_provision_configure.adoc[configure-wrappers.sh]``
# script adds a symlink to access this script via ``/usr/bin/mvn``.
#
# The maven installation from inside the container shares its repository with the host. The maven home directory is
# located at ``/home/vagrant/.m2`` on the Docker host (with the host being the Vagrantbox ``pegasus``).
#
# ==== Arguments
#
# * *$@* (array): Original maven arguments (e.g. ``clean install``)


echo -e "$LOG_INFO Using the wrapper for Maven inside Docker from this Vagrantbox"
echo -e "$LOG_INFO Working dir = $(pwd)"

IMAGE="maven"
TAG="3.8.4-openjdk-17"

docker run -it --rm \
  --volume /home/vagrant/.m2:/root/.m2 \
  --volume "$(pwd):$(pwd)" \
  --workdir "$(pwd)" \
  "$IMAGE:$TAG" mvn "$@"
