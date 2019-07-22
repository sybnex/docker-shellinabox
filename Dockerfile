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
    apk --no-cache add shadow tmux util-linux coreutils grep bash tree bash-completion openssl curl openssh-client sudo shellinabox git py-pip docker && \
    apk add --virtual=build gcc libffi-dev musl-dev openssl-dev python-dev make && \
    pip install --upgrade pip && \
    pip install azure-cli --no-cache-dir && \
    apk del --purge build && \
    curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x kubectl && mv kubectl /usr/bin/ && \
    curl -L https://git.io/get_helm.sh | bash && \
    curl -L -o terraform.zip https://releases.hashicorp.com/terraform/0.12.4/terraform_0.12.4_linux_amd64.zip && \
    unzip terraform.zip && rm terraform.zip && \
    chmod +x terraform && mv terraform /usr/bin/ && \
    curl -L https://github.com/drone/drone-cli/releases/download/v1.1.2/drone_linux_amd64.tar.gz | tar zx && \
    install -t /usr/local/bin drone && \
    mkdir /var/lib/docker && chown $SIAB_USERID:$SIAB_GROUPID /var/lib/docker && \
    echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

EXPOSE 4200
VOLUME /home
ADD files/entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["shellinabox"]
