#! /bin/bash

debootstrap \
  --variant=minbase \
  --arch=${arch} \
  ${release} ${chroot_path} ${mirror}

cp -v /etc/resolv.conf ${chroot_path}/etc/
cat > ${chroot_path}/etc/apt/sources.list <<EOF
deb ${mirror} ${release} main
deb ${mirror} ${release}-updates main
deb http://security.debian.org ${release}/updates main
EOF

mount -t proc proc ${chroot_path}/proc

export DEBIAN_FRONTEND=noninteractive
chroot ${chroot_path} apt-get update
chroot ${chroot_path} apt-get -y upgrade

chroot ${chroot_path} apt-get autoclean
chroot ${chroot_path} apt-get clean
chroot ${chroot_path} apt-get autoremove

umount -l ${chroot_path}/proc
for i in /etc/resolv.conf /var/lib/apt/lists/* /var/cache/apt/* /usr/share/man/* /usr/share/doc/*;do
  rm -rvf ${chroot_path}${i}
done

