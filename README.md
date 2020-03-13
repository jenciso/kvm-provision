## KVM 

### REQUERIMENTOS

Instalar estos pacotes

```shell
sudo apt-get install qemu qemu-kvm libvirt-bin bridge-utils virt-manager libguestfs-tools
sudo service libvirtd start
sudo update-rc.d libvirtd enable
```

Download the qcow2 cloud image

```shell
wget http://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud.qcow2 \
  -O /var/lib/libvirt/boot/CentOS-7-x86_64-GenericCloud.qcow2 
```

### CRIANDO UMA VM

Muda o conteúdo do arquivo: `config.conf`. Para criar uma VM com o nome `centos7`, ejecuta:

```shell
./new-vm.sh centos7
```
ou, para ser mais customizado

```shell
./new-vm.sh -n centos7 -m 1024 -c 2 -i 192.168.122.11
```

Post Instalação

```shell
source config.conf
export VM=centos7
sudo virsh change-media $VM hda --eject --config
sudo rm -f ${DATA_DIR}/${VM}/${VM}-cidata.iso
```

Apagar a VM `centos7`

```shell
./del-vm.sh centos7
```
