#! /bin/bash

function tags_by_distro_release(){
  local distro=${1}
  local release=${2}

  case ${distro} in
    debian)
      debian_tags_by_release ${release}
      ;;
    busybox)
      busybox_tags_by_release ${release}
      ;;
    *)
      return 1
  esac

  return 0
}

function debian_tags_by_release(){
  local release=${1}

  case ${release} in
    jessie)
      echo ${release} 8 latest
      ;;
    *)
      echo ${release}
  esac

  return 0
}

function busybox_tags_by_release(){
  local release=${1}

  case ${release} in
    1.21.1)
      echo ${release} latest
      ;;
    *)
      echo ${release}
  esac

  return 0
}


function chroot_clean(){
  echo "cleaning chroot directory"
  rm -rf ${chroot_path}/*
}

function image_pack(){
  echo "compressing built image"
  tar -czf ${build_path}/${target}.tar.gz -C ${chroot_path} .
}

