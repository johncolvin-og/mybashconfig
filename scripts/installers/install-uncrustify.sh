#!/usr/bin/env bash

rootmost_existing_path() {
  local rv=$1
  while [[ ! -e "$rv" ]]; do
    rv=$(dirname "$rv")
  done
  echo "$rv"
}

DOWNLOAD=1
version=0.83.0
filestem=uncrustify-$version
install_dir=/usr/local/
repo_root_dir="$(readlink -f "$(dirname "${BASH_SOURCE[0]}")/../../..")"
work_dir="$repo_root_dir/.work"
dry_run=0

_run() {
  echo $@
  if [ $dry_run -eq 0 ]; then
    $@
  fi
}

_force_run() {
  echo $@
  $@
}

# Set up work dir
_run rm -rf "$work_dir"
_run mkdir -p "$work_dir"
_run cd "$work_dir"

# Download
if [ $DOWNLOAD -eq 1 ]; then
  _run curl -fLO https://github.com/uncrustify/uncrustify/releases/download/$filestem/$filestem.tar.gz
  ec=$?
  if [[ $ec -ne 0 ]]; then
    echo "Download failed"
    exit 1
  fi
fi

# Extract
set -e
_run tar -xf "$filestem.tar.gz"
if [ -d "$filestem" ]; then
  _run cd "$filestem"
elif [ -d "uncrustify-$filestem" ]; then
  _run cd "uncrustify-$filestem"
else
  echo "Did not find source dir after extract. Looked for $filestem or uncrustify-$filestem"
  exit 1
fi

# Build
_run mkdir build
_run cd build
_run cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$install_dir" ..
build_cmd="cmake --build . --target install"
rootmost_existing_install_dir="$(rootmost_existing_path "$install_dir")"
if [ ! -w "$rootmost_existing_install_dir" ]; then
  if [ ! -e "$install_dir" ]; then
    _run mkdir -p "$install_dir"
  fi
  build_cmd="sudo $build_cmd"
fi
_run "$build_cmd"
set +e
