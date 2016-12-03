#! /bin/bash

function tags_by_release(){
  release=${1}

  case ${release} in
    jessie)
      echo ${release} 8 latest
      ;;
    *)
      return 1
  esac

  return 0
}

