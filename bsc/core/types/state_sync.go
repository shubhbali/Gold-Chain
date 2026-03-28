package types

import "github.com/ethereum/go-ethereum/common"

const (
	StateSyncTxType = 0x7f
)

// StateSyncData represents state received from the root chain.
type StateSyncData struct {
	ID       uint64
	Contract common.Address
	Data     []byte
	TxHash   common.Hash
}
