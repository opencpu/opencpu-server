FROM fedora:23

RUN \
  yum update -y && \
  yum upgrade -y && \
  yum install -y wget  && \
  cd /etc/yum.repos.d/ && \
  wget http://download.opensuse.org/repositories/home:jeroenooms:opencpu-1.6/Fedora_23/home:jeroenooms:opencpu-1.6.repo && \
  yum install -y opencpu

RUN \
  wget https://download2.rstudio.org/rstudio-server-rhel-0.99.896-x86_64.rpm && \
  yum install -y --nogpgcheck rstudio-server-rhel-0.99.896-x86_64.rpm && \
  rm rstudio-server-rhel-0.99.896-x86_64.rpm

# Apache ports
EXPOSE 80
EXPOSE 443
EXPOSE 8004

# Define default command.
CMD service httpd restart && rstudio-server restart && tail -F /var/log/opencpu/apache_access.log
