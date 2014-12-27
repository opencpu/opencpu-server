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
  wget https://github.com/jeroenooms/opencpu-server/archive/master.tar.gz && \
  tar xzf master.tar.gz && \
  cd opencpu-server-master && \
  dpkg-buildpackage

USER root

RUN \
  cd /home/builder && \
  dpkg -i libapache2-mod-r-base_*.deb && \
  dpkg -i opencpu-lib_*.deb && \
  dpkg -i opencpu-server_*.deb

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
