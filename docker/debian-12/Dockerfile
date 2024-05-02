FROM debian:12

ARG BRANCH=master
ARG RSTUDIO=2024.04.0-735

# On Debian-12, libapache2-mod-r-base and libapreq are only available in backports :(
RUN sed 's|bookworm-updates|bookworm-updates bookworm-backports|' -i /etc/apt/sources.list.d/debian.sources

RUN \
  apt-get update && \
  apt-get -y dist-upgrade && \
  apt-get install -y wget make devscripts apache2-dev apache2 libapreq2-dev r-base r-base-dev libapparmor-dev libfontconfig-dev libcurl4-openssl-dev libprotobuf-dev protobuf-compiler libcairo2-dev xvfb xauth xfonts-base curl libssl-dev libxml2-dev libicu-dev pkg-config libssh2-1-dev locales apt-utils cmake && \
  useradd -ms /bin/bash builder

# Note: this is different from Ubuntu (c.f. 'language-pack-en-base')
RUN localedef -i en_US -f UTF-8 en_US.UTF-8

USER builder

RUN \
  cd ~ && \
  wget --quiet https://github.com/opencpu/opencpu-server/archive/${BRANCH}.tar.gz && \
  tar xzf ${BRANCH}.tar.gz && rm ${BRANCH}.tar.gz && \
  cd opencpu-server-* && \
  sed -i 's/focal/bullseye/g' debian/changelog && \
  dpkg-buildpackage -us -uc

USER root

RUN \
  apt-get install -y libapache2-mod-r-base cron && \
  dpkg -i /home/builder/opencpu-lib_*.deb && \
  dpkg -i /home/builder/opencpu-server_*.deb

RUN \
  apt-get install -y gdebi-core git sudo && \
  wget --quiet https://download2.rstudio.org/server/jammy/amd64/rstudio-server-${RSTUDIO}-amd64.deb && \
  gdebi --non-interactive rstudio-server-${RSTUDIO}-amd64.deb && \
  rm -f rstudio-server-${RSTUDIO}-amd64.deb && \
  echo "server-app-armor-enabled=0" >> /etc/rstudio/rserver.conf

# Prints apache logs to stdout
RUN \
  ln -sf /proc/self/fd/1 /var/log/apache2/access.log && \
  ln -sf /proc/self/fd/1 /var/log/apache2/error.log && \
  ln -sf /proc/self/fd/1 /var/log/opencpu/apache_access.log && \
  ln -sf /proc/self/fd/1 /var/log/opencpu/apache_error.log

# Set opencpu password so that we can login
RUN \
  echo "opencpu:opencpu" | chpasswd

# Apache ports
EXPOSE 80
EXPOSE 443
EXPOSE 8004

# Start non-daemonized webserver
CMD service cron start && /usr/lib/rstudio-server/bin/rserver && apachectl -DFOREGROUND
