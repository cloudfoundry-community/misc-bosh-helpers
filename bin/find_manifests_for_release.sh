#!/bin/bash

function usage {
  echo "USAGE: ./bin/find_manifests_for_release.sh release [path]"
  echo "Finds BOSH manifests beneath target path that use release, e.g. find_manifests_for_release.sh cf"
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

release_name=$1; shift
path=$1; shift
path=${path:-"."}

  if [[ "${release_name}X" == "X" ]]; then
    usage
  fi

possible_manifests=$(find ${path} -type f  -name '*.yml')
for file in ${possible_manifests}; do
  found=$(cat $file | yaml2json | jq -r .releases[].name | grep "^${release_name}$")
  if [[ "${found}X" != "X" ]]; then
    echo $file
  fi
done
