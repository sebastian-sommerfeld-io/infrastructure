#!/bin/bash
# @file build-docker-images.sh
# @brief Provisioning script for Vagrantbox ``pegasus``.
#
# @description The scripts builds docker images from this repository (src/main/ pegasus/docker/images) in
# order to run the respective container. For started images see ``src/main/ pegasus/services/docker-compose.yml``.
#
# IMPORTANT: DON'T RUN THIS SCRIPT DIRECTLY - Script is invoked by Vagrant during link:https://www.vagrantup.com/docs/provisioning[provisioning].
#
# ==== Arguments
#
# The script does not accept any parameters.

export IMAGE_PREFIX="pegasus"
export IMAGE_TAG="latest"

# @description Build docker image to use inside vagrantbox.
#
# @arg $1 string image_name (= directory containing the Dockerfile) - mandatory
function buildImage() {
  if [ -z "$1" ]
  then
    echo "[ERROR] Param missing: image_name"
    echo "[ERROR] exit"
    exit 0
  fi

  echo "[INFO] Building '$IMAGE_PREFIX/$1:$IMAGE_TAG'"
  (
    cd "/vagrant/docker/images/$1" || exit

    echo "[INFO] Build image"
    docker build -t "$IMAGE_PREFIX/$1:$IMAGE_TAG" .
  )
  echo "[DONE] Finished building '$IMAGE_PREFIX/$1:$IMAGE_TAG'"
}

# todo ... iterate folders
buildImage "adoc-antora"
buildImage "folderslint"
buildImage "ftp-client"
buildImage "git"
buildImage "jq"
buildImage "rundeck"
buildImage "rundeck-cli"
buildImage "yq"
