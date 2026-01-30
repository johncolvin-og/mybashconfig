#!/usr/bin/env bash

_exit() {
  if [[ "$#" -gt 1 ]]; then
    # When there are multiple args, the last arg is the exit code.
    echo "${@:1:($# - 1)}"
    exit "${@: -1}"
  fi
  echo "$1"
  exit 0
}

help_text=$(cat <<EOF
Usage: dirdiff.sh DIR1 DIR2
EOF
)

if [ $# -ne 2 ]; then
  _exit "$help_text" 1
fi

d1="$1"
d2="$2"
if [ ! -d "$d1" ]; then
  echo "'$d1' not a folder"
  _exit "$help_text" 1
fi
if [ ! -d "$d2" ]; then
  echo "'$d2' not a folder"
  _exit "$help_text" 1
fi

# declare -a children=$(ls "$dir")
# declare -a children1=$(ls "$d1")
# declare -a children2=$(ls "$d2")

mapfile -t children1 < <(ls "$d1")
mapfile -t children2 < <(ls "$d2")

i1=0
i2=0
len1=${#children1[@]}
len2=${#children2[@]}
declare -a common
declare -a unique1
declare -a unique2

while [ $i1 -lt $len1 ]; do
  s1="${children1[$i1]}"
  if [ ! $i2 -lt $len2 ]; then
    unique1+=("$s1")
    i1=$(($i1+1))
    continue
  fi
  s2=${children2[$i2]}
  # echo "Comparing s1: ${s1}"
  # echo "Comparing s2: ${s2}"
  # echo "Comparing s1: ${s1}, s2: ${s2}"
  if [ "$s2" == "$s1" ]; then
    common+=("$s1")
    i1=$(($i1+1))
    i2=$(($i2+1))
  elif [[ "$s2" < "$s1" ]]; then
    unique2+=("$s2")
    i2=$(($i2+1))
  else
    unique1+=("$s1")
    i1=$(($i1+1))
  fi
done

while [ $i2 -lt $len2 ]; do
  unique2+=(${children2[@]:$i2:$len2})
  i2=$(($i2+1))
done

to_json_array() {
  # If no arguments, output an empty JSON array
  (($# == 0)) && { printf '[]'; return; }

  # Otherwise, convert each arg to a JSON string and slurp into an array
  jq -Rs 'split("\n")[:-1]' <<<"$(printf '%s\n' "$@")"
}

jq -n \
  --argjson children1 "$(to_json_array "${children1[@]}")" \
  --argjson children2 "$(to_json_array "${children2[@]}")" \
  --argjson unique1 "$(to_json_array "${unique1[@]}")" \
  --argjson unique2 "$(to_json_array "${unique2[@]}")" \
  --argjson common "$(to_json_array "${common[@]}")" \
  '{dir1:$children1, dir2:$children2, unique1:$unique1, unique2:$unique2, common:$common}'
