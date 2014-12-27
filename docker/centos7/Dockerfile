# OpenCPU cloud server requires docker version 1.0 or higher!
# Instructions: https://github.com/jeroenooms/opencpu-server/tree/master/rpm
# Port 80 and 8004 use HTTP, port 443 is for HTTPS.
#
# Run as executable: docker run -t -p 80:80 -p 443:443 -p 8004:8004 opencpu/centos7
# Run in background: docker run -t -d -p 80:80 -p 443:443 -p 8004:8004 opencpu/centos7
# Run with shell: docker run -t -i -p 80:80 -p 443:443 -p 8004:8004 opencpu/centos7 sh -c 'service opencpu restart && /bin/bash'

# Pull base image.
FROM centos:centos7

# Enable EPEL
RUN \
  su -c 'rpm -Uvh http://download.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm'

# Install.
RUN \
  useradd -ms /bin/bash builder && \
  yum update -y && \
  yum upgrade -y && \
  yum install -y rpm-build make wget tar httpd-devel libapreq2-devel R-devel libcurl-devel protobuf-devel openssl-devel

USER builder

RUN \
  mkdir -p ~/rpmbuild/SOURCES && \
  mkdir -p ~/rpmbuild/SPECS

RUN \
  cd ~ && \
  wget https://github.com/jeffreyhorner/rapache/archive/v1.2.6.tar.gz -O rapache-1.2.6.tar.gz && \
  tar xzvf rapache-1.2.6.tar.gz rapache-1.2.6/rpm/rapache.spec --strip-components 2 && \
  mv -f rapache-1.2.6.tar.gz ~/rpmbuild/SOURCES/ && \
  mv -f rapache.spec ~/rpmbuild/SPECS/ && \
  rpmbuild -ba ~/rpmbuild/SPECS/rapache.spec

RUN \
  cd ~ && \
  wget https://github.com/jeroenooms/opencpu-server/archive/v1.4.6.tar.gz -O opencpu-server-1.4.6.tar.gz  && \
  tar xzvf opencpu-server-1.4.6.tar.gz opencpu-server-1.4.6/rpm/opencpu.spec --strip-components 2 && \
  mv -f opencpu-server-1.4.6.tar.gz ~/rpmbuild/SOURCES/ && \
  mv -f opencpu.spec ~/rpmbuild/SPECS/ && \
  rpmbuild -ba ~/rpmbuild/SPECS/opencpu.spec

USER root

RUN \
  yum install -y MTA mod_ssl /usr/sbin/semanage && \
  cd /home/builder/rpmbuild/RPMS/x86_64/ && \
  rpm -i rapache-*.rpm && \
  rpm -i opencpu-lib-*.rpm && \
  rpm -i opencpu-server-*.rpm

RUN \
  yum remove -y httpd-devel libapreq2-devel protobuf-devel openssl-devel && \
  deluser builder --remove-home

# Apache ports
EXPOSE 80
EXPOSE 443
EXPOSE 8004

# Define default command.
CMD service opencpu restart && tail -F /var/log/opencpu/apache_access.log
