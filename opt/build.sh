#! /bin/bash

source opt/_tools.sh

while getopts a:d:r: arg;do
  case ${arg} in
    a)
      arch=${OPTARG}
      ;;
    n)
      distro=${OPTARG}
      ;;
    r)
      release=${OPTARG}
  esac
done

arch=${arch:-i386}
distro=${distro:-debian}
release=${release:-jessie}

build_path=${BUILD_PATH:-/tmp}
hub_ns=undying

image=${distro}-${release}-${arch}
build_image=${image}-build
tags=$(tags_by_release ${release})

docker build --file ${distro}.dockerfile --tag ${build_image} .
docker run \
  --rm \
  --tty \
  --privileged \
  --interactive \
  --volume ${build_path}/${image}:/opt/build \
  --env ARCH=${arch} \
  --env TARGET=${image} \
  --env RELEASE=${release} \
  ${build_image} \
  /opt/debootstrap.sh

docker import ${build_path}/${image}/${image}.tar.gz ${image}
rm -rvf ${build_path}/${image}

for tag in ${tags};do
  image_tag=${distro}-${arch}:${tag}

  docker tag ${image} ${hub_ns}/${image_tag}
  docker push ${hub_ns}/${image_tag}
  docker rmi ${hub_ns}/${image_tag}
done

for i in ${image} ${build_image};do
  docker rmi ${i}
done

# vi:syntax=sh
