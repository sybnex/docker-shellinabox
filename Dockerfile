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

COPY files/entrypoint.sh /
COPY files/user-css.tar.gz /

RUN echo 'http://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories && \
    chmod 755 /etc && \
    apk --no-cache add shadow util-linux coreutils grep bash bash-completion openssl curl openssh-client sudo shellinabox git py-pip docker && \
    apk add --virtual=build gcc libffi-dev musl-dev openssl-dev python-dev make && \
    pip install --upgrade pip && \
    pip install azure-cli --no-cache-dir && \
    apk del --purge build && \
    curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x kubectl && \
    mv kubectl /usr/bin/ && \
    echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

EXPOSE 4200

VOLUME /home

ENTRYPOINT ["/entrypoint.sh"]
CMD ["shellinabox"]
