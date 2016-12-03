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
tags=$(tags_by_release ${release})

docker build --file ${distro}.dockerfile --tag ${image}-build .
docker run \
  --rm \
  --tty \
  --privileged \
  --interactive \
  --volume ${build_path}/${image}:/opt/build \
  --env ARCH=${arch} \
  --env TARGET=${image} \
  --env RELEASE=${release} \
  ${image} \
  /opt/debootstrap.sh

docker import ${build_path}/${image}/${image}.tar.gz ${image}

for tag in ${tags};do
  image_tag=${distro}-${arch}:${tag}

  docker tag ${image} ${hub_ns}/${image_tag}
  docker push ${hub_ns}/${image_tag}
  docker rmi ${hub_ns}/${image_tag}
done

for i in ${image} ${image}-build;do
  docker rmi ${i}
done

# vi:syntax=sh
