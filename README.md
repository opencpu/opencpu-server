OpenCPU Cloud Server
--------------------

This repository contains the sources for the opencpu cloud server. It currently only builds on Ubuntu 12.04 and up. It builds the following packages:

 * `opencpu-server` - rApache based opencpu cloud server
 * `opencpu-cache` - nginx based reverse proxy with caching
 * `opencpu` - meta package which installs both opencpu-server and opencpu-cache
 * `opencpu-tex`- meta package which installs a lot of latex stuff thats nice to have on an opencpu server.

###Dependencies

All of the dependencies are defined in the [control file](https://github.com/jeroenooms/opencpu-deb/blob/master/debian/control). They include:

 * `r-base-dev`
 * `libapparmor-dev`
 * `apache2`
 * `libapache2-mod-r-base`
 
Note that the last one (rApache) does not ship with Ubuntu. You can get it at http://rapache.net/.

###Building

To build the binary packages:

    debuild -us -uc
    
That's it :) If all goes well the .deb packages are ready to be installed :)    
