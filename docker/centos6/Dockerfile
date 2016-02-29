FROM centos:centos6

# Enable EPEL
RUN \
  yum install yum install epel-release

# Install.
RUN \
  useradd -ms /bin/bash builder && \
  yum update -y && \
  yum upgrade -y && \
  yum install -y rpm-build make wget tar httpd-devel libapreq2-devel R-devel libcurl-devel protobuf-devel openssl-devel libxml2-devel libicu-devel libssh2-devel

USER builder

RUN \
  mkdir -p ~/rpmbuild/SOURCES && \
  mkdir -p ~/rpmbuild/SPECS

RUN \
  cd ~ && \
  wget https://github.com/jeffreyhorner/rapache/archive/v1.2.7.tar.gz -O rapache-1.2.7.tar.gz && \
  tar xzvf rapache-1.2.7.tar.gz rapache-1.2.7/rpm/rapache.spec --strip-components 2 && \
  mv -f rapache-1.2.7.tar.gz ~/rpmbuild/SOURCES/ && \
  mv -f rapache.spec ~/rpmbuild/SPECS/ && \
  rpmbuild -ba ~/rpmbuild/SPECS/rapache.spec

RUN \
  cd ~ && \
  wget https://github.com/jeroenooms/opencpu-server/archive/v1.5.tar.gz -O opencpu-server-1.5.tar.gz  && \
  tar xzvf opencpu-server-1.5.tar.gz opencpu-server-1.5/rpm/opencpu.spec --strip-components 2 && \
  mv -f opencpu-server-1.5.tar.gz ~/rpmbuild/SOURCES/ && \
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
  wget https://download2.rstudio.org/rstudio-server-rhel-0.99.891-x86_64.rpm && \
  yum install --nogpgcheck rstudio-server-rhel-0.99.891-x86_64.rpm && \
  rm rstudio-server-rhel-0.99.891-x86_64.rpm 

RUN \
  yum remove -y httpd-devel libapreq2-devel && \
  userdel -r builder

# Apache ports
EXPOSE 80
EXPOSE 443
EXPOSE 8004

# Define default command.
CMD service httpd restart && rstudio-server restart && tail -F /var/log/opencpu/apache_access.log
