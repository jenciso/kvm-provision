# KVM 

## PRE-REQUISITES

This code run on an Ubuntu 18 host machine. It need to have installed these packages:

```shell
sudo apt-get install qemu qemu-kvm libvirt-bin bridge-utils virt-manager libguestfs-tools
sudo service libvirtd start
sudo update-rc.d libvirtd enable
```

In order to create virtual machines, you should have a iso image or a qcow2 cloud image. We prefer centos7 cloud image. To download it, run:

```shell
URL_QCOW2_CENTOS7=http://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud.qcow2
URL_QCOW2_CENTOS8=https://cloud.centos.org/centos/8/x86_64/images/CentOS-8-GenericCloud-8.3.2011-20201204.2.x86_64.qcow2
URL_QCOW2_AMAZON2=https://cdn.amazonlinux.com/os-images/2.0.20201111.0/kvm/amzn2-kvm-2.0.20201111.0-x86_64.xfs.gpt.qcow2

sudo -E wget -P /var/lib/libvirt/boot/ $URL_QCOW2_CENTOS7
sudo -E wget -P /var/lib/libvirt/boot/ $URL_QCOW2_CENTOS8
sudo -E wget -P /var/lib/libvirt/boot/ $URL_QCOW2_AMAZON2
```

## GETTING STARTED

To create a virtual machine (VM), you need to modify the `config.conf` file in order to customize some features. Otherwise, you only need to specify the name of the VM and the VM will be create with the default configuration.

Example: creating a VM with the name `centos7`

```
./new-vm.sh centos7
```

Or using some arguments:

```
./new-vm.sh -n centos7 -m 1024 -c 2 -i 192.168.122.11 -t centos7
```

Post-installation steps:

```shell
source config.conf
export VM=centos7
sudo virsh change-media $VM hda --eject --config
sudo rm -f ${DATA_DIR}/${VM}/${VM}-cidata.iso
```

Finally, to destroy the vm named `centos7`

```shell
./del-vm.sh centos7
```

## TIPS

* How to add a second disk?

This command will create the `/dev/vdb` device with 60GB 

```shell
./add-disk.sh -n centos7 -d vdb -s 60G
```

## References

https://github.com/giovtorres/kvm-install-vm

