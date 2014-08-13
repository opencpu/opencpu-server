# OpenCPU rpm package

*Instructions for building OpenCPU as an rpm package.*

**warning**: Because Redhat systems do not support AppArmor, OpenCPU runs without the advanced security policies on these platforms. Instead, it runs in the standard SElinux `httpd_modules_t` context. This is fine for internal use, but it is not recommended to expose your Fedora/EL OpenCPU server to the web without further configuring SELinux for your application.

## Prebuilt binaries (for Fedora only)

Ready-to-go rpm packages of opencpu are available for recent versions of Fedora [here](http://software.opensuse.org/download.html?project=home:jeroenooms:opencpu-1.4&package=opencpu).

## Building from source

Steps to build rpm packages on Fedora, CentOS or RHEL are in this script: [buildscript.sh](buildscript.sh).
