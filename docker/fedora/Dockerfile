FROM fedora:latest

ARG BRANCH=master
ARG RSTUDIO=2024.12.1-563

# Install.
RUN \
  useradd -ms /bin/bash builder && \
  dnf update -y && \
  dnf upgrade -y && \
  dnf install -y rpm-build make wget tar httpd httpd-devel libapreq2-devel R-devel libcurl-devel protobuf-devel openssl-devel libxml2-devel libicu-devel cairo-devel createrepo cmake && \
  dnf clean all

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
  dnf install -y MTA mod_ssl /usr/sbin/semanage && \
  /usr/libexec/httpd-ssl-gencerts && \
  cd ~/RPMS/x86_64/ && \
  rpm -i rapache-*.rpm && \
  rpm -i opencpu-lib-*.rpm && \
  rpm -i opencpu-server-*.rpm

RUN \
  wget --quiet https://download2.rstudio.org/server/rhel9/x86_64/rstudio-server-rhel-${RSTUDIO}-x86_64.rpm && \
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
CMD /usr/lib/rstudio-server/bin/rserver && httpd -k start -DFOREGROUND
