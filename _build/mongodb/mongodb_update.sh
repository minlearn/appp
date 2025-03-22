
if [[ ! -f /etc/apt/sources.list.d/mongodb-org-7.0.list ]]; then echo "No ${APP} Installation Found!"; exit; fi
echo "Updating ${APP} LXC"
apt-get update &>/dev/null
apt-get -y upgrade &>/dev/null
echo "Updated Successfully"


