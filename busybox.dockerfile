
FROM undying/debian-i386:8
ENV ARCH=i686 CHROOT_PATH=/opt/build/chroot RELEASE=stable

RUN export DEBIAN_FRONTEND=noninteractive \
  && apt-get update \
  && apt-get upgrade -y \
  && apt-get install -y \
    wget \
    autoconf \
    automake \
    pkg-config \
    libssl-dev \
    libtool-bin \
    libarchive-dev \
    libgpgme11-dev \
    libglib2.0-dev \
    libcurl4-openssl-dev \
    build-essential

COPY opt/ /opt/

# vi:syntax=dockerfile
