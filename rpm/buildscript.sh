# First step only required on REDHAT/CENTOS:
sudo su -c 'rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm'

# Get system up to date
sudo yum update -y
sudo yum upgrade -y

# rpm build dependencies
sudo yum install -y rpm-build

# rApache build dependencies
sudo yum install -y make wget httpd-devel libapreq2-devel R-devel

# opencpu dependencies
sudo yum install -y libcurl-devel protobuf-devel

# setup dirs
mkdir -p ~/rpmbuild/SOURCES
mkdir -p ~/rpmbuild/SPECS

# Get the rapache source code
wget https://github.com/jeffreyhorner/rapache/archive/v1.2.6.tar.gz -O rapache-1.2.6.tar.gz
tar xzvf rapache-1.2.6.tar.gz rapache-1.2.6/rpm/rapache.spec --strip-components 2

# Move to build dirs
mv -f rapache-1.2.6.tar.gz ~/rpmbuild/SOURCES/
mv -f rapache.spec ~/rpmbuild/SPECS/

# Build rApache
rpmbuild -ba ~/rpmbuild/SPECS/rapache.spec

# Get opencpu source code
wget https://github.com/jeroenooms/opencpu-server/archive/v1.4.4.tar.gz -O opencpu-server-1.4.4.tar.gz
tar xzvf opencpu-server-1.4.4.tar.gz opencpu-server-1.4.4/rpm/opencpu.spec --strip-components 2

# Move to build dirs
mv -f opencpu-server-1.4.4.tar.gz ~/rpmbuild/SOURCES/
mv -f opencpu.spec ~/rpmbuild/SPECS/

# Build OpenCPU
rpmbuild -ba ~/rpmbuild/SPECS/opencpu.spec