#!/bin/bash

die () {
    echo >&2 "$@"
    exit 1
}
[ "$#" -eq 1 ] || die "1 argument required, $# provided"

## Exports vars
set -o allexport
source config.conf
set +o allexport

VM=$1

sudo virsh shutdown ${VM}
sudo virsh undefine ${VM}
sudo virsh pool-destroy ${VM}
sudo rm -rf ${DATA_DIR}/${VM}
