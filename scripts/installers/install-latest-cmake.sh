#!/usr/bin/env bash

# Stolen from https://askubuntu.com/questions/355565/how-do-i-install-the-latest-version-of-cmake-from-the-command-line

declare -r kitware_archive_url="https://apt.kitware.com/keys/kitware-archive-latest.asc"
declare -r kitware_apt_repo_url="https://apt.kitware.com/ubuntu/"
declare -r kitware_pub_key="6AF7F09730B3F0A4"
declare -r ubuntu_keyserver_url="keyserver.ubuntu.com"
declare -r kitware_gpg_file="/etc/apt/trusted.gpg.d/kitware.gpg"

(wget -O - "$kitware_archive_url" 2> /dev/null \
  | gpg --dearmor - \
  | sudo tee "$kitware_gpg_file" > /dev/null) \
  && sudo apt update \
  && sudo apt-add-repository "deb $kitware_apt_repo_url $(lsb_release -cs) main" \
  && sudo apt update \
  && sudo apt install kitware-archive-keyring \
  && sudo rm "$kitware_gpg_file" \
  && (sudo apt update || (sudo apt-key adv --keyserver "$ubuntu_keyserver_url" --recv-keys "$kitware_pub_key" && sudo apt update)) \
  && (sudo apt purge --auto-remove cmake; sudo apt install cmake)
