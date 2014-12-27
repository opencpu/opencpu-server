# Fixes for older debian/ubuntu systems.
APPARMOR_VERSION=$(dpkg -l | awk '$2 ~ /libapparmor-dev/ { print $3 }')
APACHE_VERSION=$(dpkg -l | awk '$2 ~ /apache2(-prefork)?-dev/ { print $3 }')

#Apache 2.2 does not want .conf file extension
echo "Found Apache version $APACHE_VERSION"
if dpkg --compare-versions $APACHE_VERSION lt 2.4; then
	echo "Patching config for Apache 2.2"
	mv sites-available/opencpu.conf sites-available/opencpu
	mv sites-available/rstudio.conf sites-available/rstudio
	#sed -i 's/Require local/# Require local/g' sites-available/opencpu
fi

#Old AppArmor versions do not support signal rules
echo "Found AppArmor version $APPARMOR_VERSION"
if dpkg --compare-versions $APPARMOR_VERSION lt 2.8.94; then
	echo "Patching profiles for older for AppArmor"
	sed -i '/^\s*signal .*/d' apparmor.d/opencpu-exec
	sed -i '/^\s*signal .*/d' apparmor.d/opencpu-main
fi
