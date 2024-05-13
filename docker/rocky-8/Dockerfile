FROM rockylinux/rockylinux:8

ARG BRANCH=master
ARG RSTUDIO=2024.04.0-735

# Enable EPEL
RUN \
  dnf upgrade -y && \
  dnf install -y dnf-plugins-core epel-release && \
  dnf config-manager --set-enabled powertools epel-testing

# Install.
RUN \
  useradd -ms /bin/bash builder && \
  dnf update -y && \
  dnf upgrade -y && \
  dnf install -y rpm-build make wget tar httpd-devel libapreq2-devel R-devel libcurl-devel protobuf-devel openssl-devel libxml2-devel libicu-devel cairo-devel createrepo cmake && \
  dnf clean all

USER builder

RUN \
  mkdir -p ~/rpmbuild/SOURCES && \
  mkdir -p ~/rpmbuild/SPECS

RUN \
  cd ~ && \
  wget --quiet https://github.com/jeffreyhorner/rapache/archive/v1.2.9.tar.gz -O rapache-1.2.9.tar.gz && \
  tar xzvf rapache-1.2.9.tar.gz rapache-1.2.9/rpm/rapache.spec --strip-components 2 && \
  mv -f rapache-1.2.9.tar.gz ~/rpmbuild/SOURCES/ && \
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
  dnf install -y MTA mod_ssl /usr/sbin/semanage && \
  /usr/libexec/httpd-ssl-gencerts && \
  cd ~/RPMS/x86_64/ && \
  rpm -i rapache-*.rpm && \
  rpm -i opencpu-lib-*.rpm && \
  rpm -i opencpu-server-*.rpm

RUN \
  wget --quiet https://download2.rstudio.org/server/rhel8/x86_64/rstudio-server-rhel-${RSTUDIO}-x86_64.rpm && \
  dnf install -y --nogpgcheck rstudio-server-rhel-${RSTUDIO}-x86_64.rpm && \
  rm rstudio-server-rhel-${RSTUDIO}-x86_64.rpm && \
  echo "server-app-armor-enabled=0" >> /etc/rstudio/rserver.conf

RUN \
  dnf remove -y httpd-devel libapreq2-devel && \
  dnf clean all

# Apache ports
EXPOSE 80
EXPOSE 443
EXPOSE 8004

# Define default command.
CMD /usr/lib/rstudio-server/bin/rserver && apachectl -DFOREGROUND
