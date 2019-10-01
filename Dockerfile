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
    apk --no-cache add shadow certbot tmux util-linux coreutils grep bash tree bash-completion openssl curl openssh-client sudo shellinabox git py-pip && \
    apk --no-cache add --virtual=build gcc libffi-dev musl-dev openssl-dev python-dev make && \
    pip install --upgrade pip && \
    pip install azure-cli --no-cache-dir && \
    apk del --purge build && \
    curl -sLO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    install -t /usr/local/bin kubectl && \
    curl -sL https://git.io/get_helm.sh | bash && \
    curl -sL https://download.docker.com/linux/static/stable/x86_64/docker-19.03.2.tgz | tar zx && \
    install -t /usr/local/bin docker/docker && rm -rf docker/ && \
    curl -sL -o terraform.zip https://releases.hashicorp.com/terraform/0.12.9/terraform_0.12.9_linux_amd64.zip && \
    unzip terraform.zip && rm terraform.zip && \
    install -t /usr/local/bin terraform && \
    curl -sL https://github.com/drone/drone-cli/releases/download/v1.1.4/drone_linux_amd64.tar.gz | tar zx && \
    install -t /usr/local/bin drone && \
    curl -sL -o klar https://github.com/optiopay/klar/releases/download/v2.4.0/klar-2.4.0-linux-amd64 && \
    chmod +x klar && mv klar /usr/bin/ && \
    curl -sL -o mc https://dl.min.io/client/mc/release/linux-amd64/mc && \
    install -t /usr/local/bin mc && \
    echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

EXPOSE 4200
VOLUME /home
COPY files/entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["shellinabox"]
