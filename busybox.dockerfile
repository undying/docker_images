
FROM undying/debian-i386:8
ENV ARCH=i686 CHROOT_PATH=/opt/build/chroot RELEASE=stable

RUN export DEBIAN_FRONTEND=noninteractive \
  && apt-get update \
  && apt-get upgrade -y \
  && apt-get install -y \
    wget

COPY opt/ /opt/

# vi:syntax=dockerfile
