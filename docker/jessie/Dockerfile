# OpenCPU cloud server requires docker version 1.0 or higher!
# Instructions: https://github.com/jeroenooms/opencpu-server/tree/master/debian
# Note that AppArmor is not available inside Docker.
# Port 80 and 8004 use HTTP, port 443 is for HTTPS.
#
# Run as executable: docker run -t -p 80:80 -p 443:443 -p 8004:8004 opencpu/jessie
# Run in background: docker run -t -d -p 80:80 -p 443:443 -p 8004:8004 opencpu/jessie
# Run with shell: docker run -t -i -p 80:80 -p 443:443 -p 8004:8004 opencpu/jessie sh -c 'service opencpu restart && /bin/bash'

# Pull base image.
FROM debian:jessie

# Install.
RUN \
  useradd -ms /bin/bash builder && \
  apt-key adv --keyserver keyserver.ubuntu.com --recv-key 381BA480 && \
  echo "deb http://cran.rstudio.com/bin/linux/debian wheezy-cran3/" > /etc/apt/sources.list.d/cran.list && \
  apt-get update && \
  apt-get -y dist-upgrade && \
  apt-get install -y wget make devscripts apache2-prefork-dev apache2-mpm-prefork libapreq2-dev r-base r-base-dev libapparmor-dev libcurl4-openssl-dev libprotobuf-dev libprotoc-dev xvfb xauth xfonts-base curl libssl-dev pkg-config

USER builder

RUN \
  cd ~ && \
  wget https://github.com/jeffreyhorner/rapache/archive/v1.2.6.tar.gz && \
  tar xzf v1.2.6.tar.gz && \
  cd rapache-1.2.6 && \
  dpkg-buildpackage

RUN \
  cd ~ && \
  wget https://github.com/jeroenooms/opencpu-server/archive/v1.4.6.tar.gz && \
  tar xzf v1.4.6.tar.gz && \
  cd opencpu-server-1.4.6 && \
  dpkg-buildpackage

USER root

RUN \
  cd /home/builder && \
  dpkg -i libapache2-mod-r-base_*.deb && \
  dpkg -i opencpu-lib_*.deb && \
  dpkg -i opencpu-server_*.deb

RUN \
  wget -q http://ftp.us.debian.org/debian/pool/main/o/openssl/libssl0.9.8_0.9.8o-4squeeze14_amd64.deb && \
  dpkg -i libssl0.9.8_0.9.8o-4squeeze14_amd64.deb && rm libssl0.9.8_0.9.8o-4squeeze14_amd64.deb && \
  VER=$(curl --insecure https://s3.amazonaws.com/rstudio-server/current.ver) && \
  wget -q http://download2.rstudio.org/rstudio-server-${VER}-amd64.deb && \
  dpkg -i rstudio-server-${VER}-amd64.deb && \
  rm rstudio-server-*-amd64.deb && \
  ln -s /usr/lib/rstudio-server/bin/pandoc/pandoc /usr/local/bin && \
  ln -s /usr/lib/rstudio-server/bin/pandoc/pandoc-citeproc /usr/local/bin

RUN \
  apt-get purge -y devscripts apache2-prefork-dev libapreq2-dev libapparmor-dev libprotobuf-dev libprotoc-dev xvfb xauth pkg-config && \
  apt-get autoremove --purge -y && \
  deluser builder --remove-home

# Apache ports (without caching)
EXPOSE 80
EXPOSE 443
EXPOSE 8004

# Define default command.
CMD service opencpu restart && tail -F /var/log/opencpu/apache_access.log
