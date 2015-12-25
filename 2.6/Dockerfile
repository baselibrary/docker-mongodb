FROM baselibrary/baseimage:1.0.0
MAINTAINER ShawnMa <qsma@thoughtworks.com>

ENV MONGODB_MAJOR   2.6
ENV MONGODB_VERSION 2.6.11

## Add repository
RUN \
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 7F0CEB10 &&\
  echo "deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen" > /etc/apt/sources.list.d/mongodb.list

## Install app
RUN \
  apt-get update &&\
  apt-get install -y mongodb-org=$MONGODB_VERSION python-pymongo &&\
  rm -rf /var/lib/apt/lists/*

## Install scripts
ADD docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod a+x            /docker-entrypoint.sh

EXPOSE 27017 28017

VOLUME ["/data/db"]

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["mongod"]


