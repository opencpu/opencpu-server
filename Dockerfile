# Docker file to run OpenCPU cloud server
# Note that AppArmor security might not work within Docker.
#
# To install: docker run -d -p 80:8006 -p 443:8007 {image}
#

# Pull base image.
FROM ubuntu:14.04

# Install.
RUN \
  apt-get update && \
  apt-get -y dist-upgrade && \
  apt-get install -y software-properties-common && \
  add-apt-repository -y ppa:opencpu/opencpu-dev && \
  apt-get update && \
  apt-get install -y opencpu rstudio-server

# Apache ports (no cache)
EXPOSE 80
EXPOSE 443

# Nginx ports (cache)
EXPOSE 8006
EXPOSE 8007

# Define default command.
CMD service apache2 start && service nginx start && tail -F -n15 /var/log/apache2/error.log
