OpenCPU Cloud Server
--------------------

This repository contains the sources for the opencpu cloud server. It consists of the following packages:

 * `opencpu-server` - rApache based opencpu cloud server
 * `opencpu-cache` - nginx based reverse proxy with caching (debian/ubuntu only)
 * `opencpu` - meta package which installs both opencpu-server and opencpu-cache

## Server manual

The OpenCPU [server manual](http://jeroenooms.github.com/opencpu-manual/opencpu-server.pdf) is the primary reference for installing and managing the opencpu cloud server.

## Prebuilt binaries

Currently, prebuilt binaries are available for recent versions of:

 - [Ubuntu](https://www.opencpu.org/download.html)
 - [Fedora](http://software.opensuse.org/download.html?project=home:jeroenooms:opencpu-1.4&package=opencpu)
 - [SUSE](http://software.opensuse.org/download.html?project=home:jeroenooms:opencpu-1.4&package=opencpu)

## Building from source

OpenCPU can be build on all major Linux distributions. However only on Ubuntu it

 - `deb` package (Debian, Ubuntu): see [wheezy.md](wheezy.md)
 - `rpm` package (Fedora, CentOS, SUSE): see [rpm/readme.md](rpm/readme.md)

## Issues and questions

Please post problems or suggestions on the [issues page](https://github.com/jeroenooms/opencpu/issues). For questions see the [FAQ and mailing list](https://www.opencpu.org/faq.html).