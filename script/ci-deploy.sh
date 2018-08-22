#!/bin/bash

STAGE=$1
CID=$2

case ${STAGE} in 
   dev) docker exec $CID /data/script/ipfs-add-publish.sh dev
        ;;
  prod) docker exec $CID /data/script/ipfs-add-publish.sh prod
        ;;
     *) echo "unknown error"
        exit 1
        ;;
esac


