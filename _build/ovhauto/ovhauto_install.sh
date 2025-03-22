###############

silent() { "$@" >/dev/null 2>&1; }

echo "Installing Dependencies"
silent apt-get install -y curl sudo mc qrencode
echo "Installed Dependencies"

mkdir -p /app/ovhauto
wget --no-check-certificate https://github.com/minlearn/appp/raw/master/_build/ovhauto/ovhauto.tar.gz -O /tmp/tmp.tar.gz
tar -xzvf /tmp/tmp.tar.gz -C /app/ovhauto ovhauto
rm -rf /tmp/tmp.tar.gz

cat > /lib/systemd/system/ovhauto.service << 'EOL'
[Unit]
Description=this is ovhauto service,please change the token then daemon-reload it
After=network.target nss-lookup.target
Wants=network.target nss-lookup.target
Requires=network.target nss-lookup.target

[Service]
Type=simple
ExecStart=/app/ovhauto/ovhauto -config /app/ovhauto/config.json
Restart=on-failure
RestartPreventExitStatus=23

[Install]
WantedBy=multi-user.target
EOL

cat > /app/ovhauto/config.json << 'EOL'
app:
  key: "your_app_key"
  secret: "your_app_secret"
  consumer_key: "your_consumer_key"
  region: "ovh-eu"
  interval: 10  # 任务运行的时间间隔（秒）
  
telegram:
  token: "your_telegram_bot_token"
  chat_id: "your_telegram_chat_id"
  
server:
  iam: "your_iam_identifier"
  zone: "IE"
  required_plan_code: "24ska01"  # 必需的计划代码
  required_disk: "your_required_disk"  # 可选，若无需求可以留空
  required_memory: "your_required_memory"  # 可选，若无需求可以留空
  required_datacenter: "your_required_datacenter"  # 可选，若无需求可以留空
  plan_name: "your_plan_name"
  autopay: true  # 是否自动支付
  options:  # 需要添加到购物车的选项
    - "bandwidth-100-24sk"
    - "ram-64g-noecc-2133-24ska01"
    - "softraid-1x480ssd-24ska01"
  coupon: "your_coupon_code"  # 优惠码，可选
EOL

cat > /root/tg.sh << 'EOL'
read -p "give a token:" token
read -p "give a chatid:" chatid
sed -e s#your_telegram_bot_token#${token}#g -e s#your_telegram_chat_id#${chatid}#g -i /app/ovhauto/config.json
systemctl restart ovhauto
EOL
chmod +x /root/tg.sh

cat > /root/keys.sh << 'EOL'
read -p "give a key:" key
read -p "give a secret:" secret
read -p "give a consumerkey:" consumerkey
sed -e s#your_app_key#${key}#g -e s#your_app_secret#${secret}#g -e s#your_consumer_key#${consumerkey}#g -i /app/ovhauto/config.json
systemctl restart ovhauto
EOL
chmod +x /root/keys.sh

cat > /root/plan.sh << 'EOL'
read -p "give a code:" code
sed -i s#24ska01#${code}#g /app/ovhauto/config.json
echo "please manually edit the options, which are neccsary for this plancode, then restart ovhauto"
systemctl restart ovhauto
EOL
chmod +x /root/plan.sh


systemctl enable -q --now ovhauto


echo "Cleaning up"
silent apt-get -y autoremove
silent apt-get -y autoclean
echo "Cleaned"

##############
