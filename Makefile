
debian-i386: debian-i386-jessie

debian-i386-jessie:
	opt/build.sh -d debian -r jessie -a i386

busybox-i686: busybox-i686-1.21.1

busybox-i686-1.21.1:
	opt/build.sh -d busybox -r 1.21.1 -a i686

busybox-x86_64: busybox-x86_64-1.21.1

busybox-x86_64-1.21.1:
	opt/build.sh -d busybox -r 1.21.1 -a x86_64

.PHONY: debian-i386 debian-i386-jessie busybox-i686 busybox-i686-1.21.1 busybox-x86_64 busybox-x86_64-1.21.1
