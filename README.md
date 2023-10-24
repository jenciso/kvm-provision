# KVM PROVISION

## Getting Started

This VM provision process was tested running on:

- Ubuntu 22.04
- Amazon Linux

### Pre-Install

Install libvirt and qemu packages:
```
sudo apt-get install qemu \
  qemu-kvm \
  libvirt-daemon-system \
  libvirt-clients \
  bridge-utils \
  virt-manager \
  libguestfs-tools \
  genisoimage

sudo systemctl start libvirtd && sudo systemctl enable libvirtd
```

Download Qcow2 cloud images:
```
URL_QCOW2=https://cloud-images.ubuntu.com/releases/22.04/release/ubuntu-22.04-server-cloudimg-amd64.img
URL_QCOW2=http://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud.qcow2
URL_QCOW2=https://cloud.centos.org/centos/8-stream/x86_64/images/CentOS-Stream-GenericCloud-8-20201217.0.x86_64.qcow2
URL_QCOW2=https://cdn.amazonlinux.com/os-images/2.0.20230926.0/kvm/amzn2-kvm-2.0.20230926.0-x86_64.xfs.gpt.qcow2

sudo -E wget -P /var/lib/libvirt/boot/ $URL_QCOW2
```
### Provision a VM

Modify the `.env` file to define some parameters. You can use `.env.sample` to know more about them.

Creating a VM named `ubuntu`
```
./new-vm.sh -n ubuntu
```
You can use arguments to specify some features:
```
./new-vm.sh -n ubuntu -m 1024 -c 2 -i 192.168.122.10 -s 10G -t ubuntu22
```

Post-install steps (optional):
```
source .env
export VM=ubuntu
sudo -E virsh change-media $VM hda --eject --config
sudo -E rm -f ${DATA_DIR}/${VM}/${VM}-cidata.iso
```

### Destroy VM
```
./del-vm.sh ubuntu
```
### Aditional settings

* How to add a second hard disk?
```
./add-disk.sh -n centos7 -d vdb -s 60G
```

* How to provision a amazon linux VM?
```
./new-vm.sh -n amazon-demo -m 1024 -c 2 -i 192.168.122.11 -s 10G -t amazon2
```

* How to enable DHCP?
```
DHCP_CLIENT=true
```

* How to know the VM's IP address?
```
virsh domifaddr $VM
```

## References

- https://github.com/giovtorres/kvm-install-vm
- https://blog.programster.org/kvm-missing-default-network
- https://medium.com/@art.vasilyev/use-ubuntu-cloud-image-with-kvm-1f28c19f82f8
