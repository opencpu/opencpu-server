# Buil ddeOpenCPU cloud server on Debian

> Tested only with Debian 7.0 Wheezy. Many dependencies of OpenCPU are outdated on Debian. This is why Ubuntu is the preferred OS to run OpenCPU. To build on Debian we need to get backports of R and Apache2.4 from other repositories.

All instructions below must be executed with `sudo` or as `root` user.

## Install and enable AppArmor

	#become root
	sudo -i

	#Install apparmor
	apt-get update
	apt-get install apparmor-utils

	## Edit /etc/default/grub to set:
	GRUB_CMDLINE_LINUX=" security=apparmor"

	#Update and reboot
	update-grub
	reboot

	#Test that apparmor works
	aa-status

## Install backport of Apache 2.4
	
	#Make sure apache is not installed
	sudo -i
	apt-get purge apache2-*
	apt-get autoremove --purge

	#Add repo with Apache 2.4
	echo "deb http://www.d7031.de/debian wheezy-experimental main" > /etc/apt/sources.list.d/apache-backport.list
	apt-key adv --keyserver subkeys.pgp.net --recv-key 9EB5E8A3DF17D0B3
	apt-get update

	#Install/upgrade
	apt-get dist-upgrade
	apt-get install apache2

## Build and install rApache (mod_R)

	#become root
	sudo -i

	#Need R at least 3.0, see http://cran.us.r-project.org/bin/linux/debian/
	apt-key adv --keyserver subkeys.pgp.net --recv-key 381BA480
	echo "deb http://cran.r-project.org/bin/linux/debian wheezy-cran3/" > /etc/apt/sources.list.d/cran.list

	#update all
	apt-get update
	apt-get upgrade

	#install rapache(mod_R) build dependencies
	apt-get install git make devscripts apache2-dev apache2-mpm-prefork libapreq2-dev r-base-core r-base-dev

	#build rapache (libapache2-mod-r-base)
	git clone https://github.com/jeffreyhorner/rapache.git
	cd rapache
	debuild -us -uc

	#Install rapache
	cd ..
	dpkg -i libapache2*.deb
	service apache2 restart

## Build and install OpenCPU

	#become root
	sudo -i

	#install opencpu build dependencies
	apt-get install r-base libapparmor-dev r-cran-rcpp libcurl4-openssl-dev xvfb xauth xfonts-base

	#build opencpu
	git clone https://github.com/jeroenooms/opencpu-deb
	cd opencpu-deb
	debuild -us -uc

	#install opencpu
	cd ..
	dpkg -i opencpu-lib*.deb
	dpkg -i opencpu-server*.deb

	#edit /etc/apparmor.d/opencpu-exec and comment out the line that starts with "signal"
	#edit /etc/apparmor.d/opencpu-main and comment out the line that starts with "signal"
	service apparmor restart
	service opencpu restart

	#if you also want the cache server
	apt-get install nginx
	dpkg -i opencpu-cache*.deb
