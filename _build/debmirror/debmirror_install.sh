###############

silent() { "$@" >/dev/null 2>&1; }

echo "Installing Dependencies"
silent apt-get install -y curl sudo mc
echo "Installed Dependencies"

silent apt-get -y install debmirror rsync


cat > /root/sync.sh << 'EOL'

host="snapshot.debian.org"
distroots=(
    "bullseye,bullseye-updates,bullseye-backports::archive/debian/20231007T024024Z"
    "bullseye-security::archive/debian-security/20231007T024024Z"
)
arch="amd64,arm64"
section="main,contrib,non-free"

cd /root
rm -rf 20231007T024024Z
mkdir -p 20231007T024024Z

echo "Syncing snapshot date: 20231007T024024Z"
for distroot in "${distroots[@]}"; do
    IFS='::' read -r dist root <<< "$distroot"
    debmirror \
        --arch="$arch" \
        --dist="$dist" \
        --section="$section" \
        --method=https \
        --host="$host" \
        --root="$root" \
        --nosource \
        --no-check-gpg \
        --progress \
        20231007T024024Z
done
echo "Sync completed for snapshot date: 20231007T024024Z"

EOL
chmod +x /root/sync.sh


echo "Cleaning up"
silent apt-get -y autoremove
silent apt-get -y autoclean
echo "Cleaned"

##############
