#!/bin/bash

## Exports vars from config file                                                                                                                                                                                    
set -o allexport
source .env
set +o allexport

## Function: Print a help message.
usage() { 
  echo "Usage: $0 [ -d disk_name ] [ -s disk_size ] vm_name" 1>&2
  exit 1
}

## Argument validation
die () {
    echo >&2 "$@"
    usage
    exit 1
}
[ "$#" -gt 0 ] || die "1 argument required, 0 provided"

## Use the arguments passed to script file
while getopts ":n:d:s:h:" option ; do
  case "${option}" in 
    d) DISK_NAME=${OPTARG};;
    s) DISK_SIZE=${OPTARG};;
    h) usage;;
  esac
done

shift $((OPTIND-1))
VM=$1

## Creating new disk
sudo qemu-img create -f qcow2 -o preallocation=metadata ${DATA_DIR}/${VM}/${VM}_${DISK_NAME}.qcow2 ${DISK_SIZE}
sudo virsh attach-disk --domain ${VM} ${DATA_DIR}/${VM}/${VM}_${DISK_NAME}.qcow2 --target ${DISK_NAME} --persistent --config --live
