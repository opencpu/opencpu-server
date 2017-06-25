FROM fedora:latest

ENV BRANCH 2.0.2

# Install.
RUN \
  useradd -ms /bin/bash builder && \
  yum update -y && \
  yum upgrade -y && \
  yum install -y rpm-build make wget tar httpd-devel libapreq2-devel R-devel libcurl-devel protobuf-devel openssl-devel libxml2-devel libicu-devel libssh2-devel createrepo && \
  yum clean all

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
  wget https://github.com/opencpu/opencpu-server/archive/v${BRANCH}.tar.gz -O opencpu-server-${BRANCH}.tar.gz  && \
  tar xzvf opencpu-server-${BRANCH}.tar.gz opencpu-server-${BRANCH}/rpm/opencpu.spec --strip-components 2 && \
  mv -f opencpu-server-${BRANCH}.tar.gz ~/rpmbuild/SOURCES/ && \
  mv -f opencpu.spec ~/rpmbuild/SPECS/ && \
  rpmbuild -ba ~/rpmbuild/SPECS/opencpu.spec --define "branch ${BRANCH}"

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
  wget https://download2.rstudio.org/rstudio-server-rhel-1.0.143-x86_64.rpm && \
  yum install -y --nogpgcheck rstudio-server-rhel-1.0.143-x86_64.rpm && \
  rm rstudio-server-rhel-1.0.143-x86_64.rpm

RUN \
  yum remove -y httpd-devel libapreq2-devel && \
  yum clean all

# Apache ports
EXPOSE 80
EXPOSE 443
EXPOSE 8004

# Define default command.
CMD /usr/lib/rstudio-server/bin/rserver && apachectl -DFOREGROUND
