# Use builds from launchpad
FROM opencpu/base

# Install.
RUN \
  apt-get install -y rstudio-server

 RUN \
  useradd rstudio && \
  echo "rstudio:rstudio" | chpasswd  && \
  mkdir /home/rstudio  && \
  chown rstudio:rstudio /home/rstudio  && \
  addgroup rstudio staff \

CMD /usr/lib/rstudio-server/bin/rserver && apachectl -DFOREGROUND
