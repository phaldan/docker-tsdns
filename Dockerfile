FROM frolvlad/alpine-glibc:alpine-3.7_glibc-2.26

MAINTAINER Philipp Daniels <philipp.daniels@gmail.com>

ARG TS_VERSION=3.1.1

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

ARG VCS_REF
ARG BUILD_DATE
LABEL org.label-schema.schema-version="1.0" \
      org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.name="TSDNS" \
      org.label-schema.version="${TS_VERSION}" \
      org.label-schema.description="Server for TSDNS - TeamSpeak Domain Name System" \
      org.label-schema.url="https://www.teamspeak.com/en/teamspeak3.html" \
      org.label-schema.usage="https://support.teamspeakusa.com/index.php?/Knowledgebase/Article/View/293/0/does-teamspeak-3-support-dns-srv-records" \
      org.label-schema.vcs-url="https://github.com/phaldan/docker-tsdns" \
      org.label-schema.vcs-ref=${VCS_REF} \
      org.label-schema.vendor="PhALDan"

