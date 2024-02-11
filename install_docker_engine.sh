#!/bin/bash

sudo apt-get -y update

cd ~

path="https://download.docker.com/linux/ubuntu/dists/jammy/pool/stable/arm64"
arch="arm64"
version_containerdio="1.6.28-1"
version_docker_ce="25.0.3-1~ubuntu.22.04~jammy"
version_docker_ce_cli="25.0.3-1~ubuntu.22.04~jammy"
version_docker_buildx_plugin="0.12.1-1~ubuntu.22.04~jammy"
version_docker_compose_plugin="2.24.5-1~ubuntu.22.04~jammy"

filename_containerdio="containerd.io_${version_containerdio}_${arch}.deb"
filename_version_docker_ce="docker-ce_${version_docker_ce}_${arch}.deb"
filename_version_docker_ce_cli="docker-ce-cli_${version_docker_ce_cli}_${arch}.deb"
filename_version_docker_buildx_plugin="docker-buildx-plugin_${version_docker_buildx_plugin}_${arch}.deb"
filename_version_docker_compose_plugin="docker-compose-plugin_${version_docker_compose_plugin}_${arch}.deb"

sudo wget -N "${path}/${filename_containerdio}" \
  "${path}/${filename_version_docker_ce}" \
  "${path}/${filename_version_docker_ce_cli}" \
  "${path}/${filename_version_docker_buildx_plugin}" \
  "${path}/${filename_version_docker_compose_plugin}"


sudo dpkg -i ./${filename_containerdio} \
  ./${filename_version_docker_ce} \
  ./${filename_version_docker_ce_cli} \
  ./${filename_version_docker_buildx_plugin} \
  ./${filename_version_docker_compose_plugin}

sudo usermod -aG docker "$USER"
newgrp docker
exit 0