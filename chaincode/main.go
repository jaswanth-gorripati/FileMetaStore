/*
SPDX-License-Identifier: Apache-2.0
*/

package main

import (
	"log"
	"chaincode/smartcontract"

	"github.com/hyperledger/fabric-contract-api-go/contractapi"
)

func main() {
	assetChaincode, err := contractapi.NewChaincode(&metarecords.MetaRecords{})
	if err != nil {
		log.Panicf("Error creating asset-transfer-private-data chaincode: %v", err)
	}

	if err := assetChaincode.Start(); err != nil {
		log.Panicf("Error starting asset-transfer-private-data chaincode: %v", err)
	}
}
