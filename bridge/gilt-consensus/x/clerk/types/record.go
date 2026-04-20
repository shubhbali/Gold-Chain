package types

import (
	"time"
)

// NewEventRecord creates new record
func NewEventRecord(
	txHash string,
	logIndex uint64,
	id uint64,
	contract string,
	data []byte,
	chainID string,
	recordTime time.Time,
) EventRecord {
	return EventRecord{
		Id:         id,
		Contract:   contract,
		Data:       data,
		TxHash:     txHash,
		LogIndex:   logIndex,
		GiltChainId: chainID,
		RecordTime: recordTime,
	}
}
