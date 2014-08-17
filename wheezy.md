# Building OpenCPU on Debian

The instructions below explain how to build OpenCPU on Debian Wheezy.
Note that `r-base` included with Debian is too old, so we use the CRAN
repository to get a more recent version.

## Building packages

Install build dependencies:

	# Become root
	sudo -i

	# Add Wheezy CRAN repo for R 3.0+
	apt-key adv --keyserver keyserver.ubuntu.com --recv-key 381BA480
	echo "deb http://cran.r-project.org/bin/linux/debian wheezy-cran3/" > /etc/apt/sources.list.d/cran.list

	# Update system
	apt-get update
	apt-get upgrade

	# Install build dependencies
	apt-get install wget make devscripts apache2-prefork-dev libapreq2-dev r-base-dev
	apt-get install libapparmor-dev r-cran-rcpp libcurl4-openssl-dev xvfb xauth xfonts-base curl

	# Stop being root
	exit

Build rApache (`libapache2-mod-r-base`)

	cd ~
	wget https://github.com/jeffreyhorner/rapache/archive/v1.2.6.tar.gz
	tar xzvf v1.2.6.tar.gz
	cd rapache-1.2.6
	debuild -us -uc

Build OpenCPU Cloud Server (`opencpu-server` and `opencpu-cache`)

	cd ~
	wget https://github.com/jeroenooms/opencpu-server/archive/v1.4.4.tar.gz
	tar xzvf v1.4.4.tar.gz
	cd opencpu-server-1.4.4
	debuild -us -uc

## Installing packages

Install `opencpu-server` package (possibly on another machine)

	# Install run dependencies
	sudo apt-get install apache2 r-cran-rcpp

	# Install package builds
	cd ~
	sudo dpkg -i libapache2-mod-r-base_*.deb
	sudo dpkg -i opencpu-lib_*.deb
	sudo dpkg -i opencpu-server_*.deb

Install `opencpu-cache` package (optional)

	# Dependencies
	sudo apt-get install nginx

	# Package builds
	cd ~
	sudo dpkg -i opencpu-cache_*.deb

## Enable AppArmor support (optional)

To enable advanced security policies, we need to enable AppArmor in the kernel.

	# Install apparmor
	sudo apt-get install apparmor-utils

Edit `/etc/default/grub` and add `security=apparmor` to the `GRUB_CMDLINE_LINUX` line. For example it would read:

	GRUB_CMDLINE_LINUX=" security=apparmor"

Update the grub config and reboot:

	sudo update-grub
	sudo reboot

After rebooting, test if AppArmor works:

	sudo aa-status

When enabled, `opencpu-server` automatically uses apparmor. To confirm, check:

    sudo tail /var/log/apache2/error.log -n30
