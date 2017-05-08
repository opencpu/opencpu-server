# Use builds from launchpad
FROM opencpu/base

# Install development tools
RUN \
  apt-get install -y rstudio-server r-base-dev sudo curl git libcurl4-openssl-dev libssl-dev libxml2-dev libssh2-1-dev

CMD /usr/lib/rstudio-server/bin/rserver && apachectl -DFOREGROUND
