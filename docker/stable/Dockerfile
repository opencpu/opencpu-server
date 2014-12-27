# OpenCPU cloud server requires docker version 1.0 or higher!
# Instructions: https://github.com/jeroenooms/opencpu-server/tree/master/debian
# Note that AppArmor is not available inside Docker.
# Port 80 and 8004 use HTTP, port 443 is for HTTPS.
#
# Run as executable: docker run -t -p 80:80 -p 443:443 -p 8004:8004 opencpu/wheezy
# Run in background: docker run -t -d -p 80:80 -p 443:443 -p 8004:8004 opencpu/wheezy
# Run with shell: docker run -t -i -p 80:80 -p 443:443 -p 8004:8004 opencpu/wheezy sh -c 'service opencpu restart && /bin/bash'

# Pull base image.
FROM ubuntu:14.04

# Install.
RUN \
  apt-get update && \
  apt-get -y dist-upgrade && \
  apt-get install -y software-properties-common && \
  add-apt-repository -y ppa:opencpu/opencpu-1.4 && \
  apt-get update && \
  apt-get install -y opencpu rstudio-server

# Apache ports
EXPOSE 80
EXPOSE 443
EXPOSE 8004

# Define default command.
CMD service opencpu restart && tail -F /var/log/opencpu/apache_access.log
