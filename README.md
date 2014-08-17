OpenCPU Cloud Server
--------------------

This repository contains the sources for the opencpu cloud server. It consists of the following packages:

 * `opencpu-server` - rApache based opencpu cloud server
 * `opencpu-cache` - nginx based reverse proxy with caching (debian/ubuntu only)
 * `opencpu` - meta package which installs both opencpu-server and opencpu-cache

## Installing binaries

Currently, prebuilt binaries are available for Ubuntu, Fedora and SUSE.

## Building from source

- Ubuntu:
- Debian: [wheezy.md]



Building

To build the binary packages:

    cd opencpu-deb
    debuild -us -uc

That's it :) If all goes well the .deb packages are ready to be installed :)
