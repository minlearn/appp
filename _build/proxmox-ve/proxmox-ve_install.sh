############

silent() { "$@" >/dev/null 2>&1; }

echo "Installing Dependencies"
silent apt-get install -y \
  curl \
  sudo \
  mc \
  gpg
echo "Installed Dependencies"

curl -fsSL https://enterprise.proxmox.com/debian/proxmox-release-bullseye.gpg | gpg --dearmor  -o /etc/apt/trusted.gpg.d/proxmox-release-bullseye.gpg
echo "deb http://download.proxmox.com/debian/devel bullseye main" >/etc/apt/sources.list.d/pvedevel.list
#echo "deb http://download.proxmox.com/debian/pve bullseye pve-no-subscription" >/etc/apt/sources.list.d/pvenosub.list
silent apt-get update

echo "Installing"

silent apt-get install -y git

cd /root
mkdir proxmox-ve
# 0.2.1
# 0.7.5
silent git -C proxmox-ve clone https://git.proxmox.com/git/proxmox-perl-rs.git
silent git -C proxmox-ve/proxmox-perl-rs checkout 8e7330c47450b731f959b223015daf58ee65076b
# 1.4.4
silent git -C proxmox-ve clone https://git.proxmox.com/git/proxmox-acme.git
silent git -C proxmox-ve/proxmox-acme checkout 056149a0f0a56c9be37621a6f24ca104d7e289a8
# 7.3-3
silent git -C proxmox-ve clone https://git.proxmox.com/git/pve-common.git
silent git -C proxmox-ve/pve-common checkout 8328617d06d60160660393faea10569d06ae0c66
# 3.2-1
silent git -C proxmox-ve clone https://git.proxmox.com/git/pve-apiclient.git
silent git -C proxmox-ve/pve-apiclient checkout cb2805fbbf46dbac967833e679fb958bb06e230f
# 4.2-1
silent git -C proxmox-ve clone https://git.proxmox.com/git/pve-http-server.git
silent git -C proxmox-ve/pve-http-server checkout fcb543a6826fcc6bfba4c372c9f78f7376f3808b
# 7.3-3
silent git -C proxmox-ve clone https://git.proxmox.com/git/pve-cluster.git
silent git -C proxmox-ve/pve-cluster checkout 1fa86afba4aa6c759dfa771f8c0c06f233951550
# 1.1-2
silent git -C proxmox-ve clone https://git.proxmox.com/git/pve-access-control.git
silent git -C proxmox-ve/libpve-u2f-server-perl checkout 2e8845c30d5f14e6e34aa36bdbec918e58eaa1b8
# 7.4-1
silent git -C proxmox-ve clone https://git.proxmox.com/git/libpve-u2f-server-perl.git
silent git -C proxmox-ve/pve-access-control checkout a23eaa1a12c7170ef36f8508abbf23bcacfc0e7a
# 4.3-1
silent git -C proxmox-ve clone https://git.proxmox.com/git/pve-firewall.git
silent git -C proxmox-ve/pve-firewall checkout 23b3e816dd5ebab41af4e35125fff069e2855849
# 1.3-1
silent git -C proxmox-ve clone https://git.proxmox.com/git/librados2-perl.git
silent git -C proxmox-ve/librados2-perl checkout 87900ae76185d13e1d292f320c76ab2b8c29e8e1
# 7.4-2
silent git -C proxmox-ve clone https://git.proxmox.com/git/pve-storage.git
silent git -C proxmox-ve/pve-storage checkout f11bdb1731885ddf1b30a9d94f4b3681215990b9
# 4.2-4
silent git -C proxmox-ve clone https://git.proxmox.com/git/pve-guest-common.git
silent git -C proxmox-ve/pve-guest-common checkout 77ca89a73fce9a7f28727fedba90daba096f5f1a
# 3.6.0
silent git -C proxmox-ve clone https://git.proxmox.com/git/pve-ha-manager.git
silent git -C proxmox-ve/pve-ha-manager checkout 03f825dbc7abc2c9a273d5bc17ff076a6c0e7d3d
# 4.4-3
silent git -C proxmox-ve clone https://git.proxmox.com/git/pve-container.git
silent git -C proxmox-ve/pve-container checkout c2933d5a5cade5fdce1438a521d3b7cb516ac35e
# 7.4-2
silent git -C proxmox-ve clone https://git.proxmox.com/git/qemu-server.git
silent git -C proxmox-ve/qemu-server checkout 021e9cdf7d9acbefa347f9735d9a33f5ffac26cf
# 2.2
silent git -C proxmox-ve clone https://git.proxmox.com/git/proxmox-archive-keyring.git
silent git -C proxmox-ve/proxmox-archive-keyring checkout ac337410f9578e6c6bf7295b477da9c8b3285450
# 7.4-3
silent git -C proxmox-ve clone https://git.proxmox.com/git/pve-manager.git
silent git -C proxmox-ve/pve-manager checkout ab89079dfac50e2cff2d8d858a1f6cd62f2dbd44

################################################################################


silent apt-get install -y build-essential devscripts
silent apt-get install -y cargo

cd proxmox-ve/proxmox-perl-rs
# silent mk-build-deps --install
# silent make pve
cd ../..

cd proxmox-ve/proxmox-acme
# silent mk-build-deps --install
# silent make
cd ../..

cd proxmox-ve/pve-common
# sed -i "s/PREFIX=\/usr/PREFIX=\/root\/proxmox-ve\/dest/g" src/Makefile
# silent make install -C src
cd ../..

silent apt-get install -y rsync
cd proxmox-ve/pve-apiclient
# silent mk-build-deps --install
# silent make
cd ../..

cd proxmox-ve/pve-http-server
# silent mk-build-deps --install
# silent make
cd ../..

cd proxmox-ve/pve-cluster
# silent mk-build-deps --install
# # silent make
cd ../..

cd proxmox-ve/pve-access-control
silent mk-build-deps --install
# silent make
cd ../..

cd proxmox-ve/libpve-u2f-server-perl
# silent mk-build-deps --install
# silent make
cd ../..

cd proxmox-ve/pve-firewall
# silent mk-build-deps --install
# silent make
cd ../..

cd proxmox-ve/librados2-perl
# silent mk-build-deps --install
# silent make
cd ../..

cd proxmox-ve/pve-storage
# silent mk-build-deps --install
# silent make
cd ../..

cd proxmox-ve/pve-guest-common
# silent mk-build-deps --install
# silent make
cd ../..

cd proxmox-ve/pve-ha-manager
# silent mk-build-deps --install
# silent make
cd ../..

cd proxmox-ve/pve-container
# silent mk-build-deps --install
# silent make
cd ../..

cd proxmox-ve/qemu-server
# silent mk-build-deps --install
# silent make
cd ../..

cd proxmox-ve/proxmox-archive-keyring
# silent mk-build-deps --install
# silent make
cd ../..

cd proxmox-ve/pve-manager
# silent mk-build-deps --install
# silent make
cd ../..

echo "Installed"

echo "Cleaning up"
silent apt-get -y autoremove
silent apt-get -y autoclean
echo "Cleaned"

###############
