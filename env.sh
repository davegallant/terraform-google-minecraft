#!/usr/bin/env bash

set -euxo pipefail

docker_image_name=terraform-google-minecraft

export DOCKER_BUILDKIT=1

docker build --build-arg LOCAL_UID="$(id -u)" . -t $docker_image_name

docker run \
  -v "$PWD":/home/nix \
  -v "$HOME/.config/gcloud:/root/.config/gcloud" \
  -ti \
  $docker_image_name
