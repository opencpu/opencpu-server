# Enable EPEL repository. Only required on REDHAT/CENTOS:
sudo su -c 'rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm'

# Update system
sudo yum update -y
sudo yum upgrade -y

# rpm dependencies
sudo yum install -y rpm-build

# rApache dependencies
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

# Download (and rename) opencpu source archive
wget https://github.com/jeroenooms/opencpu-server/archive/v1.4.4.tar.gz
tar xzf v1.4.4.tar.gz
rm v1.4.4.tar.gz
mv opencpu-server-1.4.4 opencpu-1.4.4
tar pczf opencpu-1.4.4.tar.gz opencpu-1.4.4

# Move to build dirs
mv -f opencpu-1.4.4.tar.gz ~/rpmbuild/SOURCES/
mv -f opencpu-1.4.4/rpm/opencpu.spec ~/rpmbuild/SPECS/
rm -Rf opencpu-1.4.4

# Build OpenCPU
rpmbuild -ba ~/rpmbuild/SPECS/opencpu.spec

# Install
sudo yum install mod_ssl /usr/sbin/semanage
cd ~/rpmbuild/RPMS/x86_64/
sudo rpm -i rapache-*.rpm
sudo rpm -i opencpu-lib-*.rpm
sudo rpm -i opencpu-server-*.rpm #takes a while!

# Test
curl http://localhost/ocpu/library/

