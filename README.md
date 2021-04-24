# hetzner-proxmox

    # from the hetzner rescue environment
    wget https://github.com/west17m/hetzner-proxmox/archive/refs/heads/main.zip
    unzip main.zip
    pushd hetzner-proxmox-main
    bash install.sh
    popd
    

wget https://bouncer.gentoo.org/fetch/root/all/releases/amd64/autobuilds/20210421T214502Z/install-amd64-minimal-20210421T214502Z.iso

pveam update

pveam available

pveam available --section system

pveam download local gentoo-current-default_20200310_amd64.tar.xz
