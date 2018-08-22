#!/bin/bash
CID=$2
docker exec $CID ls -la /data/ipfs
docker exec $CID whoami 
