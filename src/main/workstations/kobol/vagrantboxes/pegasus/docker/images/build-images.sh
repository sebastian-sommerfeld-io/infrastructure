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
#
# @exitcode 0 If successful.
# @exitcode 1 If param is missing
function buildImage() {
  if [ -z "$1" ]
  then
    echo "[ERROR] Param missing: image_name"
    echo "[ERROR] exit" && exit 1
  fi

  echo "[INFO] Building '$IMAGE_PREFIX/$1:$IMAGE_TAG'"
  (
    cd "/vagrant/docker/images/$1" || exit
    docker build -t "$IMAGE_PREFIX/$1:$IMAGE_TAG" .
  )
  echo "[DONE] Finished building '$IMAGE_PREFIX/$1:$IMAGE_TAG'"
}

echo "[INFO] Build docker images"
(
  cd /vagrant/docker/images || exit

  for dir in */ ; do
    image=${dir%*/}
    echo "[INFO] Build image from folder $image"
    buildImage "$image"
  done
)
