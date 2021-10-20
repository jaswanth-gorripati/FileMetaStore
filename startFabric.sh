#!/bin/bash
#
# Exit on first error
set -e

# don't rewrite paths for Windows Git Bash users
export MSYS_NO_PATHCONV=1
starttime=$(date +%s)
CC_SRC_LANGUAGE="go"

CC_SRC_PATH="../chaincode/"



# launch network; create channel and join peer to channel
pushd ./hlf-network
./network.sh down
./network.sh up createChannel -ca -c filesmetastore -i 2.2.2
./network.sh deployCC -c filesmetastore -ccn metarecords -ccv 1 -ccl ${CC_SRC_LANGUAGE} -ccp ${CC_SRC_PATH}
popd