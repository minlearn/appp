###############

silent() { "$@" >/dev/null 2>&1; }

echo "Installing Dependencies"
silent apt-get install -y curl sudo mc
echo "Installed Dependencies"

silent apt-get -y install debmirror rsync


cat > /root/sync.sh << 'EOL'
cd /root

echo "Syncing snapshot date: 20231007T024024Z"

rm -rf 20231007T024024Z
mkdir -p 20231007T024024Z
debmirror --arch=amd64,arm64 --dist=bullseye,bullseye-updates,bullseye-backports --section=main,contrib,non-free --method=https --host=snapshot.debian.org --root=archive/debian/20231007T024024Z --nosource --no-check-gpg --progress 20231007T024024Z
echo "Sync completed for snapshot date: 20231007T024024Z"

EOL
chmod +x /root/sync.sh


echo "Cleaning up"
silent apt-get -y autoremove
silent apt-get -y autoclean
echo "Cleaned"

##############
