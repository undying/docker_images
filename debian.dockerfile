
FROM undying/debian-i386:8
ENV ARCH=i386 MIRROR=http://ftp.ru.debian.org/debian/ CHROOT_PATH=/opt/build/chroot RELEASE=stable

RUN export DEBIAN_FRONTEND=noninteractive \
  && apt-get update \
  && apt-get upgrade -y \
  && apt-get install -y \
    debootstrap

COPY opt/ /opt/

# vi:syntax=dockerfile
