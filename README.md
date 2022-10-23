# KVM PROVISION

## Getting Started

### Pre-requisites

This provision process was tested in Ubuntu 22.04, it need some packages as pre-requisites.

```
sudo apt-get install qemu \
  qemu-kvm \
  libvirt-bin \
  bridge-utils \
  virt-manager \
  libguestfs-tools \
  genisoimage

sudo service libvirtd start && sudo update-rc.d libvirtd enable
```

To download the qcow2 cloud image, define its URL:

```
URL_QCOW2=https://cloud-images.ubuntu.com/releases/22.04/release/ubuntu-22.04-server-cloudimg-amd64.img
URL_QCOW2=http://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud.qcow2
URL_QCOW2=https://cloud.centos.org/centos/8-stream/x86_64/images/CentOS-Stream-GenericCloud-8-20201217.0.x86_64.qcow2
URL_QCOW2=https://cdn.amazonlinux.com/os-images/2.0.20201111.0/kvm/amzn2-kvm-2.0.20201111.0-x86_64.xfs.gpt.qcow2
```
Now, download it:

```
sudo -E wget -P /var/lib/libvirt/boot/ $URL_QCOW2
```

### provisioning a VM

To create a virtual machine (VM), you need to modify the `.env` file to customize your VM. You can use `.env.sample` to know more about the configuration. Example: creating a VM with the name `centos7`
```
./new-vm.sh -n ubuntu
```
Or using arguments:
```
./new-vm.sh -n ubuntu -m 1024 -c 2 -i 192.168.122.10 -s 10G -t ubuntu22
```

Post-installation steps (optional):
```
source .env
export VM=ubuntu
sudo -E virsh change-media $VM hda --eject --config
sudo -E rm -f ${DATA_DIR}/${VM}/${VM}-cidata.iso
```

### Destroying VM
```
./del-vm.sh -n ubuntu
```

### Aditional settings

* How to add a second disk?
```
./add-disk.sh -n centos7 -d vdb -s 60G
```

* How to provision a amazon linux?
```
./new-vm.sh -n amazon-demo -m 1024 -c 2 -i 192.168.122.11 -s 10G -t amazon2
```

* How to enable DHCP?
```
DHCP_CLIENT=true
```

## References

- https://github.com/giovtorres/kvm-install-vm
- https://blog.programster.org/kvm-missing-default-network
- https://medium.com/@art.vasilyev/use-ubuntu-cloud-image-with-kvm-1f28c19f82f8
