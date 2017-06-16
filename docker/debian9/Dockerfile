# Use builds from launchpad
FROM debian:9

# Install.
RUN \
  apt-get update && \
  apt-get -y dist-upgrade && \
  apt-get install -y wget make devscripts apache2-dev apache2 libapreq2-dev r-base r-base-dev libapparmor-dev libcurl4-openssl-dev libprotobuf-dev protobuf-compiler xvfb xauth xfonts-base curl libssl-dev libxml2-dev libicu-dev pkg-config libssh2-1-dev locales apt-utils && \
  useradd -ms /bin/bash builder

# Note: this is different from Ubuntu (c.f. 'language-pack-en-base')
RUN localedef -i en_US -f UTF-8 en_US.UTF-8

USER builder

RUN \
  cd ~ && \
  wget https://github.com/opencpu/opencpu-server/archive/v2.0.tar.gz && \
  tar xzf v2.0.tar.gz && \
  cd opencpu-server-2.0 && \
  dpkg-buildpackage -us -uc

USER root

RUN \
  apt-get install -y libapache2-mod-r-base && \
  dpkg -i /home/builder/opencpu-lib_*.deb && \
  dpkg -i /home/builder/opencpu-server_*.deb

RUN \
  apt-get install -y gdebi-core git sudo && \
  wget --quiet https://s3.amazonaws.com/rstudio-dailybuilds/rstudio-server-1.1.271-amd64.deb && \
  gdebi --non-interactive rstudio-server-1.1.271-amd64.deb && \
  rm -f rstudio-server-1.1.271-amd64.deb

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
CMD /usr/lib/rstudio-server/bin/rserver && apachectl -DFOREGROUND
