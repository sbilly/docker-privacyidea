FROM ubuntu:14.04
MAINTAINER sbilly <superli.1980@gmail.com>

RUN \
  echo "deb mirror://mirrors.ubuntu.com/mirrors.txt precise main restricted universe multiverse" > /etc/apt/sources.mirror.list && \
  echo "deb mirror://mirrors.ubuntu.com/mirrors.txt precise-updates main restricted universe multiverse" >> /etc/apt/sources.mirror.list && \
  echo "deb mirror://mirrors.ubuntu.com/mirrors.txt precise-backports main restricted universe multiverse" >> /etc/apt/sources.mirror.list && \
  echo "deb mirror://mirrors.ubuntu.com/mirrors.txt precise-security main restricted universe multiverse" >> /etc/apt/sources.mirror.list && \
  cat /etc/apt/sources.list >> /etc/apt/sources.mirror.list && \
  mv /etc/apt/sources.mirror.list /etc/apt/sources.list && \
  apt-get update

RUN apt-get install -y build-essential python-dev git curl wget lftp

# Install privacyidea
RUN \
  apt-get install -y pkg-config libfreetype6-dev libpng12-dev libpq-dev libssl-dev libffi-dev libmysqlclient-dev mysql-client && \
  mkdir -p /opt && \
  cd /opt && \
  git clone https://github.com/privacyidea/privacyidea.git && \
  cd privacyidea && \
  curl -L https://bootstrap.pypa.io/get-pip.py | python && \
  pip install certifi && \
  pip install virtualenv && \
  virtualenv venv && \
  . /opt/privacyidea/venv/bin/activate && \
  pip install -r requirements.txt && \
  pip install MySQL-python && \
  pip install uwsgi && \  
  useradd privacyidea && \
  chown privacyidea:privacyidea /opt/privacyidea -R

RUN \
  mkdir -p /run/uwsgi/app/privacyidea/ && \
  chown privacyidea:privacyidea /run/uwsgi/app/privacyidea/ -R

# RUN apt-get install -y privacyidea-radius privacyidea-pam privacyidea-otrs 
# RUN apt-get install -y privacyidea-simplesamlphp 

# install nginx and supervisor
RUN \
  apt-get install -y nginx supervisor

EXPOSE 5001
EXPOSE 9000
EXPOSE 80

VOLUME /etc/privacyidea
VOLUME /etc/nginx/sites-available
VOLUME /var/log/privacyidea
VOLUME /var/lib/privacyidea

ADD bin/entrypoint.sh /opt/privacyidea
ADD config/etc/privacyidea/privacyideaapp.py /opt/privacyidea/privacyideaapp.py
ADD config/etc/supervisor/conf.d/* /etc/supervisor/conf.d/
ADD config/etc/nginx/sites-available/* /etc/nginx/sites-available/

RUN chown privacyidea:privacyidea /opt/privacyidea -R

# make cleanning
RUN \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# USER privacyidea
WORKDIR /opt/privacyidea
ENTRYPOINT bash /opt/privacyidea/entrypoint.sh
