package testutil

import (
	"time"

	"github.com/ethereum/go-ethereum/common"

	"github.com/giltchain/gilt-consensus/x/checkpoint/types"
)

// GenRandCheckpoint returns a random checkpoint header
func GenRandCheckpoint(start, headerSize, id uint64) (headerBlock types.Checkpoint) {
	end := start + headerSize
	giltChainID := "1234"
	rootHash := RandomBytes()
	proposer := common.Address{}.String()

	headerBlock = types.CreateCheckpoint(
		id,
		start,
		end,
		rootHash,
		proposer,
		giltChainID,
		uint64(time.Now().UTC().Unix()))

	return headerBlock
}
