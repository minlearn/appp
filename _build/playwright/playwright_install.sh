###############

silent() { "$@" >/dev/null 2>&1; }

echo "Installing Dependencies"
silent apt-get install -y curl sudo mc
echo "Installed Dependencies"

echo "Installing python Playwright"
silent apt-get -y install python3-pip
rm -rf /usr/lib/python3.*/EXTERNALLY-MANAGED
silent pip install playwright
silent playwright install
silent playwright install-deps
echo "Installed python Playwright"



echo "Cleaning up"
silent apt-get -y autoremove
silent apt-get -y autoclean
echo "Cleaned"

##############  