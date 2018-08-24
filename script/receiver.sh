#!/bin/bash -x

SUBDEV=QmRssaMi1LmkfZGnSJXR3EsVNTq6ZSmSTg2rWktFUMtoA1
#SUBPROD
export IPFS_PATH=/Users/guruvan/ipfs/a_new_hash
test -d ${IPFS_PATH} || exit 1
test -d ~/.mazaipfs || mkdir ~/.mazaipfs
test -f ~/.mazaipfs/receiver-${SUBDEV}.out && rm ~/.mazaipfs/receiver-${SUBDEV}.out 
ipfs pubsub sub ${SUBDEV} > ~/.mazaipfs/receiver-${SUBDEV}.out  &
while true ; do
# wait till the IPNS link resolves the first time
while true ; do 
 current_hash=$(ipfs name resolve ${SUBDEV})
 test -z ${current_hash} || break
 sleep 10
done
echo "ipns name resolution successful - hash: ${current_hash}"
#echo "${SUBDEV} ${current_hash}" > ~/.mazaipfs/receiver-${SUBDEV}.out 


while true ; do 
  sleep 10
  build_hash=$(awk '{print $NF}' ~/.mazaipfs/receiver-${SUBDEV}.out) 
  test -z ${build_hash} || break
done
  cp  ~/.mazaipfs/receiver-${SUBDEV}.out ~/.mazaipfs/debug.out
  > ~/.mazaipfs/receiver-${SUBDEV}.out
  echo "website update announcement received with hash: ${build_hash}"
  echo "- checking ipns resolution"
  if [ "X${current_hash}" != "X${build_hash}" ] ;then
     echo "new pubsub build announcement received"
     echo "checking ipns link and announcement match"
     while true ; do 
        sleep 10
        new_hash=$(ipfs name resolve ${SUBDEV})
         test -z ${new_hash} || break
     done
     echo "ipns resolution complete - new hash is: ${new_hash}" 
     if [ "X${new_hash}" == "X${build_hash}" ] ; then 
       echo "new hash ${new_hash} and build hash ${build_hash} match"
       current_hash=${new_hash}
       echo "pinning the new hash ${current_hash}"
       # change this to update 
       ipfs pin add --progress -r ${build_hash} 
     else 
       echo "new hash ${new_hash} and ${build_hash} don't match" 
       # for now we'll pin it even if it didn't match, ipns resolution may be slow to propagate
       ipfs pin add --progress -r ${build_hash} 
       sleep 60
     fi 
  fi

done

  



