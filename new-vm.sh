#!/bin/bash

## Argument validation
die () {
    echo >&2 "$@"
    exit 1
}
[ "$#" -gt 0 ] || die "1 argument required, $# provided"

# Function: Print a help message.
usage() { 
  echo "Usage: $0 [ vm_name ] [ -n vm_name ] [ -m memory_mb ] [ -c num_cpus ] [ -i ip ] [ -s disk_size ] [ -q qcow2_image ] [ -t distro ]" 1>&2 
}

## Exports vars from config file
set -o allexport
source config.conf
set +o allexport

## Use the arguments passed to script file
while getopts n:m:c:i:s:q:t:h option ; do
  case "${option}" in 
    n) VM=${OPTARG};;
    m) VM_MEM=${OPTARG};;
    c) VM_CPU=${OPTARG};;
    i) IPADDR=${OPTARG};;
    s) DISK_SIZE=${OPTARG};;
    q) QCOW2_IMAGE=${OPTARG};;
    t) DISTRO=${OPTARG};;
    h) usage && exit;;
    *) VM=${OPTARG};;
  esac
done

## Initialize some vars

    case "${DISTRO}" in
        amazon2)
            export QCOW2_IMAGE=amzn2-kvm-2.0.20201111.0-x86_64.xfs.gpt.qcow2
            export OS_VARIANT="rhel8.0"
            export LOGIN_USER=ec2-user
            export USER_DATA_TPL=user-data
            ;;
        centos8)
            export QCOW2_IMAGE=CentOS-Stream-GenericCloud-8-20201217.0.x86_64.qcow2
            export OS_VARIANT="rhel8.0"
            export LOGIN_USER=centos
            export USER_DATA_TPL=user-data
            ;;
        centos7)
            export QCOW2_IMAGE=CentOS-7-x86_64-GenericCloud.qcow2
            export OS_VARIANT="centos7.0"
            export LOGIN_USER=centos
            export USER_DATA_TPL=user-data
            ;;
        ubuntu18)
            export QCOW2_IMAGE=ubuntu-18.04-server-cloudimg-amd64.img
            export OS_VARIANT="ubuntu18.04"
            export LOGIN_USER=ubuntu
            export USER_DATA_TPL=user-data.ubuntu
            ;;
        ubuntu22)
            export QCOW2_IMAGE=ubuntu-22.04-server-cloudimg-amd64.img
            export OS_VARIANT="ubuntu22.04"
            export LOGIN_USER=ubuntu
            export USER_DATA_TPL=user-data.ubuntu
            ;;
        *)
            die "${DISTRO} not a supported OS.  Specifiy a linux distro using -t. Ex '-t centos7'."
            ;;
    esac

## Creating meta and user data
TPM_WORKDIR=`mktemp -d -t XXX`

## Create template meta-data and user-data
cat << EOF > ${TPM_WORKDIR}/meta-data
instance-id: ${VM}
local-hostname: ${VM}
EOF

cat templates/${USER_DATA_TPL}.tpl | envsubst > ${TPM_WORKDIR}/user-data

if [[ ${DHCP_CLIENT} == "true" ]]; then
  cat templates/${USER_DATA_TPL}.dhcp.tpl | envsubst > ${TPM_WORKDIR}/user-data
fi

## Setup data directory
sudo mkdir -p ${DATA_DIR}/$VM
sudo cp /var/lib/libvirt/boot/${QCOW2_IMAGE} ${DATA_DIR}/$VM/$VM.qcow2
export LIBGUESTFS_BACKEND=direct

case "${DISTRO}" in
  ubuntu*|amazon2)
    sudo qemu-img resize ${DATA_DIR}/$VM/$VM.qcow2 ${DISK_SIZE}
    ;;
  *)
    sudo qemu-img create -f qcow2 -o preallocation=off ${DATA_DIR}/$VM/$VM.new.image ${DISK_SIZE}
    sudo virt-resize --quiet --expand /dev/sda1 ${DATA_DIR}/$VM/$VM.qcow2 ${DATA_DIR}/$VM/$VM.new.image
    sudo mv -f ${DATA_DIR}/$VM/$VM.new.image ${DATA_DIR}/$VM/$VM.qcow2
    ;;
esac

sudo mkisofs -o ${DATA_DIR}/$VM/$VM-cidata.iso -V cidata -J --input-charset iso8859-1 -r ${TPM_WORKDIR}/user-data ${TPM_WORKDIR}/meta-data
#rm -f ${TPM_WORKDIR}/user-data ${TPM_WORKDIR}/meta-data

## creating pool
sudo virsh pool-create-as --name $VM --type dir --target ${DATA_DIR}/$VM

## Creating VM
sudo virt-install --import --name $VM \
--memory ${VM_MEM} --vcpus ${VM_CPU} --cpu host \
--disk ${DATA_DIR}/$VM/$VM.qcow2,format=qcow2,bus=virtio \
--disk ${DATA_DIR}/$VM/$VM-cidata.iso,device=cdrom \
--network ${KVM_NETWORK_MODE},model=virtio \
--os-variant=${OS_VARIANT} \
--graphics spice \
--noautoconsole

## Automatically startup when the host machine initialize its boot process
if [[ ${AUTOSTART} == "true" ]]; then
  sudo virsh autostart $VM
fi

## Eject iso media. This change will be applied in the next reboot
sudo virsh change-media $VM sda --eject --config
sudo rm -f ${DATA_DIR}/${VM}/${VM}-cidata.iso
