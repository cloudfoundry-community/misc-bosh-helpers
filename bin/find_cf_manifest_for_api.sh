#!/bin/bash

function usage {
  echo "USAGE: ./bin/find_cf_manifest_for_api.sh [-p path] [-u uri]"
  echo "Finds CF BOSH manifest for a CF API (-u uri); or show all APIs for all CF manifests"
  exit 1
}
while getopts ":hp:u:" opt; do
  case $opt in
    p)
      path=$OPTARG
      ;;
    u)
      api_hostname=$OPTARG
      ;;
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

cf_manifests=$(./bin/find_manifests_for_release.sh cf ${path})
for file in ${cf_manifests}; do
  srv_api_uri=$(cat $file | yaml2json | jq -r ".properties.cc.srv_api_uri")
  if [[ "${api_hostname}X" != "X" ]]; then
    if [[ $srv_api_uri =~ $api_hostname ]]; then
      echo $file $srv_api_uri
    fi
  else
    echo $file $srv_api_uri
  fi
done
