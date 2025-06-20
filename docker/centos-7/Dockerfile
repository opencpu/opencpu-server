FROM centos:centos7

ARG BRANCH=master
ARG RSTUDIO=2023.12.0-369

# Enable Vault and install EPEL
RUN \
  sed -i.bak 's@^mirrorlist@#mirrorlist@g' /etc/yum.repos.d/*.repo &&\
  sed -i.bak 's@#.*baseurl=http://mirror.centos.org@baseurl=http://vault.centos.org@g' /etc/yum.repos.d/*.repo &&\
  yum update -y &&\
  yum install -y epel-release centos-release-scl &&\
  sed -i.bak 's@^mirrorlist@#mirrorlist@g' /etc/yum.repos.d/*.repo &&\
  sed -i.bak 's@#.*baseurl=http://mirror.centos.org@baseurl=http://vault.centos.org@g' /etc/yum.repos.d/*.repo &&\
  yum install -y devtoolset-8 &&\
  rm -f /etc/yum.repos.d/*.bak

RUN \
  curl -fsSOL https://cdn.rstudio.com/r/centos-7/pkgs/R-4.5.0-1-1.x86_64.rpm &&\
  yum install -y R-4.5.0-1-1.x86_64.rpm

ENV PATH="/opt/rh/devtoolset-8/root/usr/bin/:/opt/R/4.5.0/bin:${PATH}"

# Install.
RUN \
  useradd -ms /bin/bash builder && \
  yum update -y && \
  yum upgrade -y && \
  yum install -y rpm-build make wget tar httpd-devel libapreq2-devel R-devel libcurl-devel protobuf-devel openssl-devel libxml2-devel libicu-devel libssh2-devel cairo-devel createrepo cmake && \
  yum clean all


USER builder

RUN \
  mkdir -p ~/rpmbuild/SOURCES && \
  mkdir -p ~/rpmbuild/SPECS

RUN \
  cd ~ && \
  wget --quiet https://github.com/jeffreyhorner/rapache/archive/v1.2.11.tar.gz -O v1.2.11.tar.gz && \
  tar xzvf v1.2.11.tar.gz '*/rpm/rapache.spec' --strip-components 2 && \
  mv -f v1.2.11.tar.gz ~/rpmbuild/SOURCES/ && \
  mv -f rapache.spec ~/rpmbuild/SPECS/ && \
  rpmbuild -ba ~/rpmbuild/SPECS/rapache.spec

RUN \
  cd ~ && \
  VERSION=${BRANCH/v/} && \
  wget --quiet https://github.com/opencpu/opencpu-server/archive/${BRANCH}.tar.gz -O opencpu-server-${VERSION}.tar.gz  && \
  tar xzvf opencpu-server-${VERSION}.tar.gz opencpu-server-${VERSION}/rpm/opencpu.spec --strip-components 2 && \
  mv -f opencpu-server-${VERSION}.tar.gz ~/rpmbuild/SOURCES/ && \
  mv -f opencpu.spec ~/rpmbuild/SPECS/ && \
  rpmbuild -ba ~/rpmbuild/SPECS/opencpu.spec --define "branch ${VERSION}"

RUN \
  createrepo ~/rpmbuild/RPMS/x86_64/

USER root

RUN \
  cp -Rf /home/builder/rpmbuild/RPMS ~/ && \
  cp -Rf /home/builder/rpmbuild/SRPMS ~/ && \
  userdel -r builder

RUN \
  yum install -y MTA mod_ssl /usr/sbin/semanage && \
  cd ~/RPMS/x86_64/ && \
  rpm -i rapache-*.rpm && \
  rpm -i opencpu-lib-*.rpm && \
  rpm -i opencpu-server-*.rpm

RUN \
  wget --quiet https://download2.rstudio.org/server/centos7/x86_64/rstudio-server-rhel-${RSTUDIO}-x86_64.rpm && \
  yum install -y --nogpgcheck rstudio-server-rhel-${RSTUDIO}-x86_64.rpm && \
  rm rstudio-server-rhel-${RSTUDIO}-x86_64.rpm && \
  echo "server-app-armor-enabled=0" >> /etc/rstudio/rserver.conf

RUN \
  yum remove -y httpd-devel libapreq2-devel && \
  yum clean all

# Apache ports
EXPOSE 80
EXPOSE 443
EXPOSE 8004

# Define default command.
CMD /usr/lib/rstudio-server/bin/rserver && apachectl -DFOREGROUND
