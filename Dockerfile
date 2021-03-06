FROM alpine:edge

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

ARG AZURECLI_VERSION=2.0.80
ARG TERRAFORM_VERSION=0.12.20

RUN apk --no-cache add python3 py3-pynacl py3-cryptography py3-bcrypt py3-psutil && \
    pip3 install --upgrade pip && \
    pip3 install azure-cli==$AZURECLI_VERSION --no-cache-dir

RUN chmod 755 /etc && \
    echo 'http://dl-cdn.alpinelinux.org/alpine/edge/community' >> /etc/apk/repositories && \
    echo 'http://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories && \
    if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi && \
    apk --no-cache add shadow tmux util-linux coreutils grep bash tree bash-completion openssl curl openssh-client sudo shellinabox gettext vim \
                       certbot git docker-cli drone-cli minio-client && \
    # kubernetes
    echo kube && curl -#LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    install -t /usr/local/bin kubectl && rm kubectl && \
    # terraform
    curl -#L -o terraform.zip https://releases.hashicorp.com/terraform/$TERRAFORM_VERSION/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform.zip && rm terraform.zip && \
    install -t /usr/local/bin terraform && rm terraform && \
    # helm
    echo helm && curl -#L https://git.io/get_helm.sh | bash && \
    echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

EXPOSE 4200
VOLUME /home
COPY files/entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["shellinabox"]
