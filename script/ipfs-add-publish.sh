#!/bin/sh
set -x

export IPFS_PATH=/data/ipfs

# dev or prod
STAGE=$1

SUBDEV=QmSyKNRRZiwvPcFAckhS9ja8722KVs2KhC86FiynGEY1qE
  

ipfs pubsub sub ${SUBDEV} &
#ipfs key list 
case $STAGE in 
  dev) cd /data/staging/_site || exit 1
       ipfs_hash=$(ipfs add -r -Q . )
       test -z $ipfs_hash \
         && echo "error adding to ipfs" \
	 && exit 3
       #check pubsub peers (wait for at least one) 
       while true ; do
          test -z $(ipfs pubsub peers ${SUBDEV}) || break
	  echo "no peers on ${SUBDEV} yet"
          sleep 3
       done
       ipfs name publish --key=mazaweb-develop $ipfs_hash
       # just do this a couple times for testing 
       for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20; do
          
          ipfs pubsub pub ${SUBDEV} "/ipfs/${ipfs_hash} "
          sleep 60 
       done

       ;;
 prod) cd /data/staging/ || exit 1
       ipfs_hash=$(ipfs add -r -w -Q . )
       test -z $ipfs_hash \
         && echo "error adding to ipfs" \
	 && exit 3
       #pubkey
       ipfs name publish --key=maza-web-prod $ipfs_hash
       ;;
    *) echo "unknown error"  
       exit 2
       ;;
esac


