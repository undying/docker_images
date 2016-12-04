#! /bin/bash

opkg_version=0.3.3
cpu_count=$(grep -c processor /proc/cpuinfo)

mkdir -p ${chroot_path}
for d in bin dev proc sbin sys usr usr/bin usr/sbin tmp;do
  install -d ${chroot_path}/${d}
done

wget -O ${chroot_path}/sbin/busybox \
  https://www.busybox.net/downloads/binaries/${release}/busybox-${arch}

chmod +x ${chroot_path}/sbin/busybox
chroot ${chroot_path} /sbin/busybox --install
rm -v ${chroot_path}/linuxrc

wget -O /tmp/opkg-${opkg_version}.tar.gz \
  https://git.yoctoproject.org/cgit/cgit.cgi/opkg/snapshot/opkg-${opkg_version}.tar.gz

tar -xzf /tmp/opkg-${opkg_version}.tar.gz -C /tmp
cd /tmp/opkg-${opkg_version}

./autogen.sh
CFLAGS='--static' LDFLAGS='--static' \
  ./configure \
  --disable-shared \
  --prefix ${chroot_path} \
  --target=${arch}-linux

make -j ${cpu_count}
make install

