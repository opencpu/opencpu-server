FROM cran/ubuntu

ENV DEBIAN_FRONTEND noninteractive

RUN \
  apt-get update && \
  add-apt-repository -y ppa:opencpu/opencpu-2.2 && \
  apt-get upgrade -y && \
  apt-get install -y opencpu-server postfix libsasl2-modules gdebi-core &&\
  wget --quiet https://download2.rstudio.org/server/jammy/amd64/rstudio-server-2024.04.0-735-amd64.deb &&\
  gdebi --non-interactive rstudio-server-2024.04.0-735-amd64.deb &&\
  rm rstudio-server-2024.04.0-735-amd64.deb

RUN \
  echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections && \
  apt-get install -y ttf-mscorefonts-installer

RUN \
  ln -sf /proc/self/fd/1 /var/log/apache2/access.log && \
  ln -sf /proc/self/fd/1 /var/log/apache2/error.log && \
  ln -sf /proc/self/fd/1 /var/log/opencpu/apache_access.log && \
  ln -sf /proc/self/fd/1 /var/log/opencpu/apache_error.log

# Workaround for rstudio apparmor bug
RUN mkdir -p /etc/rstudio && \
    echo "server-app-armor-enabled=0" >> /etc/rstudio/rserver.conf

COPY startup /startup

ENTRYPOINT ["/startup"]
