#!/usr/bin/env bash

declare res="$1"
while [[ "${#res}" -lt ${2} ]]; do
  res="$res$3"
done
echo -n "$res"
