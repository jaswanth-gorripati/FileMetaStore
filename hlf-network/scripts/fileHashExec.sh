#!/bin/bash

source scripts/utils.sh
FABRIC_CFG_PATH=$PWD/../config/

. scripts/envVar.sh

CHANNEL_NAME="filesmetastore"
CC_NAME="metarecords"

successInvokeTx() {
  setGlobals 1
  parsePeerConnectionParameters 1 2
  res=$?
  verifyResult $res "Invoke transaction failed on channel '$CHANNEL_NAME' due to uneven number of peer and org parameters "
  #set -x
  
  fcn_call='{"function":"StoreFileMetadata","Args":["69dde88229fdcb24c05a10e2be2c1e54fb6ed9b36dab733de997d36c63576c3f","{\"DPIHeight\":72,\"Depth\":8,\"ColorModel\":\"RGB\",\"DPIWidth\":72,\"PixelHeight\":800,\"PixelWidth\":532,\"JFIF\":{\"DensityUnit\":1,\"YDensity\":2,\"JFIFVersion\":[1,1],\"XDensity\":72},ProfileName\":\"sRGBIEC61966-2.1\"}"]}'

  echo -e ""
  echo -e "Scenario 1 : ${C_YELLOW}Valid Invoke Transactions${C_RESET}"
  echo ""
  echo -e "         ${C_BLUE}Function${C_RESET} : 'StoreFileMetadata'"
  echo ""
  echo -e '         args     : ["69dde88229fdcb24c05a10e2be2c1e54fb6ed9b36dab733de997d36c63576c3f","{\"DPIHeight\":72,\"Depth\":8,\"ColorModel\":\"RGB\",\"DPIWidth\":72,\"PixelHeight\":800,\"PixelWidth\":532,\"JFIF\":{\"DensityUnit\":1,\"YDensity\":2,\"JFIFVersion\":[1,1],\"XDensity\":72},ProfileName\":\"sRGBIEC61966-2.1\"}"]'
  echo ""
  echo -e "         ${C_BLUE}Command${C_RESET} : "
set -x
  peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n ${CC_NAME} $PEER_CONN_PARMS -c ${fcn_call} >&log.txt
  { set +x; } 2>/dev/null
    echo ""
    echo ""
  echo -e "         ${C_BLUE}Output${C_RESET}   : ${C_GREEN}$(cat log.txt)${C_RESET}"

}

DuplicateInvokeTx() {
#   setGlobals 1
#   parsePeerConnectionParameters 1 2
  #set -x
  fcn_call='{"function":"StoreFileMetadata","Args":["69dde88229fdcb24c05a10e2be2c1e54fb6ed9b36dab733de997d36c63576c3f","{\"DPIHeight\":72,\"Depth\":8,\"ColorModel\":\"RGB\",\"DPIWidth\":72,\"PixelHeight\":800,\"PixelWidth\":532,\"JFIF\":{\"DensityUnit\":1,\"YDensity\":2,\"JFIFVersion\":[1,1],\"XDensity\":72},ProfileName\":\"sRGBIEC61966-2.1\"}"]}'
  echo -e ""
  echo -e "Scenario 3 : ${C_YELLOW}Duplicate invoke Transactions -- should result in error${C_RESET}"
  echo ""
  echo -e "         ${C_BLUE}Function${C_RESET} : 'StoreFileMetadata'"
  echo ""
  echo -e '         args     : ["69dde88229fdcb24c05a10e2be2c1e54fb6ed9b36dab733de997d36c63576c3f","{\"DPIHeight\":72,\"Depth\":8,\"ColorModel\":\"RGB\",\"DPIWidth\":72,\"PixelHeight\":800,\"PixelWidth\":532,\"JFIF\":{\"DensityUnit\":1,\"YDensity\":2,\"JFIFVersion\":[1,1],\"XDensity\":72},ProfileName\":\"sRGBIEC61966-2.1\"}"]'
  echo ""
  echo -e "         ${C_BLUE}Command${C_RESET} : "
  set -x
  peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile $ORDERER_CA -C $CHANNEL_NAME -n ${CC_NAME} $PEER_CONN_PARMS -c ${fcn_call} >&log.txt
  { set +x; } 2>/dev/null
  echo ""
  echo ""
  echo -e "         ${C_BLUE}Output${C_RESET}   : ${C_GREEN}$(cat log.txt)${C_RESET}"

}

