#!/bin/bash
# @file git.sh
# @brief Wrapper to use git from Docker container when using the default ``git`` command.
#
# @description The script is a wrapper to use git from a Docker container when using the default ``git`` command.
# The script delegates the git commands to a container using image ``pegasus/git``.
#
# In order to use the ``git`` command, the ``xref:src_main_vagrantboxes_pegasus_provision_configure.adoc[configure.sh]``
# script adds a symlink to access this script via ``/usr/bin/git``. Beforehand ``xref:src_main_vagrantboxes_pegasus_provision_uninstall.adoc[uninstall.sh]``
# removes the git installation which is shipped with the Vagrant Base Box for Ubuntu.
#
# Why use git inside a docker container instead of a normal installation?
#
# * Reduced dependencies of the Vagrantbox -> No need for the host to provide a .gitconfig file (only ssh certs are provided by the host)
#
# ==== Arguments
#
# * *$@* (array): Original arguments (e.g. ``clean install``)


echo -e "$LOG_INFO Using the wrapper for git inside Docker from this Vagrantbox"
echo -e "$LOG_INFO Working dir = $(pwd)"

IMAGE="pegasus/git"
TAG="latest"

docker run -t --rm  \
  --volume "/home/vagrant/.ssh:/home/bitnami/.ssh:ro" \
  --volume "$(pwd):$(pwd)" \
  --workdir "$(pwd)" \
  "$IMAGE:$TAG" git "$@"
