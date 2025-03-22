###############

echo "Installing Dependencies"

silent() { "$@" >/dev/null 2>&1; }

silent apt-get install -y curl sudo mc
echo "Installed Dependencies"

echo deb http://deb.debian.org/debian bullseye-backports main >> /etc/apt/sources.list
silent apt-get update -y
silent apt-get install -t bullseye-backports qemu-system -y

if [ ! -e /dev/kvm ]; then
   mknod /dev/kvm c 10 232
   chmod 777 /dev/kvm
   chown root:kvm /dev/kvm
fi

#done on the host already
#echo 1 > /sys/module/kvm/parameters/ignore_msrs

cd /root

tee -a start.sh > /dev/null <<EOF
if [ ! -e /dev/kvm ]; then
   mknod /dev/kvm c 10 232
   chmod 777 /dev/kvm
   chown root:kvm /dev/kvm
fi
# -drive if=pflash,format=raw,readonly=on,file=/usr/share/OVMF/OVMF_CODE.fd -drive if=pflash,format=raw,file=/usr/share/OVMF/OVMF_VARS.fd
qemu-system-x86_64 \
-accel kvm -accel tcg \
-machine q35 -smp 2 -m 1G \
-usbdevice tablet -usbdevice keyboard \
-drive "file=./imgscafford,format=raw" \
-net nic,model=virtio-net-pci -net user \
-vga std -monitor stdio -nographic \
-boot order=c,menu=on &
EOF
chmod +x ./start.sh

echo "Cleaning up"
silent apt-get -y autoremove
silent apt-get -y autoclean
echo "Cleaned"



##############
