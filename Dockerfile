FROM alpine:latest

ENV SIAB_USERCSS="Normal:+/etc/shellinabox/options-enabled/00+Black-on-White.css,Reverse:-/etc/shellinabox/options-enabled/00_White-On-Black.css;Colors:+/etc/shellinabox/options-enabled/01+Color-Terminal.css,Monochrome:-/etc/shellinabox/options-enabled/01_Monochrome.css" \
  SIAB_PORT=4200 \
  SIAB_ADDUSER=true \
  SIAB_USER=siab \
  SIAB_USERID=1001 \
  SIAB_GROUP=siab \
  SIAB_GROUPID=1001 \
  SIAB_PASSWORD=putsafepasswordhere \
  SIAB_SHELL=/bin/bash \
  SIAB_HOME=/home/siab \
  SIAB_SUDO=false \
  SIAB_SSL=true \
  SIAB_SERVICE=/:LOGIN \
  SIAB_PKGS=none \
  SIAB_SCRIPT=none

ADD files/user-css.tar.gz /

RUN echo 'http://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories && \
    chmod 755 /etc && \
    apk --no-cache add shadow util-linux pciutils coreutils grep bash bash-completion openssl curl openssh-client sudo shellinabox python3 && \
    apk add --virtual=build gcc libffi-dev musl-dev openssl-dev python-dev make && \
    pip3 install --upgrade pip && \
    pip3 install azure-cli --no-cache-dir && \
    apk del --purge build && \
    echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

EXPOSE 4200

VOLUME /home

ADD files/entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
CMD ["shellinabox"]
