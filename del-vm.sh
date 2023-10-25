#!/bin/bash

## Exports vars
set -o allexport
source .env
set +o allexport

## Function: Print a help message.
usage() {
  echo "Usage: $0 vm_name" 1>&2
  exit 1
}

## Arguments validation
die () {
    echo >&2 "$@"
    usage
    exit 1
}
[ "$#" -eq 1 ] || die "1 argument required, $# provided"

VM=$1

sudo virsh shutdown ${VM}
sudo virsh undefine ${VM}
sudo virsh pool-destroy ${VM}
sudo rm -rf ${DATA_DIR}/${VM}