# syntax=docker/dockerfile:1
ARG BRANCH=master
ARG RSTUDIO=2024.04.0-735

# Build image
FROM ubuntu:22.04 AS builder
ARG BRANCH
ENV DEBIAN_FRONTEND noninteractive

# Install.
RUN \
#  apt-get update && \
#  apt-get -y dist-upgrade && \
#  apt-get install -y software-properties-common && \
#  add-apt-repository -y ppa:opencpu/opencpu-2.2 && \
  apt-get update && \
  apt-get install -y wget make devscripts apache2-dev apache2 libapreq2-dev r-base r-base-dev libapparmor-dev libcurl4-openssl-dev libprotobuf-dev protobuf-compiler libcairo2-dev libfontconfig-dev xvfb xauth xfonts-base curl libssl-dev libxml2-dev libicu-dev pkg-config libssh2-1-dev locales apt-utils cmake && \
  useradd -ms /bin/bash builder

# Different from debian
RUN apt-get install -y language-pack-en-base

USER builder

RUN \
  cd ~ && \
  wget --quiet https://github.com/opencpu/opencpu-server/archive/${BRANCH}.tar.gz && \
  tar xzf ${BRANCH}.tar.gz && rm ${BRANCH}.tar.gz && \
  cd opencpu-server-* && \
  dpkg-buildpackage -us -uc

FROM ubuntu:22.04
USER root
ARG RSTUDIO
ENV DEBIAN_FRONTEND noninteractive
WORKDIR /root/
COPY --from=builder /home/builder/opencpu*deb ./

RUN \
  apt-get update && \
  apt-get -y dist-upgrade && \
  apt-get install -y software-properties-common gdebi-core git wget sudo cron && \
  add-apt-repository -y ppa:opencpu/opencpu-2.2 && \
  gdebi --non-interactive opencpu-lib_*.deb && \
  gdebi --non-interactive opencpu-server_*.deb

RUN \
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
