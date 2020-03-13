#!/bin/bash

## Argument validation
die () {
    echo >&2 "$@"
    exit 1
}
[ "$#" -gt 0 ] || die "1 argument required, $# provided"

# Function: Print a help message.
usage() { 
  echo "Usage: $0 [ -n vm_name ] [ -d disk_name ] [ -s disk_size ]" 1>&2 
}

## Exports vars from config file                                                                                                                                                                                    
set -o allexport                                                                                                                                                                                                    
source config.conf                                                                                                                                                                                                  
set +o allexport  

## Use the arguments passed to script file
while getopts n:d:s:h option ; do
  case "${option}" in 
    n) VM=${OPTARG};;
    d) DISK_NAME=${OPTARG};;
    s) DISK_SIZE=${OPTARG};;
    h) usage && exit;;
  esac
done

## Creating new disk
sudo qemu-img create -f qcow2 -o preallocation=metadata ${DATA_DIR}/${VM}/${VM}_${DISK_NAME}.qcow2 ${DISK_SIZE}
sudo virsh attach-disk --domain ${VM} ${DATA_DIR}/${VM}/${VM}_${DISK_NAME}.qcow2 --target ${DISK_NAME} --persistent --config --live
