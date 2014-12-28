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
  service httpd restart

RUN \
  yum remove -y httpd-devel libapreq2-devel protobuf-devel openssl-devel && \
  userdel -r builder

# Apache ports
EXPOSE 80
EXPOSE 443
EXPOSE 8004

# Define default command.
CMD service httpd restart && tail -F /var/log/opencpu/apache_access.log
