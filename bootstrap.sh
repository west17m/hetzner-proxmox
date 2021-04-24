#!/bin/bash
# from the hetzner rescue environment
wget https://github.com/west17m/hetzner-proxmox/archive/refs/heads/main.zip
unzip main.zip
pushd hetzner-proxmox-main
bash install.sh
popd
exit 0
