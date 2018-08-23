#!/bin/bash

STAGE=$1

case ${STAGE} in 
   dev) docker exec ipfs /data/script/ipfs-add-publish.sh dev
        ;;
  prod) docker exec ipfs /data/script/ipfs-add-publish.sh prod
        ;;
     *) echo "unknown error"
        exit 1
        ;;
esac


