package metarecords

import (
	"encoding/json"
	"time"

	"chaincode/smartcontract/errorcode"
	"chaincode/smartcontract/util"

	"github.com/hyperledger/fabric-contract-api-go/contractapi"
	log "github.com/sirupsen/logrus"
)

// SmartContract of this fabric sample
type MetaRecords struct {
	contractapi.Contract
}

type FileStoreModel struct {
	Metadata  string `json:"metadata"`
	TimeStamp string `json:"timestamp"`
}

// StoreFileMetadata : Store the file metadata with hash as the kay
func (m *MetaRecords) StoreFileMetadata(ctx contractapi.TransactionContextInterface, hash, fileMetaData string) error {
	log.Debugf("%s()", util.FunctionName())

	// Query data from ledger to verify this is new hash
	txDataJSONasBytes, err := ctx.GetStub().GetState(hash)
	if err != nil {
		return errorcode.Internal.WithMessage("failed to get data from ledger, %v", err).LogReturn()
	} else if txDataJSONasBytes != nil {
		return errorcode.DuplicateHash.WithMessage("hash '%s' Already registered", hash).LogReturn()
	}

	// fetch tx creation time
	txTimestamp, err := ctx.GetStub().GetTxTimestamp()
	if err != nil {
		return errorcode.Internal.WithMessage("failed to fetch tx creation timestamp, %v", err).LogReturn()
	}

	// convert to RFC339 format
	timestampString := time.Unix(txTimestamp.Seconds, int64(txTimestamp.Nanos)).Format(time.RFC3339)

	// build struct from transaction data
	fileStore := FileStoreModel{fileMetaData, timestampString}

	// Convert struct to Bytes to store in Ledger
	txDataJSONasBytes, err = json.Marshal(fileStore)
	if err != nil {
		return errorcode.Internal.WithMessage("failed to Marshal file metadata , %v", err).LogReturn()
	}

	// Store data to ledger
	err = ctx.GetStub().PutState(hash, txDataJSONasBytes)
	if err != nil {
		return errorcode.Internal.WithMessage("failed to store data, %v", err).LogReturn()
	}

	return nil
}

// GetFileMetadata : Returns the file metadata for a given hash
func (m *MetaRecords) GetFileMetadata(ctx contractapi.TransactionContextInterface, hash string) (*FileStoreModel, error) {
	log.Debugf("%s()", util.FunctionName())

	txDataJSON := new(FileStoreModel)

	// Query data from ledger
	txDataJSONasBytes, err := ctx.GetStub().GetState(hash)
	if err != nil {
		return txDataJSON, errorcode.Internal.WithMessage("Failed to retrieve data from ledger, %s", err.Error()).LogReturn()
	} else if txDataJSONasBytes == nil {
		return txDataJSON, errorcode.NoRecord.WithMessage("Data not Found for Key %s", hash).LogReturn()
	}

	// Convert ledger data to transaction data
	err = json.Unmarshal(txDataJSONasBytes, txDataJSON)
	if err != nil {
		return txDataJSON, errorcode.Internal.WithMessage("Failed to convert ledger data to Transaction data , %s", err.Error()).LogReturn()
	}

	return txDataJSON, nil
}
