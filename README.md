# KVM 

## PRE-REQUISITES

Before to use this tool, you need to install these packages (Ubuntu host):

```shell
sudo apt-get install qemu qemu-kvm libvirt-bin bridge-utils virt-manager libguestfs-tools
sudo service libvirtd start
sudo update-rc.d libvirtd enable
```

Also, in order to create virtual machines, you should have a iso image or a qcow2 cloud image. We prefer centos7 cloud image. To download it, run:

```shell
wget http://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud.qcow2 \
  -O /var/lib/libvirt/boot/CentOS-7-x86_64-GenericCloud.qcow2 
```

## GETTING STARTED

To create a virtual machine (VM), you need to modify the `config.conf` file in order to customize some features. Otherwise, you only need to specify the name of the VM and the VM will be create with the default configuration.

Example: creating a VM with the name `centos7`

```
./new-vm.sh centos7
```

Or using some arguments:

```
./new-vm.sh -n centos7 -m 1024 -c 2 -i 192.168.122.11
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

* How to get the centos7 cloud image using a slower internet connection?

If your download is slower, you could use `-c` flag to continue downloading to get after each broke connections

```shell
sudo wget -c http://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud.qcow2 \
  -O /var/lib/libvirt/boot/CentOS-7-x86_64-GenericCloud.qcow2
```
