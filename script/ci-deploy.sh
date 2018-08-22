#!/bin/bash

STAGE=$1
CID=$2

case ${STAGE} in 
   dev) docker exec $CID ls -la /data/ipfs
        docker exec $CID ls -la /data/
        ;;
  prod) docker exec $CID whoami 
        ;;
     *) echo "unknown error"
        exit 1
        ;;
esac


