#!/usr/bin/env bash

declare -i res="${#1}"
shift 1
for val in "$@"; do
  if [[ $res -lt ${#val} ]]; then
    res=${#val}
  fi
done
echo $res
