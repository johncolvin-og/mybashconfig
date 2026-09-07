#!/usr/bin/env bash

usage() {
  cat <<EOF
Usage: ram-usage.sh [OPTIONS]

Options:
  --unit             The units of memory to show (defaults to KiB)
  -h,--help          Print this help message and exit

EOF

  exit "${1:-0}"
}


declare units="KiB"

while [ $# -gt 0 ]; do
  case "$1" in
    --unit)
      if [ -z "$2" ]; then
        echo "Unit (--unit) must be non-empty"
        usage 1
      fi
      units="$2"
      shift
      ;;
    -h)
      ;&
    --help)
      usage
      ;;
    *)
      echo "Unexpected argument '$1'"
      usage 1
      ;;
  esac
  shift
done

list_ram_cmd="ps -u $USER -eo rss"
case "$units" in
  b)
    $list_ram_cmd | awk '{x+=$1} END { print (x*8*1024)" b" }'
    ;;
  B)
    $list_ram_cmd | awk '{x+=$1} END { print (x*1024)" B" }'
    ;;
  kb)
    $list_ram_cmd | awk '{x+=$1} END { print (x*8*1024/1000)" kb" }'
    ;;
  KB)
    $list_ram_cmd | awk '{x+=$1} END { print (x*1024/1000)" KB" }'
    ;;
  kib)
    $list_ram_cmd | awk '{x+=$1} END { print (x*8)" kib" }'
    ;;
  KiB)
    $list_ram_cmd | awk '{x+=$1} END { print x" KiB" }'
    ;;
  mb)
    $list_ram_cmd | awk '{x+=$1} END { print (x*8*1024/1000000)" mb" }'
    ;;
  MB)
    $list_ram_cmd | awk '{x+=$1} END { print (x*1024/1000000)" MB" }'
    ;;
  mib)
    $list_ram_cmd | awk '{x+=$1} END { print (x*8*(1024/1000000))" mib" }'
    ;;
  MiB)
    $list_ram_cmd | awk '{x+=$1} END { print (x/1024)" MiB" }'
    ;;
  gb)
    $list_ram_cmd | awk '{x+=$1} END { print (x*8*1024/1000000000)" gb" }'
    ;;
  GB)
    $list_ram_cmd | awk '{x+=$1} END { print (x*1024/1000000000)" GB" }'
    ;;
  gib)
    $list_ram_cmd | awk '{x+=$1} END { print (x*8/(1024*1024))" gib" }'
    ;;
  GiB)
    $list_ram_cmd | awk '{x+=$1} END { print (x/(1024*1024))" GiB" }'
    ;;
esac
