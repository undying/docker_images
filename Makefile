
debian-i386: debian-i386-jessie

debian-i386-jessie:
	opt/build.sh -d debian -r jessie -a i386

.PHONY: debian-i386 debian-i386-jessie
