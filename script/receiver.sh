#!/bin/bash -x

SUBDEV=QmRssaMi1LmkfZGnSJXR3EsVNTq6ZSmSTg2rWktFUMtoA1
#SUBPROD
export IPFS_PATH=/Users/guruvan/ipfs/a_new_hash
test -d ${IPFS_PATH} || exit 1
test -d ~/.mazaipfs || mkdir ~/.mazaipfs
test -f ~/.mazaipfs/receiver-${SUBDEV}.out && rm ~/.mazaipfs/receiver-${SUBDEV}.out 
# wait till the IPNS link resolves the first time
while true ; do 
 current_hash=$(ipfs name resolve ${SUBDEV})
 test -z ${current_hash} || break
 sleep 10
done

echo "${SUBDEV} ${current_hash}" > ~/.mazaipfs/receiver-${SUBDEV}.out 

ipfs pubsub sub ${SUBDEV} > ~/.mazaipfs/receiver-${SUBDEV}.out &

while true ; do 
  sleep 10
  build_hash=$(tail -n 1 ~/.mazaipfs/receiver-${SUBDEV}.out | awk '{print $2}')
  if [ "X${current_hash}" != "X${build_hash}" ] ;then
     echo "checking new hash"
     new_hash=$(ipfs name resolve ${SUBDEV})
       echo "new hash ${new_hash}"
     if [ "X${new_hash}" = "X${build_hash}" ] ; then 
       echo "new hash ${new_hash} and build hash ${build_hash} match"
       current_hash=${new_hash}
       ipfs pin -r ${build_hash} 
     else 
       echo "new hash ${new_hash} and ${build_hash} don't match" 
     fi 
     echo "website updated"
  fi

done

  



