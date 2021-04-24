#!/bin/bash
# bootstrap.sh
# author: Travis Osterman
# created: 2021-04-24
#
# download bootstrap.sh and run in the Hetzner rescue environment to set up a
# server with proxmox. See install.sh for installation documentation
#

wget https://github.com/west17m/hetzner-proxmox/archive/refs/heads/main.zip
unzip main.zip
pushd hetzner-proxmox-main
bash install.sh
popd
exit 0
