######## This is for script manual run###### works!
#!/bin/bash
set -e

sudo hostnamectl set-hostname master-1

# Set up SSH key
sudo mkdir -p /home/ubuntu/.ssh
sudo chmod 700 /home/ubuntu/.ssh
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIERzgBDnqIC0DIHGur1X5F9S+ek70Z9WFRmp0V0mjifb viktor@MacBook-Pro-de-home.local" | sudo tee /home/ubuntu/.ssh/authorized_keys > /dev/null
sudo chmod 600 /home/ubuntu/.ssh/authorized_keys
sudo chown -R ubuntu:ubuntu /home/ubuntu/.ssh

# Enable SSH
sudo systemctl enable ssh
sudo systemctl start ssh

# Set password for ubuntu user
echo 'ubuntu:$6$/mNaq/GMRBNbFzuJ$KSbgeUZL5waeSkbqOKwMztaokKZjGF2xHDNiipg5iop8TmUiMUajNRezzUbOkmCaccaYiCoyjfid0Zp7QR4/e0' | sudo chpasswd -e

# Configure sudo
echo "ubuntu ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/ubuntu > /dev/null

# Update hosts file
sudo tee /etc/hosts > /dev/null << 'EOF'
127.0.0.1 localhost
192.168.0.101 master-1 master-1

# IPv6
::1 localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
EOF

sudo tee /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg > /dev/null <<EOF
network: {config: disabled}
EOF

sudo rm -f /etc/netplan/*

sudo tee /etc/netplan/01-static.yaml > /dev/null << 'EOF'
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      match:
        macaddress: 66:98:ac:cd:ad:11
      set-name: eth0
      dhcp4: false
      addresses:
        - 192.168.0.101/24
      nameservers:
        addresses: [8.8.8.8, 8.8.4.4]
      routes:
        - to: default
          via: 192.168.0.1
EOF

sudo netplan generate
sudo netplan apply

sudo reboot