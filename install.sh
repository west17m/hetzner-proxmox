#!/bin/bash
# install.sh
# author: Travis Osterman
# created: 2021-04-24
#
# You probably want to run 'bootstrap.sh' to download and create a proxmox-ve server.
#
# This uses hetzner's installimage script from the rescue environment. You will be prompted
# for a fully qualified domain name and root password. The remainder of configuration is in
# proxmox6.config. Following Debian installation, post.sh is run to install proxmox
#
set -e

echo -n "Hostname (FQDN): "
read FQDN
echo

/root/.oldroot/nfs/install/installimage -a -c proxmox6.config -n "$FQDN" -r no -t yes -x post.sh

echo -e "\n\nafter reboot, your server will be available at\nhttps://$FQDN:8006/\n\n\nyou may reboot now"
((sleep 1 && rm -rf hetzner-proxmox-main main.zip))

exit 0
