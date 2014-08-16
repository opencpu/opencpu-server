Name: opencpu
Version: 1.4.4
Release: rpm0
Source: opencpu-server-%{version}.tar.gz
License: Apache2
Summary: The OpenCPU system for embedded scientific computing and reproducible research.
Group: Applications/Internet
Buildroot: %{_tmppath}/%{name}-buildroot
URL: http://www.opencpu.org
BuildRequires: R-base-devel >= 3.0.2
BuildRequires: libcurl-devel
BuildRequires: make
## BuildRequires: libprotobuf-devel #not availble on SLE11
BuildRequires: gcc-c++
Requires: opencpu-server

%description
The OpenCPU system exposes an HTTP API for embedded scientific computing with R. This provides reliable and scalable foundations for integrating R based analysis and visualization modules into pipelines, web applications or big data infrastructures. The OpenCPU server can run either as a single-user development server within the interactive R session, or as a high performance multi-user cloud server that builds on Linux, Nginx and rApache.

%package lib
Summary: OpenCPU package library.
Group: Applications/Internet
Requires: R-base >= 3.0.2
Requires: make
Requires: wget
Requires: unzip

%description lib
This RPM package contains a frozen library of platform specific builds of R packages required by the OpenCPU system.

%package server
Summary: The OpenCPU API server.
Group: Applications/Internet
Requires: rapache
Requires: opencpu-lib
Requires: smtp_daemon
Requires: curl

%description server
The OpenCPU cloud server builds on R and Apache2 (httpd) to expose the OpenCPU HTTP API.

%prep
%setup -n opencpu-server-%{version}

%build
## FIXME: Rcpp has issues with the build service. Disabling for now.
rm -f opencpu-lib/Rcpp_*
rm -f opencpu-lib/RProtoBuf_*
## AppArmor profiles don't work on Suse for now.
NO_APPARMOR=1 make library

%install
# For opencpu-lib:
mkdir -p  %{buildroot}/usr/lib/opencpu/library
cp -Rf opencpu-lib/build/* %{buildroot}/usr/lib/opencpu/library/
# For opencpu-server:
mkdir -p %{buildroot}/etc/apache2/conf.d
mkdir -p %{buildroot}/etc/cron.d
mkdir -p %{buildroot}/usr/lib/opencpu/scripts
mkdir -p %{buildroot}/usr/lib/opencpu/rapache
mkdir -p %{buildroot}/etc/opencpu
mkdir -p %{buildroot}/var/log/opencpu
cp -Rf opencpu-server/sites-available/* %{buildroot}/etc/apache2/conf.d/
sed -i s/www-data/wwwrun/g opencpu-server/cron.d/opencpu
cp -Rf opencpu-server/cron.d/* %{buildroot}/etc/cron.d/
cp -Rf opencpu-server/scripts/* %{buildroot}/usr/lib/opencpu/scripts/
cp -Rf opencpu-server/rapache/* %{buildroot}/usr/lib/opencpu/rapache/
cp -Rf opencpu-server/conf/* %{buildroot}/etc/opencpu/
cp -Rf server.conf %{buildroot}/etc/opencpu/
#hack for no-empty-package-allowed in SLE11
touch %{buildroot}/usr/lib/opencpu/emptyfile

%post server
chmod +x /usr/lib/opencpu/scripts/*.sh
touch /var/log/opencpu/access.log
touch /var/log/opencpu/error.log
service apache2 restart || true

%postun server
service apache2 restart || true

%files
%defattr(644,wwwrun,www,755)
/usr/lib/opencpu/emptyfile

%files lib
%defattr(644,wwwrun,www,755)
%dir /usr/lib/opencpu
/usr/lib/opencpu/library

%files server
%defattr(644,wwwrun,www,755)
/usr/lib/opencpu/scripts
/usr/lib/opencpu/rapache
/etc/cron.d/opencpu
/etc/apache2/conf.d
%dir /var/log/opencpu
%dir /etc/apache2
%dir /etc/opencpu
%config(noreplace) /etc/opencpu/*
