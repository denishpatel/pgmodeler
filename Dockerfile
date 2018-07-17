FROM debian:stretch-slim

LABEL maintainer "Denish Patel <denish.j.patel@gmail.com>"

ENV PG_VERSION 0.9.1-beta1

ADD https://github.com/denishpatel/pgmodeler/v${PG_VERSION}.tar.gz /usr/local/src/
WORKDIR /usr/local/src/

RUN if [ ! -d pgmodeler-${PG_VERSION} ]; then tar xvzf v${PG_VERSION}.tar.gz; fi \
  && cd pgmodeler-${PG_VERSION} \
  && BUILD_PKGS="make g++ qt5-qmake libxml2-dev \
    libpq-dev pkg-config libqt5svg5-dev" \
  && RUNTIME_PKGS="qt5-default libqt5svg5 postgresql-server-dev-9.6" \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive \
     apt-get -y install ${BUILD_PKGS} ${RUNTIME_PKGS} \
  && qmake pgmodeler.pro \
  && make && make install \
  && cd .. \
  && apt-get remove --purge -y $BUILD_PKGS \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir -p /usr/local/lib/pgmodeler/plugins \
  && chmod 777 /usr/local/lib/pgmodeler/plugins

ENTRYPOINT ["/usr/local/bin/pgmodeler"]
