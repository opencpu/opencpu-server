FROM cran/ubuntu

ENV DEBIAN_FRONTEND noninteractive

RUN \
  apt-get update && \
  add-apt-repository -y ppa:opencpu/opencpu-2.2 && \
  apt-get install -y opencpu-server

RUN \
  ln -sf /proc/self/fd/1 /var/log/apache2/access.log && \
  ln -sf /proc/self/fd/1 /var/log/apache2/error.log && \
  ln -sf /proc/self/fd/1 /var/log/opencpu/apache_access.log && \
  ln -sf /proc/self/fd/1 /var/log/opencpu/apache_error.log

CMD service cron start && apachectl -DFOREGROUND
