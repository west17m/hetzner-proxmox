#!/bin/bash
# post.sh
# author: Travis Osterman
# created: 2021-04-24
#
# This is run in the chrooted server environment following OS installation.
#

# proxmox install on debian 10
set -e
echo "deb http://download.proxmox.com/debian/pve buster pve-no-subscription" > /etc/apt/sources.list.d/pve-install-repo.list
wget http://download.proxmox.com/debian/proxmox-ve-release-6.x.gpg -O /etc/apt/trusted.gpg.d/proxmox-ve-release-6.x.gpg
chmod +r /etc/apt/trusted.gpg.d/proxmox-ve-release-6.x.gpg

# remove these apps
apt remove -yq cryptsetup-initramfs cryptsetup-bin cryptsetup-run os-prober
apt update && apt -yq full-upgrade

# install proxmox
export DEBIAN_FRONTEND=noninteractive
apt install -yq proxmox-ve postfix open-iscsi ifupdown2

# clear

DIR="https://raw.githubusercontent.com/west17m/hetzner-proxmox/main"

# firewall
cd /root
wget "$DIR"/root/firewall.sh
chmod 770 firewall.sh
chown root:root firewall.sh

# network interface
cd /etc/network
mv interfaces interfaces.bak
wget "$DIR"/etc/network/interfaces
chmod 664 interfaces
chown root:root interfaces

# pve storage
cd /root
#mv storage.cfg storage.cfg.bak
wget "$DIR"/etc/pve/storage.cfg
#chown root:www-data storage.cfg
#chmod 640 storage.cfg

# update lxc

# download gentoo
/usr/bin/pveam update
pveam download local $(pveam available --section system | grep gentoo | sed 's:system.*\(gentoo-current-default_.*\):\1:')

for i in  $(pveam available --section system | grep debian | sed 's:system.*\(debian-.*\):\1:')
  do pveam download local $i
done

echo "$(hostname) > set root password"
passwd
exit 0
