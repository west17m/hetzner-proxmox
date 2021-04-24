#!/bin/bash
# todo prompt for host and root passwd
echo -n "Hostname (FQDN): "
read FQDN
echo

/root/.oldroot/nfs/install/installimage -a -c proxmox6.config -n "$FQDN" -r no -t yes -x post.sh
exit 0
