#!/usr/bin/env bash

if [ "${!1:-x}" != "${!1}" ]; then
  exit 1
fi

