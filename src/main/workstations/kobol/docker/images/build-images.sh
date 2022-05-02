#!/bin/bash
# @file build-docker-images.sh
# @brief Build images for workstation kobol.
#
# @description The scripts builds docker images from this repository in order to run the respective container.
#
# ==== Arguments
#
# The script does not accept any parameters.

export IMAGE_PREFIX="kobol"
export IMAGE_TAG="latest"

# @description Build docker image.
#
# @arg $1 string image_name (= directory containing the Dockerfile) - mandatory
#
# @exitcode 0 If successful.
# @exitcode 1 If param is missing
function buildImage() {
  if [ -z "$1" ]; then
    echo -e "$LOG_ERROR Param missing: image_name"
    echo -e "$LOG_ERROR exit" && exit 1
  fi

  echo -e "$LOG_INFO Building '$IMAGE_PREFIX/$1:$IMAGE_TAG'"
  (
    cd "$1" || exit
    echo -e "$LOG_INFO Build image"
    docker build -t "$IMAGE_PREFIX/$1:$IMAGE_TAG" .
  )
  echo -e "$LOG_DONE Finished building '$IMAGE_PREFIX/$1:$IMAGE_TAG'"
}

echo -e "$LOG_INFO Build docker images"
for dir in */ ; do
  image=${dir%*/}
  echo -e "$LOG_INFO Build image from folder $image"
  buildImage "$image"
done
