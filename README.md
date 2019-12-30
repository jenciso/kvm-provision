## KVM 

### PRE-REQUISITES

For Ubuntu host, you need to install these packages:

```
sudo apt-get install qemu qemu-kvm libvirt-bin bridge-utils virt-manager libguestfs-tools
sudo service libvirtd start
sudo update-rc.d libvirtd enable
```

Download the qcow2 cloud image

```
wget http://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud.qcow2 \
  -O /var/lib/libvirt/boot/CentOS-7-x86_64-GenericCloud.qcow2 
```

### CREATE A VM

Change the config file: `config.conf` and in order to create a `centos7` vm, run:
```
./new-vm.sh centos7
```
or
```
./new-vm.sh -n centos7 -m 1024 -c 2 -i 192.168.122.11
```

Post install
```
source config.conf
export VM=centos7
sudo virsh change-media $VM hda --eject --config
sudo rm -f ${DATA_DIR}/${VM}/${VM}-cidata.iso
```

To delete a vm named `centos7`
```
./delete-vm.sh centos7
```


### Notes:

In any moment you could to pause or break your download, in order to continue the process, use -c flag

```
sudo wget -c http://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud.qcow2   -O /var/lib/libvirt/boot/CentOS-7-x86_64-GenericCloud.qcow2
```
