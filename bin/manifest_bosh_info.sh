#!/bin/bash

function usage {
  echo "USAGE: ./bin/manifest_bosh_info.sh path/to/manifest.yml"
  echo "Shows information about the BOSH director targeted by the manifest.yml"
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

manifest_path=$1; shift
  if [[ ! -f ${manifest_path} ]]; then
    usage
  fi

manifest_director_uuid=$(cat ${manifest_path} | yaml2json | jq -r .director_uuid)
  if [[ "${manifest_director_uuid}X" == "X" ]]; then
    echo "No director_uuid found in ${manifest_path}" >&2
    usage
  fi
