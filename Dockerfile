FROM frolvlad/alpine-glibc:alpine-3.5_glibc-2.25

MAINTAINER Philipp Daniels <philipp.daniels@gmail.com>

ARG TS_VERSION=3.0.13.8

WORKDIR /tsdns

RUN echo "## Downloading ${TS_VERSION} ##" && \
  apk add --no-cache bzip2 tar && \
  wget -qO- "http://dl.4players.de/ts/releases/${TS_VERSION}/teamspeak3-server_linux_amd64-${TS_VERSION}.tar.bz2" | tar -xjv --strip-components=1 -C /tmp && \  
  apk del --purge --no-cache bzip2 tar && \
  mv /tmp/tsdns/* /tsdns/ && \
  chown -R root:root /tsdns/ && \
  rm -R /tmp/*

EXPOSE 41144/tcp

COPY docker-entrypoint.sh .
CMD ["./docker-entrypoint.sh"]

