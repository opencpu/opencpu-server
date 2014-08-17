# Fixes for older debian/ubuntu systems.
APPARMOR_VERSION=$(dpkg -l | awk '$2=="apparmor" { print $3 }')
APACHE_VERSION=$(dpkg -l | awk '$2=="apache2" { print $3 }')

#Apache 2.2 does not want .conf file extension
if dpkg --compare-versions $APACHE_VERSION lt 2.4; then
	echo "Patching sites-available for Apache 2.2"
	mv sites-available/opencpu.conf sites-available/opencpu
	mv sites-available/rstudio.conf sites-available/rstudio
fi

#Old AppArmor versions do not support signal rules
if dpkg --compare-versions $APPARMOR_VERSION lt 2.8.95; then
	echo "Patching profiles for older for AppArmor"
	sed -i '/^\s*signal .*/d' apparmor.d/opencpu-exec
	sed -i '/^\s*signal .*/d' apparmor.d/opencpu-main
fi
