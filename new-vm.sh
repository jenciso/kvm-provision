#!/bin/bash

## Argument validation
die () {
    echo >&2 "$@"
    exit 1
}
[ "$#" -gt 0 ] || die "1 argument required, $# provided"

# Function: Print a help message.
usage() { 
  echo "Usage: $0 [ vm_name ] [ -n vm_name ] [ -m memory_mb ] [ -c num_cpus ] [ -i ip ]" 1>&2 
}

## Exports vars from config file
set -o allexport
source config.conf
set +o allexport

## Use the arguments passed to script file
while getopts n:m:c:i:h option ; do
  case "${option}" in 
    n) VM=${OPTARG};;
    m) VM_MEM=${OPTARG};;
    c) VM_CPU=${OPTARG};;
    i) IPADDR=${OPTARG};;
    h) usage && exit;;
    *) VM=${OPTARG};;
  esac
done

## Creating meta and user data
cat templates/user-data.template | envsubst > user-data
cat templates/meta-data.template | envsubst > meta-data

## Initializing configs
sudo mkdir -p ${DATA_DIR}/$VM
sudo cp /var/lib/libvirt/boot/CentOS-7-x86_64-GenericCloud.qcow2 ${DATA_DIR}/$VM/$VM.qcow2
export LIBGUESTFS_BACKEND=direct
sudo qemu-img create -f qcow2 -o preallocation=metadata ${DATA_DIR}/$VM/$VM.new.image ${DISK_SIZE}
sudo virt-resize --quiet --expand /dev/sda1 ${DATA_DIR}/$VM/$VM.qcow2 ${DATA_DIR}/$VM/$VM.new.image
sudo mv -f ${DATA_DIR}/$VM/$VM.new.image ${DATA_DIR}/$VM/$VM.qcow2
sudo mkisofs -o ${DATA_DIR}/$VM/$VM-cidata.iso -V cidata -J --input-charset iso8859-1 -r user-data meta-data
rm -f user-data user-head-data meta-data

## creating pool
sudo virsh pool-create-as --name $VM --type dir --target ${DATA_DIR}/$VM

## Creating VM
sudo virt-install --import --name $VM \
--memory ${VM_MEM} --vcpus ${VM_CPU} --cpu host \
--disk ${DATA_DIR}/$VM/$VM.qcow2,format=qcow2,bus=virtio \
--disk ${DATA_DIR}/$VM/$VM-cidata.iso,device=cdrom \
--network ${KVM_NETWORK_MODE},model=virtio \
--os-type=linux \
--os-variant=centos7.0 \
--graphics spice \
--noautoconsole

## Starting VM
sudo virsh autostart $VM
