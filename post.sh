#!/bin/bash
# proxmox install on debian 10
echo "deb http://download.proxmox.com/debian/pve buster pve-no-subscription" > /etc/apt/sources.list.d/pve-install-repo.list
wget http://download.proxmox.com/debian/proxmox-ve-release-6.x.gpg -O /etc/apt/trusted.gpg.d/proxmox-ve-release-6.x.gpg
chmod +r /etc/apt/trusted.gpg.d/proxmox-ve-release-6.x.gpg

# remove these apps
apt remove -yq cryptsetup-initramfs cryptsetup-bin cryptsetup-run os-prober
apt update && apt -yq full-upgrade

# install proxmox
export DEBIAN_FRONTEND=noninteractive
apt install -yq proxmox-ve postfix open-iscsi

clear
echo "set root password"
passwd
exit 0
