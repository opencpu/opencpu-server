# Use builds from launchpad
FROM opencpu/base

# Install.
RUN \
  apt-get install -y rstudio-server

CMD service apache2 restart && rstudio-server restart && tail -F /var/log/opencpu/apache_access.log
