#!/bin/bash

## Argument validation
die () {
    echo >&2 "$@"
    exit 1
}
[ "$#" -gt 0 ] || die "1 argument required, $# provided"

# Function: Print a help message.
usage() { 
  echo "Usage: $0 [ VM ] [ -n VM ] [ -i IPADDR ]" 1>&2 
}

## Exports vars from config file
set -o allexport
source config.conf
set +o allexport

## Use the arguments passed to script file
while getopts n:i:h option ; do
  case "${option}" in 
    n) VM=${OPTARG};;
    i) IPADDR=${OPTARG};;
    h) usage && exit;;
    *) VM=${OPTARG};;
  esac
done

## Creating meta and user data
cat templates/user-data.template | envsubst > user-data
cat templates/meta-data.template | envsubst > meta-data

## Initializing the configuration
sudo mkdir -p ${DATA_DIR}/$VM
sudo cp /var/lib/libvirt/boot/CentOS-7-x86_64-GenericCloud.qcow2 ${DATA_DIR}/$VM/$VM.qcow2
export LIBGUESTFS_BACKEND=direct
sudo qemu-img create -f qcow2 -o preallocation=metadata ${DATA_DIR}/$VM/$VM.new.image ${DISK_SIZE}
sudo virt-resize --quiet --expand /dev/sda1 ${DATA_DIR}/$VM/$VM.qcow2 ${DATA_DIR}/$VM/$VM.new.image
sudo mv -f ${DATA_DIR}/$VM/$VM.new.image ${DATA_DIR}/$VM/$VM.qcow2
sudo mkisofs -o ${DATA_DIR}/$VM/$VM-cidata.iso -V cidata -J --input-charset iso8859-1 -r user-data meta-data
rm -f user-data user-head-data meta-data

sudo virsh pool-create-as --name $VM --type dir --target ${DATA_DIR}/$VM

sudo virt-install --import --name $VM \
--memory 1024 --vcpus 1 --cpu host \
--disk ${DATA_DIR}/$VM/$VM.qcow2,format=qcow2,bus=virtio \
--disk ${DATA_DIR}/$VM/$VM-cidata.iso,device=cdrom \
--network ${KVM_NETWORK_MODE},model=virtio \
--os-type=linux \
--os-variant=centos7.0 \
--graphics spice \
--noautoconsole

sudo virsh autostart $VM
