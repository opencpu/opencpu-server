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
	apt-get install wget make devscripts apache2-prefork-dev apache2-mpm-prefork libapreq2-dev r-base r-base-dev libapparmor-dev libcurl4-openssl-dev xvfb xauth xfonts-base curl

	# Stop being root
	exit

Build rApache (`libapache2-mod-r-base`). Run this **not** as root.

	#run NOT as root
	cd ~
	wget https://github.com/jeffreyhorner/rapache/archive/v1.2.6.tar.gz
	tar xzf v1.2.6.tar.gz
	cd rapache-1.2.6
	debuild -us -uc

Build OpenCPU Cloud Server (`opencpu-server` and `opencpu-cache`). Run this **not** as root.

	cd ~
	wget https://github.com/jeroenooms/opencpu-server/archive/v1.4.4.tar.gz
	tar xzf v1.4.4.tar.gz
	cd opencpu-server-1.4.4
	debuild -us -uc

## Installing OpenCPU API server

To install the cloud server, simply install the `deb` packages in the following order:

	cd ~
	sudo dpkg -i libapache2-mod-r-base_*.deb
	sudo dpkg -i opencpu-lib_*.deb
	sudo dpkg -i opencpu-server_*.deb

## Installing OpenCPU caching server (optional)

The `opencpu-cache` package is a reverse proxy for caching and load balancing with OpenCPU.
When installed, it automatically preroutes all incomming traffic on ports 80 and 443 through nginx.
Only install this when you expect serious traffic.

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
