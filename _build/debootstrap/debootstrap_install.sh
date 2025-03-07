###############

silent() { "$@" >/dev/null 2>&1; }

echo "Installing Dependencies"
silent apt-get install -y curl sudo mc
echo "Installed Dependencies"

silent apt-get -y install debootstrap


cat > /root/start.sh << 'EOL'

repo_url="https://snapshot.debian.org/archive/debian/20231007T024024Z"
rootfsDir=debootstrap
DIRS_TO_TRIM="/usr/share/man
/var/cache/apt
/var/lib/apt/lists
/usr/share/locale
/var/log
/usr/share/info
/dev
"

cd /root

echo "debootstraping"
rm -rf $rootfsDir
mkdir -p $rootfsDir
debootstrap --verbose --no-check-gpg --no-check-certificate --variant=minbase --include=kmod,systemd-sysv,dbus,udev,ifupdown,isc-dhcp-client --arch amd64 bullseye $rootfsDir $repo_url
echo "debootstraped"

echo "trimming"
for DIR in $DIRS_TO_TRIM; do
  rm -rf "$rootfsDir/$DIR"/*
done
rm "$rootfsDir/var/cache/ldconfig/aux-cache"
find "$rootfsDir/usr/share/doc" -mindepth 2 -not -name copyright -not -type d -delete
find "$rootfsDir/usr/share/doc" -mindepth 1 -type d -empty -delete
echo "trimmed"
echo "Total size"
du -skh "$rootfsDir"
echo "Largest dirs"
du "$rootfsDir" | sort -n | tail -n 20

EOL
chmod +x /root/start.sh


echo "Cleaning up"
silent apt-get -y autoremove
silent apt-get -y autoclean
echo "Cleaned"

##############
