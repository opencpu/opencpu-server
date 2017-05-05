# Building OpenCPU on Debian/Ubuntu

*How to build OpenCPU on Debian or Ubuntu*

## Update R (optional, but recommended)

Because `r-base` packages included with Debian/Ubuntu are often old, we first add a repository with a recent version of R. On **Ubuntu** we can use Michael Rutter's [launchpad](https://launchpad.net/~marutter/+archive/ubuntu/rrutter?field.series_filter=trusty) repository:

	sudo add-apt-repository -y ppa:marutter/rrutter
	sudo apt-get update

Alternatively, on **Debian** use `r-base` packages from CRAN (see [details](https://cran.rstudio.com/bin/linux/debian/#debian-jessie-stable)). For example on Debian 8.0 ("jessie")

	# Become root
	sudo -i

	# Add Wheezy CRAN repo for R 3.0+
	apt-key adv --keyserver keyserver.ubuntu.com --recv-key 381BA480
	echo "deb http://cran.rstudio.com/bin/linux/debian jessie-cran3/" > /etc/apt/sources.list.d/cran.list
	apt-get update

	# Quit root
	exit

## Install Build Dependencies

First install dependencies required for building OpenCPU:

	# Update system
	sudo apt-get update
	sudo apt-get dist-upgrade -y

	# Install build dependencies
	sudo apt-get install -y wget make devscripts apache2-dev apache2 libapreq2-dev r-base r-base-dev libapparmor-dev libcurl4-openssl-dev libprotobuf-dev protobuf-compiler xvfb xauth xfonts-base curl libssl-dev libxml2-dev libicu-dev pkg-config libssh2-1-dev

## Building rApache

**UPDATE**: As of 2016 [libapache2-mod-r-base](http://packages.ubuntu.com/xenial/web/libapache2-mod-r-base) is now included with:

 - **Debian 9** (Stretch) and up
 - **Ubuntu 16.04** (Xenial) and up

On these platforms **skip this step** and proceed with building `opencpu-server` below! On older systems we need to `libapache2-mod-r-base` ourselves: run this **not** as root (use a regular user):

	cd ~
	wget https://github.com/jeffreyhorner/rapache/archive/v1.2.8.tar.gz
	tar xzf v1.2.8.tar.gz
	cd rapache-1.2.8
	dpkg-buildpackage -us -uc

## Building OpenCPU

To build OpenCPU Server (`opencpu-server` and `opencpu-cache`): run this **not** as root.

	cd ~
	wget https://github.com/jeroen/opencpu-server/archive/v2.0.tar.gz
	tar xzf v2.0.tar.gz
	cd opencpu-server-2.0
	dpkg-buildpackage -us -uc

## Installing OpenCPU server

To install the cloud server, simply install the `deb` packages in the following order:

	cd ~

	# Only if needed, see above
	sudo dpkg -i libapache2-mod-r-base_*.deb

	# Always needed
	sudo dpkg -i opencpu-lib_*.deb
	sudo dpkg -i opencpu-server_*.deb

You're done! Test if it works:

	curl http://localhost/ocpu/info

That should print some info about the R session.

## Extra: enable AppArmor (**debian only**)

OpenCPU uses AppArmor to enforce advanced security policies. AppArmor support is installed by default on Ubuntu, but in Debian we first need to enable it in the kernel. To do so, edit `/etc/default/grub` and add `security=apparmor` to the `GRUB_CMDLINE_LINUX` line. For example it would read:

	GRUB_CMDLINE_LINUX="security=apparmor"

Update the grub config and reboot:

	sudo update-grub
	sudo reboot

After rebooting, install the apparmor packages and verify that it is enabled:

	sudo apt-get install apparmor-utils
	sudo aa-status

Restart OpenCPU and check the log files to confirm that apparmor works:

	sudo service apache2 restart
    sudo tail /var/log/apache2/error.log -n30

## OpenCPU caching server (not recommended)

The `opencpu-cache` package is a reverse proxy for caching and load balancing with OpenCPU. When installed, it automatically preroutes all incomming traffic on ports 80 and 443 through nginx. Only install this when you expect serious traffic.

	# Dependencies
	sudo apt-get install nginx

	# Package builds
	cd ~
	sudo dpkg -i opencpu-cache_*.deb

Note that it is possible to install `opencpu-cache` on another server than `opencpu-server` if you update the nginx back-end config accordingly.

