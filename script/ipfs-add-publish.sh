#!/bin/sh
set -x

export IPFS_PATH=/data/ipfs

# dev or prod
STAGE=$1

  

ipfs key list 
case $STAGE in 
  dev) cd /data/staging/ || exit 1
       ipfs_hash=$(ipfs add -r -w -Q . )
       test -z $ipfs_hash \
         && echo "error adding to ipfs" \
	 && exit 3
       # pubkey QmRssaMi1LmkfZGnSJXR3EsVNTq6ZSmSTg2rWktFUMtoA1
       #check pubsub peers (wait for at least one) 
       while true ; do
          test -z $(ipfs pubsub peers QmRssaMi1LmkfZGnSJXR3EsVNTq6ZSmSTg2rWktFUMtoA1) || break
	  echo "no peers on QmRssaMi1LmkfZGnSJXR3EsVNTq6ZSmSTg2rWktFUMtoA1 yet"
          sleep 10
       done
       ipfs name publish --key=maza-web-dev $ipfs_hash
       # just do this a couple times for testing 
       for i in 1 2 3 4 5 6 7 8 9 10 ; do
          
          ipfs pubsub pub QmRssaMi1LmkfZGnSJXR3EsVNTq6ZSmSTg2rWktFUMtoA1 "QmRssaMi1LmkfZGnSJXR3EsVNTq6ZSmSTg2rWktFUMtoA1 /ipfs/${ipfs_hash} mazaweb-dev \n"
          sleep 60 
       done

       ;;
 prod) cd /data/staging/ || exit 1
       ipfs_hash=$(ipfs add -r -w -Q . )
       test -z $ipfs_hash \
         && echo "error adding to ipfs" \
	 && exit 3
       #pubkey QmWKckRDKEPYPMg9iWNUoZcbAfd7CGJEcVAd6kDrzamh3m
       ipfs name publish --key=maza-web-prod $ipfs_hash
       ;;
    *) echo "unknown error"  
       exit 2
       ;;
esac


