#!/usr/bin/env bash

# Find unit that yields N years, where 1 <= N <= 100

# secs/yr   :            31,536,000
# ms/yr     :        31,536,000,000
# us/yr     :    31,536,000,000,000
# timestamp : 1,754,322,494,686,876

print_help_and_exit() {
  cat <<EOF
  Usage: deduce-timestamp-units.sh TIMESTAMP

EOF
  exit "${1:-0}"
}

if [ $# -eq 0 ]; then
  print_help_and_exit 1
fi

declare -i ts="${1}"
declare -i s_per_yr=31536000
declare -i ms_per_yr=31536000000
declare -i us_per_yr=31536000000000
declare -i ns_per_yr=31536000000000000

if [ $ts -lt $s_per_yr ]; then
  echo "$ts is too small (must be $s_per_yr <= TIMESTAMP <= $ns_per_yr)" >&2
  exit 1
fi

declare -a sorted_units=("seconds" "milliseconds" "microseconds" "nanoseconds")
declare -i i=0
while [ $i -lt ${#sorted_units[@]} -a $((ts / 1000)) -ge $s_per_yr ]; do
  i=$((i + 1))
  ts=$((ts / 1000))
done
echo "${sorted_units[$i]}"

