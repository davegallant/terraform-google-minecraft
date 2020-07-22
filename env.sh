#!/usr/bin/env bash

set -euxo pipefail

docker_image_name=terraform-google-minecraft

export DOCKER_BUILDKIT=1

docker build . -t $docker_image_name

docker run \
  -u "$(id -u):$(id -g)" \
  -v "$PWD":/terraform \
  -w /terraform \
  -v "$HOME/.config/gcloud:/home/nix/.config/gcloud" \
  -ti \
  $docker_image_name
