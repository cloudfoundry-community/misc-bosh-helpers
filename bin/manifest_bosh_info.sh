#!/bin/bash

while getopts ":h" opt; do
  case $opt in
    h)
      echo "USAGE: ./bin/manifest_bosh_info.sh path/to/manifest.yml"
      echo "Shows information about the BOSH director targeted by the manifest.yml"
      exit 0
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done
