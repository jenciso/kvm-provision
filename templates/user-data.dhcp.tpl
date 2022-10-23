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
  - yum -y remove cloud-init
