# Use builds from launchpad
FROM ubuntu:16.04

# Install.
RUN \
  apt-get update && \
  apt-get -y dist-upgrade && \
  apt-get install -y software-properties-common && \
  add-apt-repository -y ppa:opencpu/opencpu-2.0 && \
  apt-get update && \
  apt-get install -y opencpu rstudio-server

# Apache ports
EXPOSE 80
EXPOSE 443
EXPOSE 8004

# Define default command.
CMD service apache2 restart && rstudio-server restart && tail -F /var/log/opencpu/apache_access.log
