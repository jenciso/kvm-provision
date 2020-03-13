## KVM 

### PRE-REQUISITES

In Ubuntu host you need to install these packages:

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

Modify a `config.conf` if you need to customize something

To create a `centos7` VM:

```
./new-vm.sh centos7
```

or, using some parameters
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
./del-vm.sh centos7
```


### Add-ons 

* How to add a second disk

```
./add-disk.sh -n centos7 -d vdb -s 60G
```
> Its name will be /dev/vdb

* If your download is very slow, you could use -c flag to continue download using wget

```
sudo wget -c http://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud.qcow2   -O /var/lib/libvirt/boot/CentOS-7-x86_64-GenericCloud.qcow2
```

