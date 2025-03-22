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

# 7.4-3
silent git clone https://git.proxmox.com/git/pve-manager.git proxmox-ve
silent git -C proxmox-ve checkout ab89079dfac50e2cff2d8d858a1f6cd62f2dbd44

#libproxmox-rs-perl?

# 0.7.5
silent git -C proxmox-ve clone https://git.proxmox.com/git/proxmox-perl-rs.git
silent git -C proxmox-ve/proxmox-perl-rs checkout 2fad118858d2a7f974c50a980939ed48ce051189
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
# 7.4-1
silent git -C proxmox-ve clone https://git.proxmox.com/git/libpve-u2f-server-perl.git
silent git -C proxmox-ve/pve-access-control checkout a23eaa1a12c7170ef36f8508abbf23bcacfc0e7a
# 1.1-2
silent git -C proxmox-ve clone https://git.proxmox.com/git/pve-access-control.git
silent git -C proxmox-ve/libpve-u2f-server-perl checkout 2e8845c30d5f14e6e34aa36bdbec918e58eaa1b8
# 7.3-3
silent git -C proxmox-ve clone https://git.proxmox.com/git/pve-cluster.git
silent git -C proxmox-ve/pve-cluster checkout 1fa86afba4aa6c759dfa771f8c0c06f233951550
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
# 4.4-3
silent git -C proxmox-ve clone https://git.proxmox.com/git/pve-container.git
silent git -C proxmox-ve/pve-container checkout c2933d5a5cade5fdce1438a521d3b7cb516ac35e
# 7.4-2
silent git -C proxmox-ve clone https://git.proxmox.com/git/qemu-server.git
silent git -C proxmox-ve/qemu-server checkout 021e9cdf7d9acbefa347f9735d9a33f5ffac26cf
# 3.6.0
silent git -C proxmox-ve clone https://git.proxmox.com/git/pve-ha-manager.git
silent git -C proxmox-ve/pve-ha-manager checkout 03f825dbc7abc2c9a273d5bc17ff076a6c0e7d3d

# vncterm?xtermjs?novnc?minijournal?i18n?docs?archivekeyring?

tar cpzf proxmox-ve.tar.gz proxmox-ve

################################################################################


silent apt-get install -y build-essential devscripts
silent apt-get install -y cargo dh-cargo

cd proxmox-ve

cd proxmox-perl-rs/pve-rs
# silent mk-build-deps --install
# silent make deb
# silent make dinstall
cd ../..

cd pve-common
#wget http://download.proxmox.com/debian/pve/dists/bullseye/pve-no-subscription/binary-amd64/libpve-common-perl_7.3-3_all.deb
#cd proxmox-acme
#wget http://download.proxmox.com/debian/pve/dists/bullseye/pve-no-subscription/binary-amd64/libproxmox-acme-perl_1.4.4_all.deb
#dpkg -i .
cd ..

silent apt-get install -y rsync
cd pve-apiclient
# silent mk-build-deps --install
# silent make deb
# silent make dinstall
cd ..

cd pve-http-server
# silent mk-build-deps --install
# silent make deb
# silent make dinstall
cd ..

cd libpve-u2f-server-perl
# silent mk-build-deps --install
# silent make deb
# silent make dinstall
cd ..

echo "deb http://download.proxmox.com/debian/pve bullseye pve-no-subscription" >/etc/apt/sources.list.d/pvenosub.list
silent apt-get update
silent apt-get install -y pve-doc-generator --no-install-recommends
rm -rf /etc/apt/sources.list.d/pvenosub.list
silent apt-get update
cd pve-access-control
#wget http://download.proxmox.com/debian/pve/dists/bullseye/pve-no-subscription/binary-amd64/libpve-access-control_7.4-1_all.deb
#cd pve-cluster
#wget http://download.proxmox.com/debian/pve/dists/bullseye/pve-no-subscription/binary-amd64/libpve-cluster-api-perl_7.3-3_all.deb
#wget http://download.proxmox.com/debian/pve/dists/bullseye/pve-no-subscription/binary-amd64/libpve-cluster-perl_7.3-3_all.deb
#wget http://download.proxmox.com/debian/pve/dists/bullseye/pve-no-subscription/binary-amd64/pve-cluster_7.3-3_amd64.deb
#dpkg -iR .
cd ..

cd pve-firewall
# silent mk-build-deps --install
# silent make deb
# silent make dinstall
cd ..

cd librados2-perl
# silent make deb
# silent make dinstall
cd ..

echo "deb http://ftp.de.debian.org/debian bullseye main contrib" >/etc/apt/sources.list
silent apt-get update
silent apt-get install -y zfsutils-linux
#wget http://download.proxmox.com/debian/pve/dists/bullseye/pve-no-subscription/binary-amd64/proxmox-backup-client_2.3.3-1_amd64.deb
#wget http://download.proxmox.com/debian/pve/dists/bullseye/pve-no-subscription/binary-amd64/proxmox-backup-file-restore_2.0.5-1_amd64.deb
cd pve-storage
# silent mk-build-deps --install
# silent make deb
# silent make dinstall
cd ..

#wget http://download.proxmox.com/debian/pve/dists/bullseye/pve-no-subscription/binary-amd64/proxmox-websocket-tunnel_0.1.0-1_amd64.deb
#dpkg -i proxmox-websocket-tunnel_0.1.0-1_amd64.deb
cd pve-guest-common
# silent mk-build-deps --install
# silent make deb
# silent make dinstall
cd ..

#wget http://download.proxmox.com/debian/pve/dists/bullseye/pve-no-subscription/binary-amd64/pve-lxc-syscalld_1.2.2-1_amd64.deb
cd pve-container
# silent mk-build-deps --install
# silent make deb
# silent make dinstall
cd ..

silent apt-get install -y qemu-system
#wget http://download.proxmox.com/debian/pve/dists/bullseye/pve-no-subscription/binary-amd64/libproxmox-backup-qemu0_1.3.1-1_amd64.deb
cd qemu-server
# silent mk-build-deps --install
# silent make
cd ..

cd pve-ha-manager
# silent mk-build-deps --install
# silent make
cd ..

#wget http://download.proxmox.com/debian/pve/dists/bullseye/pve-no-subscription/binary-amd64/proxmox-widget-toolkit_3.6.3_all.deb
# silent mk-build-deps --install
# silent make
cd ..

echo "Installed"

echo "Cleaning up"
silent apt-get -y autoremove
silent apt-get -y autoclean
echo "Cleaned"

###############
