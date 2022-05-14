# Building OpenCPU on Debian/Ubuntu

*How to build OpenCPU on Debian or Ubuntu*

## Prepare: update R (optional, but recommended)

Because `r-base` packages included with Debian/Ubuntu are often old, we first add a repository with a recent version of R. On **Ubuntu** we can use Michael Rutter's [launchpad](https://launchpad.net/~marutter/+archive/ubuntu/rrutter?field.series_filter=trusty) repository:

```sh
sudo add-apt-repository -y ppa:marutter/rrutter4.0
sudo apt-get update
```

Alternatively, on **Debian** use `r-base` packages from CRAN (see [details](https://cran.r-project.org/bin/linux/debian/#debian-buster-stable)). For example on Debian 10.0 ("buster")

```sh
# Become root
sudo -i

# Add Wheezy CRAN repo for R 3.0+
apt-key adv --keyserver keyserver.ubuntu.com --recv-key 381BA480
echo "deb http://cran.rstudio.com/bin/linux/debian buster-cran40/" > /etc/apt/sources.list.d/cran.list
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
wget https://github.com/opencpu/opencpu-server/archive/v2.2.tar.gz
tar xzf v2.2.tar.gz
cd opencpu-server-2.2
```

Install build dependencies from within `opencpu-server` source dir (requires root):

```sh
sudo mk-build-deps -i
```

Finally to build OpenCPU Server package (`opencpu-server`): run this as **not root** user:

```sh
dpkg-buildpackage -us -uc
```

## Installing OpenCPU server

To install the cloud server, simply install the `deb` packages in the following order:

	
```sh
cd ~
sudo dpkg -i opencpu-lib_*.deb
sudo dpkg -i opencpu-server_*.deb
```

You're done! Test if it works:

```sh
curl http://localhost/ocpu/info
```

This should print some info about the R session.
