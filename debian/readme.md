# Building OpenCPU on Debian/Ubuntu

*How to build OpenCPU on Debian or Ubuntu*

## Update R (optional, but recommended)

Because `r-base` packages included with Debian/Ubuntu are often old, we first add a repository with a recent version of R. On **Ubuntu** we can use Michael Rutter's [launchpad](https://launchpad.net/~marutter/+archive/ubuntu/rrutter?field.series_filter=trusty) repository:

```sh
sudo add-apt-repository -y ppa:marutter/rrutter
sudo apt-get update
```

Alternatively, on **Debian** use `r-base` packages from CRAN (see [details](https://cran.r-project.org/bin/linux/debian/#debian-buster-stable)). For example on Debian 10.0 ("buster")

```sh
# Become root
sudo -i

# Add Wheezy CRAN repo for R 3.0+
apt-key adv --keyserver keyserver.ubuntu.com --recv-key 381BA480
echo "deb http://cran.rstudio.com/bin/linux/debian buster-cran35/" > /etc/apt/sources.list.d/cran.list
apt-get update

# Quit root
exit
```

## Build OpenCPU Server from Source

First make sure your system is up-to-date: dependencies required for building OpenCPU:

```sh
sudo apt-get update
sudo apt-get dist-upgrade -y
```

Download the opencpu-server sources from Github:

```sh
cd ~
wget https://github.com/opencpu/opencpu-server/archive/v2.1.tar.gz
tar xzf v2.1.tar.gz
cd opencpu-server-2.1
```

Install build dependencies from within `opencpu-server` source dir (requires root):

```sh
sudo mk-build-deps -i
```

Finally to build OpenCPU Server packages (`opencpu-server` and `opencpu-cache`): run this as **not root** user:

```sh
dpkg-buildpackage -us -uc
```

## Installing OpenCPU server

To install the cloud server, simply install the `deb` packages in the following order:

	
```sh
cd ~
sudo apt-get install libapache-mod-r-base
sudo dpkg -i opencpu-lib_*.deb
sudo dpkg -i opencpu-server_*.deb
```

You're done! Test if it works:

```sh
curl http://localhost/ocpu/info
```

This should print some info about the R session.

## Extra: enable AppArmor on older Debians

__Update: If you are using Ubuntu or Debian 10 or newer, AppArmor is enabled by default so you can skip this section.__

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

