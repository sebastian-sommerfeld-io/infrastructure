#!/bin/bash
# @file node.sh
# @brief Install node and npm.
#
# @description The script installs link:https://nodejs.org/en[node] via apt and installs some node applications globally.
#
# * @antora/cli@2.3 @antora/site-generator-default@2.3
# * gulp-cli
# * webserver
#
# IMPORTANT: DON'T RUN THIS SCRIPT DIRECTLY - Script is invoked by Vagrant during link:https://www.vagrantup.com/docs/provisioning[provisioning].
#
# ==== Arguments
#
# The script does not accept any parameters.

(
  echo "[INFO] Install node and npm"
  cd /home/vagrant || exit

  curl -sL https://deb.nodesource.com/setup_17.x | sudo -E bash -
  sudo apt-get install -y nodejs
  npm install -g npm@latest

  echo "[INFO] node version = $(node --version)"
  echo "[INFO] npm version = $(npm --version)"
  echo "[DONE] Installed node and npm"
)

echo "[INFO] Install node apps"

npm install --global @antora/cli@2.3 @antora/site-generator-default@2.3
npm install --global gulp-cli
npm install --global webserver

echo "[DONE] Installed node apps"