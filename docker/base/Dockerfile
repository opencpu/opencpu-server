# Use builds from launchpad
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND noninteractive

# Install and 'hold' opencpu-server so that the docker image can be tagged
RUN \
  apt-get update && \
  apt-get -y dist-upgrade && \
  apt-get install -y software-properties-common && \
  add-apt-repository -y ppa:opencpu/opencpu-2.2 && \
  apt-get update && \
  apt-get install -y opencpu-server && \
  apt-mark hold opencpu-server


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
CMD service cron start && apachectl -DFOREGROUND
