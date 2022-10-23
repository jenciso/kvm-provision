#cloud-config

# Hostname management
preserve_hostname: False
hostname: ${VM}
fqdn: ${VM}.${DOMAIN}

# Users
users:
  - name: ${LOGIN_USER}
    groups: ['wheel']
    shell: /bin/bash
    lock_passwd: false
    passwd: ${PASSWORD}
    sudo: ALL=(ALL) NOPASSWD:ALL
    ssh-authorized-keys:
      - ${SSH_KEY_0}
      - ${SSH_KEY_1}
  - name: ansible
    groups: ['wheel']
    shell: /bin/bash
    lock_passwd: false
    passwd: ${PASSWORD}
    sudo: ALL=(ALL) NOPASSWD:ALL
    ssh-authorized-keys:
      - ${SSH_KEY_0}
      - ${SSH_KEY_1}
      - ${SSH_KEY_2}

# Configure where output will go
output:
  all: ">> /var/log/cloud-init.log"
 
# configure interaction with ssh server
ssh_pwauth: True
ssh_genkeytypes: ['rsa']
 
# set timezone for VM
timezone: ${TIMEZONE}

# Remove cloud-init 
runcmd:
  - sed -i "s/ONBOOT=no/ONBOOT=yes/" /etc/sysconfig/network-scripts/ifcfg-eth0
  - sed -i "s/BOOTPROTO=dhcp/BOOTPROTO=static/" /etc/sysconfig/network-scripts/ifcfg-eth0
  - |
    cat >> /etc/sysconfig/network-scripts/ifcfg-eth0 << EOF
    IPADDR=${IPADDR}
    PREFIX=${PREFIX}
    GATEWAY=${GATEWAY}
    DNS1=${DNS1}
    DNS2=${DNS2}
    DOMAIN=${DOMAIN}
    EOF
  - ifdown eth0 && sleep 1 && ifup eth0
  - yum -y remove cloud-init
