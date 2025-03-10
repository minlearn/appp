###############

echo "Installing Dependencies"

silent() { "$@" >/dev/null 2>&1; }

silent apt-get install -y curl sudo mc
echo "Installed Dependencies"

silent apt-get install -y procps
mkdir -p /app/clashmeta
wget --no-check-certificate https://github.com/minlearn/appp/raw/master/_build/clashmeta/clashmeta.tar.gz -O /tmp/tmp.tar.gz
tar -xzvf /tmp/tmp.tar.gz -C /app/clashmeta clashmeta --strip-components=1
rm -rf /tmp/tmp.tar.gz

cat > /app/clashmeta/config.yaml << 'EOL'
mode: rule
mixed-port: 7890
allow-lan: true
log-level: error
ipv6: true
secret: ''
external-controller: 127.0.0.1:9090
dns:
  enable: false
  enhanced-mode: fake-ip
  fake-ip-range: 198.18.0.1/16
  nameserver:
  - 114.114.114.114
  - 223.5.5.5
  - 8.8.8.8
  fallback: []
tun:
  enable: false
  stack: gvisor
  dns-hijack:
  - any:53
  auto-route: true
  auto-detect-interface: true
EOL

cat > /lib/systemd/system/clashmeta.service << 'EOL'
[Unit]
Description=this is clashmeta service,please init it with the init.sh
After=network.target nss-lookup.target
Wants=network.target nss-lookup.target
Requires=network.target nss-lookup.target

[Service]
Type=simple
ExecStartPre=/usr/bin/sleep 2
ExecStart=/app/clashmeta/clash-meta -d /app/clashmeta -f /app/clashmeta/config.yaml
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOL

cat > /root/init.sh << 'EOL'
test -f /root/inited || {
  read -p "give a sub download url with proxies:" file
  wget -qO- --no-check-certificate $file|sed -n "/^proxies/,/^$/p" >> /app/clashmeta/config.yaml
  grep -q 'proxies' /app/clashmeta/config.yaml && /app/clashmeta/clash-meta -d /app/clashmeta -t /app/clashmeta/config.yaml && touch /root/inited
  systemctl restart clashmeta
}
EOL
chmod +x /root/init.sh

cat > /root/transport.sh << 'EOL'

read -r -p "this will open the transport proxy temporarily,are you sure? <y/N> " prompt </dev/tty
if [[ ${prompt,,} =~ ^(y|yes)$ ]]; then

    grep -q 'redir-port: 7892' /app/clashmeta/config.yaml || sed -i ':a;N;$!ba;s/mixed-port:\ 7890/mixed-port:\ 7890\nredir-port:\ 7892/g' /app/clashmeta/config.yaml 
    sed -i ':a;N;$!ba;s/dns:\n\ \ enable: false/dns:\n\ \ enable: true\n\ \ listen:\ 0.0.0.0:53/g;s/tun:\n\ \ enable: false/tun:\n\ \ enable: true/g' /app/clashmeta/config.yaml
    grep -q 'net.ipv4.ip_forward = 1' /etc/sysctl.conf || {
      echo 'net.ipv4.ip_forward = 1' | tee -a /etc/sysctl.conf
      echo 'net.ipv6.conf.all.forwarding = 1' | tee -a /etc/sysctl.conf
      sysctl -p
    }
    iptables -t nat -N clash >/dev/null 2>&1
    [[ $? == '0' ]] && {
      #iptables -t nat -N clash
      iptables -t nat -A clash -d 0.0.0.0/8 -j RETURN
      iptables -t nat -A clash -d 10.0.0.0/8 -j RETURN
      iptables -t nat -A clash -d 127.0.0.0/8 -j RETURN
      iptables -t nat -A clash -d 169.254.0.0/16 -j RETURN
      iptables -t nat -A clash -d 172.16.0.0/12 -j RETURN
      iptables -t nat -A clash -d 192.168.0.0/16 -j RETURN
      iptables -t nat -A clash -d 224.0.0.0/4 -j RETURN
      iptables -t nat -A clash -d 240.0.0.0/4 -j RETURN
      iptables -t nat -A clash -p tcp -j REDIRECT --to-port 7892
      iptables -t nat -A PREROUTING -p tcp -j clash
      iptables -A INPUT -p udp --dport 53 -j ACCEPT
    }
    systemctl restart clashmeta

    echo "now you can use this vm ip as sidecar route gateway"
fi
EOL
chmod +x /root/transport.sh

systemctl enable -q --now clashmeta


echo "Cleaning up"
silent apt-get -y autoremove
silent apt-get -y autoclean
echo "Cleaned"

##############
