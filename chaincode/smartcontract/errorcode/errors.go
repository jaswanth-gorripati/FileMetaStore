package errorcode

import (
	"encoding/json"
	"errors"
	"fmt"

	log "github.com/sirupsen/logrus"
)

var (
	// Internal : something inside hyperledger is broken
	Internal = ErrorCode{"ERROR_INTERNAL", ""}
	// Internal : something inside hyperledger is broken
	DuplicateHash = ErrorCode{"DUPLICATE_KEY_ERROR", ""}
	NoRecord      = ErrorCode{"NO_RECORD_FOR_KEY", ""}
	// JsonEncode: something wrong when parsing json to struct
	BadStruct = ErrorCode{"ERROR_BAD_JSON_BYTES", ""}
	// BadJSON : something went wrong when parsing a json string
	BadJSON = ErrorCode{"ERROR_BAD_JSON_STRING", ""}
)

// ErrorCode is our custom error
type ErrorCode struct {
	code    string
	message string
}

// WithMessage adds a custom message to the error:
func (e ErrorCode) WithMessage(format string, vars ...interface{}) ErrorCode {
	e.message = fmt.Sprintf(format, vars...)
	return e
}

// LogReturn logs and returns a custom error
func (e ErrorCode) LogReturn() error {
	err := errors.New(e.Error())
	log.Error(err)
	return err
}

func jsonEscape(i string) (string, error) {
	b, err := json.Marshal(i)
	if err != nil {
		return "", err
	}
	// Trim the beginning and trailing " character
	return string(b[1 : len(b)-1]), nil
}

func (e *ErrorCode) Error() string {
	msg, err := jsonEscape(e.message)

	if err != nil {
		log.Errorf("failed to escape to json, %v", err)
		msg = "ERROR: could not escape json, see chaincode log for details!"
	}

	return fmt.Sprintf(`{ "code": "%s", "message": "%s" }`, e.code, msg)
}
