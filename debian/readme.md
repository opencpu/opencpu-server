# Building OpenCPU on Debian/Ubuntu

*How to build OpenCPU on Debian (7 or higher) and Ubuntu (12.04 or higher)*

## Installing R 3.0+

Because `r-base` packages included with Debian/Ubuntu are often old, we first add a repository with a recent version of R. On **Ubuntu** we can use Michael Rutter's [launchpad](https://launchpad.net/~marutter/+archive/ubuntu/rrutter?field.series_filter=trusty) repository:

	sudo add-apt-repository -y ppa:marutter/rrutter
	sudo apt-get update

Alternatively, on Debian **Wheezy** we get packages from CRAN:

	# Become root
	sudo -i

	# Add Wheezy CRAN repo for R 3.0+
	apt-key adv --keyserver keyserver.ubuntu.com --recv-key 381BA480
	echo "deb http://cran.rstudio.com/bin/linux/debian wheezy-cran3/" > /etc/apt/sources.list.d/cran.list
	apt-get update

	# Quit root
	exit

## Building OpenCPU packages

First install dependencies required for building OpenCPU:

	# Update system
	sudo apt-get update
	sudo apt-get dist-upgrade -y

	# Install build dependencies
	sudo apt-get install -y wget make devscripts apache2-prefork-dev apache2-mpm-prefork libapreq2-dev r-base r-base-dev libapparmor-dev libcurl4-openssl-dev libprotobuf-dev libprotoc-dev xvfb xauth xfonts-base curl libssl-dev libxml2-dev libicu-dev pkg-config

Build rApache (`libapache2-mod-r-base`). Run this **not** as root (use a regular user).

	cd ~
	wget https://github.com/jeffreyhorner/rapache/archive/v1.2.6.tar.gz
	tar xzf v1.2.6.tar.gz
	cd rapache-1.2.6
	dpkg-buildpackage

Build OpenCPU Cloud Server (`opencpu-server` and `opencpu-cache`). Run this **not** as root.

	cd ~
	wget https://github.com/jeroenooms/opencpu-server/archive/v1.5.tar.gz
	tar xzf v1.5.tar.gz
	cd opencpu-server-1.5
	dpkg-buildpackage

## Installing OpenCPU server

To install the cloud server, simply install the `deb` packages in the following order:

	cd ~
	sudo dpkg -i libapache2-mod-r-base_*.deb
	sudo dpkg -i opencpu-lib_*.deb
	sudo dpkg -i opencpu-server_*.deb

## Installing OpenCPU caching server (optional)

The `opencpu-cache` package is a reverse proxy for caching and load balancing with OpenCPU. When installed, it automatically preroutes all incomming traffic on ports 80 and 443 through nginx. Only install this when you expect serious traffic.

	# Dependencies
	sudo apt-get install nginx

	# Package builds
	cd ~
	sudo dpkg -i opencpu-cache_*.deb

Note that it is possible to install `opencpu-cache` on another server than `opencpu-server` if you update the nginx back-end config accordingly.

## Enable AppArmor support (optional, **debian only**)

OpenCPU uses AppArmor to enforce advanced security policies. AppArmor support is installed by default on Ubuntu, but in Debian we first need to enable it in the kernel. To do so, edit `/etc/default/grub` and add `security=apparmor` to the `GRUB_CMDLINE_LINUX` line. For example it would read:

	GRUB_CMDLINE_LINUX="security=apparmor"

Update the grub config and reboot:

	sudo update-grub
	sudo reboot

After rebooting, install the apparmor packages and verify that it is enabled:

	sudo apt-get install apparmor-utils
	sudo aa-status

Restart OpenCPU and check the log files to confirm that apparmor works:

	sudo service opencpu restart
    sudo tail /var/log/apache2/error.log -n30