successChaincodeQuery() {
  echo -e ""
  echo -e "Scenario 2 : ${C_YELLOW}Query to get File Metadata Transactions${C_RESET}"
  echo ""
  echo -e "         ${C_BLUE}Function${C_RESET} : 'GetFileMetadata'"
  echo ""
  echo -e "         ${C_BLUE}args${C_RESET}     : ['69dde88229fdcb24c05a10e2be2c1e54fb6ed9b36dab733de997d36c63576c3f']"
  echo ""
  echo -e "         ${C_BLUE}Command${C_RESET} : "
  set -x
    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"Args":["GetFileMetadata","69dde88229fdcb24c05a10e2be2c1e54fb6ed9b36dab733de997d36c63576c3f"]}' >&log.txt
   { set +x; } 2>/dev/null
  echo ""
  echo ""
  echo -e "         ${C_BLUE}Output${C_RESET}   : ${C_GREEN}$(cat log.txt)${C_RESET}"
 
}

failedChaincodeQuery() {
  echo -e ""
  echo -e "Scenario 4 : ${C_YELLOW}Invalid Hash Query -- should result in error${C_RESET}"
  echo ""
  echo -e "         ${C_BLUE}Function${C_RESET} : 'GetFileMetadata'"
  echo ""
  echo -e "         ${C_BLUE}args${C_RESET}     : ['74cde88229fdcb24c05a10e2be2c1e54fb6ed9b36dab733de997d36c63576c3f']"
  echo ""
  echo -e "         ${C_BLUE}Command${C_RESET} : "
  set -x
    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"Args":["GetFileMetadata","74cde88229fdcb24c05a10e2be2c1e54fb6ed9b36dab733de997d36c63576c3f"]}' >&log.txt
   { set +x; } 2>/dev/null
  echo ""
  echo ""
  echo -e "         ${C_BLUE}Output${C_RESET}   : ${C_GREEN}$(cat log.txt)${C_RESET}"
 
}

echo "-------------------------------------------------------------"
echo "--------------- Blockchain Transactions ---------------------"
echo "-------------------------------------------------------------"

successInvokeTx

# echo "-------------------------------------------------------------"
# echo "-------------------------------------------------------------"
echo ""
echo ""
echo "------------------------------------------------------------------------------"
sleep 2
successChaincodeQuery
echo ""
echo ""
echo "------------------------------------------------------------------------------"
sleep 2
DuplicateInvokeTx
echo ""
echo ""
echo "------------------------------------------------------------------------------"
sleep 2 
failedChaincodeQuery
echo ""
echo ""
echo "------------------------------ END --------------------------------------------"

# echo "-------------------------------------------------------------"
# echo "----- Successfull Chaincode Query to get Has Metadata -------"
# echo "-------------------------------------------------------------"

# successChaincodeQuery

# echo "-------------------------------------------------------------"
# echo "-------------------------------------------------------------"
# echo ""
# echo ""
# sleep 1

# echo "-------------------------------------------------------------"
# echo "--------- Duplicate Hash Transaction invokation -------------"
# echo "-------------------------------------------------------------"

# DuplicateInvokeTx

# echo "-------------------------------------------------------------"
# echo "-------------------------------------------------------------"

# sleep 2

# echo "-------------------------------------------------------------"
# echo "--------- Failed Chaincode Query  ----------------"
# echo "-------------------------------------------------------------"
# failedChaincodeQuery

# echo "-------------------------------------------------------------"
# echo "-------------------  END ------------------------------------"
