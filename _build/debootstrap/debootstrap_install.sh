###############

silent() { "$@" >/dev/null 2>&1; }

echo "Installing Dependencies"
silent apt-get install -y curl sudo mc
echo "Installed Dependencies"

silent apt-get -y install debootstrap


cat > /root/start.sh << 'EOL'
cd /root

echo "debootstraping"
rm -rf debootstrap
mkdir -p debootstrap
debootstrap --verbose --no-check-gpg --no-check-certificate --variant=minbase --include=kmod,systemd-sysv,dbus,udev,ifupdown,isc-dhcp-client --arch amd64 bullseye debootstrap  http://deb.debian.org/debian/
rm -rf debootstrap/var/cache/* debootstrap/var/lib/apt/lists/* debootstrap/var/log/*
rm -rf debootstrap/usr/share/locale/* debootstrap/usr/share/man/* debootstrap/usr/share/doc/* debootstrap/usr/share/info/*
tar cpzf deboostrap.tar.gz deboostrap
echo "debootstraped"

EOL
chmod +x /root/start.sh


echo "Cleaning up"
silent apt-get -y autoremove
silent apt-get -y autoclean
echo "Cleaned"

##############
