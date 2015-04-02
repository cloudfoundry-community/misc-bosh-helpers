#!/bin/bash

function usage {
  echo "USAGE: ./bin/find_micro_bosh.sh [path]"
  echo "Finds Micro BOSH manifests"
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

path=${path:-"."}

possible_manifests=$(find ${path} -type f  -name '*.yml')
for file in ${possible_manifests}; do
  cloud_plugin=$(cat ${file} | yaml2json | jq -r .cloud.plugin)
  if [[ "${cloud_plugin}" != "null" ]]; then
    echo $file
  fi
done
