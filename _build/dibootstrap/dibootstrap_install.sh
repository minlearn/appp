############

silent() { "$@" >/dev/null 2>&1; }

echo "Installing Dependencies"
silent apt-get install -y \
  curl \
  sudo \
  mc \
  gpg
echo "Installed Dependencies"

echo "Installing"

cd /root

silent apt-get install -y debhelper apt-utils dctrl-tools
silent apt-get install -y xsltproc docbook-xsl libbogl-dev genext2fs genisoimage dosfstools bc syslinux syslinux-utils isolinux pxelinux syslinux-common shim-signed grub-efi-amd64-signed xorriso tofrodos mtools bf-utf-source win32-loader librsvg2-bin
wget --no-check-certificate http://ftp.debian.org/debian/pool/main/d/debian-installer/debian-installer_20210731+deb11u8.tar.gz
tar xzf debian-installer_20210731+deb11u8.tar.gz
cd installer/build
read -r -p "Would you like to add a local udeb mirror source? <y/N> " prompt </dev/tty
if [[ ${prompt,,} =~ ^(y|yes)$ ]]; then
  touch sources.list.udeb.local
  echo 'deb https://snapshot.debian.org/archive/debian/20231007T024024Z bullseye main/debian-installer' > sources.list.udeb.local
  echo 'deb https://snapshot.debian.org/archive/debian/20231007T024024Z bullseye-updates main/debian-installer' >> sources.list.udeb.local
  echo 'deb https://snapshot.debian.org/archive/debian-security/20231007T024024Z bullseye-security main/debian-installer' >> sources.list.udeb.local
  sed -i '/cat > "$APT_CONFIG" <<EOF/a\Acquire::Check-Valid-Until "false";' util/get-packages
fi
silent fakeroot make clean_netboot
silent fakeroot make build_netboot
cd ..
rm -rf debian-installer_20210731+deb11u8.tar.gz

echo "Installed"

echo "Cleaning up"
silent apt-get -y autoremove
silent apt-get -y autoclean
echo "Cleaned"

###############
