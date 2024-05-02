# Use builds from launchpad
FROM opencpu/base

# Install development tools
RUN \
  apt-get update && \
  apt-get install -y rstudio-server r-base-dev sudo curl git libcurl4-openssl-dev libssl-dev libxml2-dev libssh2-1-dev gdebi-core &&\
  wget https://download2.rstudio.org/server/jammy/amd64/rstudio-server-2024.04.0-735-amd64.deb &&\
  gdebi rstudio-server-2024.04.0-735-amd64.deb &&\
  rm rstudio-server-2024.04.0-735-amd64.deb

# Workaround for rstudio apparmor bug
RUN mkdir -p /etc/rstudio && \
    echo "server-app-armor-enabled=0" >> /etc/rstudio/rserver.conf

CMD service cron start && /usr/lib/rstudio-server/bin/rserver && apachectl -DFOREGROUND
