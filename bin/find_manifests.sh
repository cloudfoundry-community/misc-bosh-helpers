#!/bin/bash

function usage {
  echo "USAGE: ./bin/find_manifests.sh [path]"
  echo "Finds BOSH manifests YAML files beneath target path"
  exit 1
}
while getopts ":h" opt; do
  case $opt in
    h)
      usage
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

path=$1; shift
path=${path:-"."}

possible_manifests=$(find ${path} -type f  -name '*.yml')
for file in ${possible_manifests}; do
  director_uuid=$(cat ${file} | yaml2json | jq -r .director_uuid)
  if [[ "${director_uuid}" != "null" ]]; then
    echo $file
  fi
done
