#! /bin/bash -e

opkg_version=0.2.4
cpu_count=$(grep -c processor /proc/cpuinfo)

case ${arch} in
  x86_64)
    opkg_arch=${arch}
    opkg_mirrors="
src/gz packages http://downloads.openwrt.org/snapshots/trunk/x86/64/packages/packages
src/gz base http://downloads.openwrt.org/snapshots/trunk/x86/64/packages/base"
    opkg_libc_url="http://downloads.openwrt.org/snapshots/trunk/x86/64/packages/base/libc_1.1.15-1_x86_64.ipk"
    ;;
  *)
    opkg_arch=x86
    opkg_mirrors="
src/gz packages http://downloads.openwrt.org/snapshots/trunk/x86/generic/packages/packages
src/gz base http://downloads.openwrt.org/snapshots/trunk/x86/generic/packages/base
    "
    opkg_libc_url="http://downloads.openwrt.org/snapshots/trunk/x86/generic/packages/base/libc_1.1.15-1_x86.ipk"
esac


mkdir -pv ${chroot_path}/{bin,dev,etc,lib,proc,sbin,sys,usr,tmp}
mkdir -pv ${chroot_path}/etc/{init.d,opkg}
mkdir -pv ${chroot_path}/usr/{bin,sbin,lib,opkg} ${chroot_path}/usr/lib/opkg
mkdir -pv ${chroot_path}/var/log


wget -O ${chroot_path}/sbin/busybox \
  https://www.busybox.net/downloads/binaries/${release}/busybox-${arch}

chmod +x ${chroot_path}/sbin/busybox
chroot ${chroot_path} /sbin/busybox --install
rm -v ${chroot_path}/linuxrc


wget -O /tmp/opkg-${opkg_version}.tar.gz \
  https://git.yoctoproject.org/cgit/cgit.cgi/opkg/snapshot/opkg-${opkg_version}.tar.gz

for f in etc/rc.common lib/functions.sh lib/functions/system.sh lib/functions/service.sh;do
  out=${chroot_path}/${f}
  mkdir -pv $(dirname ${out})

  wget -O ${out} \
    "https://dev.openwrt.org/browser/trunk/package/base-files/files/${f}?format=txt"
done


tar -xzf /tmp/opkg-${opkg_version}.tar.gz -C /tmp
cd /tmp/opkg-${opkg_version}

./autogen.sh
CFLAGS="--static" LDFLAGS="--static" \
  ./configure \
  --disable-gpg \
  --disable-curl \
  --enable-static \
  --disable-shared \
  --host=${arch}-linux \
  --prefix ${chroot_path}

make -j ${cpu_count}
make install

cd ${chroot_path}/bin
ln -s opkg-cl opkg


echo -e "${opkg_mirrors}\n" > ${chroot_path}/etc/opkg/opkg.conf
cat - >> ${chroot_path}/etc/opkg/opkg.conf <<EOF
lists_dir packages /usr/lib/opkg/lists
lists_dir base /usr/lib/opkg/lists
EOF

cat - > ${chroot_path}/etc/opkg/arch.conf <<EOF
arch all 1
arch noarch 1
arch ${opkg_arch} 2
EOF


cp -v /etc/resolv.conf ${chroot_path}/etc/
chroot ${chroot_path} opkg update
chroot ${chroot_path} opkg install ${opkg_libc_url}


for f in ${chroot_path}/etc/resolv.conf ${chroot_path}/usr/lib/opkg/lists/*;do
  rm -v ${f}
done

