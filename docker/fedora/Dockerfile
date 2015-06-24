FROM fedora:22

RUN \
  cd /etc/yum.repos.d/ && \
  wget http://download.opensuse.org/repositories/home:jeroenooms:opencpu-1.5/Fedora_22/home:jeroenooms:opencpu-1.5.repo && \
  yum update -y && \
  yum upgrade -y && \  
  yum install -y opencpu

RUN \
  wget http://download2.rstudio.org/rstudio-server-rhel-0.99.448-x86_64.rpm && \
  yum install --nogpgcheck rstudio-server-rhel-0.99.448-x86_64.rpm && \
  rm rstudio-server-rhel-0.99.448-x86_64.rpm

# Apache ports
EXPOSE 80
EXPOSE 443
EXPOSE 8004

# Define default command.
CMD service httpd restart && rstudio-server restart && tail -F /var/log/opencpu/apache_access.log
