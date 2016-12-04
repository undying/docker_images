#! /bin/bash

source /opt/_tools.sh

export arch=${ARCH:-i386}
export distro=${DISTRO:-debian}
export target=${TARGET:-${arch}}
export release=${RELEASE:-stable}
export build_path=${BUILD_PATH:-/opt/build}
export chroot_path=${CHROOT_PATH:-${build_path}/chroot}
export mirror=${MIRROR:-http://ftp.ru.debian.org/debian/}

### prepare
chroot_clean

### load build module
/opt/modules/${distro}.sh

### complete
image_pack

