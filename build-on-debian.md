# Building the OpenCPU cloud server on Debian

> Tested only with Debian 7.0 Wheezy. Many dependencies of OpenCPU are outdated on Debian. This is why Ubuntu is the preferred OS to run OpenCPU. To build on Debian we need to get backports of R and Apache2.4 from other repositories.

All instructions below must be executed with `sudo` or as `root` user.

## Install and enable AppArmor

	# Prepare
	sudo -i
	apt-get update
	apt-get dist-upgrade

	# Install apparmor
	apt-get install apparmor-utils

	# Edit /etc/default/grub to set:
	GRUB_CMDLINE_LINUX=" security=apparmor"

	# Update and reboot
	update-grub
	reboot

	# Test that apparmor works
	aa-status

## Install backport of Apache 2.4
	
	# Make sure apache 2.2 is removed
	sudo -i
	apt-get purge apache2-*
	apt-get autoremove --purge

	# Add repository with Apache 2.4
	echo "deb http://www.d7031.de/debian wheezy-experimental main" > /etc/apt/sources.list.d/apache-backport.list
	apt-key adv --keyserver keyserver.ubuntu.com --recv-key 9EB5E8A3DF17D0B3
	apt-get update

	# Install/upgrade
	apt-get dist-upgrade
	apt-get install apache2

## Build and install rApache (mod_R)

	# Be root
	sudo -i

	# Need R at least 3.0, see http://cran.us.r-project.org/bin/linux/debian/
	apt-key adv --keyserver keyserver.ubuntu.com --recv-key 381BA480
	echo "deb http://cran.r-project.org/bin/linux/debian wheezy-cran3/" > /etc/apt/sources.list.d/cran.list
	apt-get update

	# Install rapache build dependencies
	apt-get install git make devscripts apache2-dev apache2-mpm-prefork libapreq2-dev r-base-core r-base-dev

	# Build rapache (libapache2-mod-r-base)
	git clone https://github.com/jeffreyhorner/rapache.git
	cd rapache
	debuild -us -uc

	# Install rapache
	cd ..
	dpkg -i libapache2*.deb
	service apache2 restart

## Build and install OpenCPU

	# Become root
	sudo -i

	# Install opencpu build dependencies
	apt-get install r-base libapparmor-dev r-cran-rcpp libcurl4-openssl-dev xvfb xauth xfonts-base

	# Build opencpu
	git clone https://github.com/jeroenooms/opencpu-deb
	cd opencpu-deb
	debuild -us -uc

	# Install opencpu
	cd ..
	dpkg -i opencpu-lib*.deb
	dpkg -i opencpu-server*.deb

	# Edit /etc/apparmor.d/opencpu-exec and comment-out or remove the line that starts with "signal"
	# Edit /etc/apparmor.d/opencpu-main and comment-out or remove the line that starts with "signal"
	service apparmor restart
	service opencpu restart

	# Done! Navigate to http(s)://your.server.com/ocpu/

	# If you also want to install the cache server
	apt-get install nginx
	dpkg -i opencpu-cache*.deb
