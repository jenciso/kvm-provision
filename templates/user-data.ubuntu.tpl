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

# Configure where output will go
output:
  all: ">> /var/log/cloud-init.log"
 
# configure interaction with ssh server
ssh_pwauth: True
ssh_genkeytypes: ['rsa']
 
# set timezone for VM
timezone: ${TIMEZONE}

# Setup cloud-init 
runcmd:
  - |
    cat >> /etc/netplan/01-netcfg.yaml << EOF
    network:
      version: 2
      renderer: networkd
      ethernets:
        enp1s0:
          addresses:
            - ${IPADDR}/${PREFIX}
          nameservers:
            addresses: [${DNS1},${DNS2}]
            search: [${DOMAIN}]
          routes:
            - to: default
              via: ${GATEWAY}
    EOF
  - rm -f /etc/netplan/50-cloud-init.yaml
  - netplan apply
  - apt-get remove cloud-init
