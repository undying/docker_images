
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
    libcurl4-openssl-dev \
    build-essential

RUN apt-get install -y libgpgme11-dev

COPY opt/ /opt/

# vi:syntax=dockerfile
