# hetzner-proxmox

Actively under development. Not for production.

Goal: deploy a proxmox-ve node in hetzner environment.

    # from the hetzner rescue environment
    wget https://raw.githubusercontent.com/west17m/hetzner-proxmox/main/bootstrap.sh
    bash bootstrap.sh


wget https://bouncer.gentoo.org/fetch/root/all/releases/amd64/autobuilds/20210421T214502Z/install-amd64-minimal-20210421T214502Z.iso

pveam update

pveam available

pveam available --section system

pveam download local gentoo-current-default_20200310_amd64.tar.xz

Links
* https://community.hetzner.com/tutorials/install-and-configure-proxmox_ve
* https://pve.proxmox.com/wiki/Network_Configuration
* https://github.com/IronicBadger/ansible-role-proxmox-nag-removal
* https://www.sysorchestra.com/proxmox-5-on-hetzner-root-server-with-ipv4
