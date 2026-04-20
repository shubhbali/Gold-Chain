package testutil

import (
	"crypto/rand"

	"github.com/giltchain/gilt-consensus/x/milestone/types"
)

// CreateMilestone generate new milestone
func CreateMilestone(
	start uint64,
	end uint64,
	hash []byte,
	proposer string,
	giltChainID string,
	milestoneID string,
	timestamp uint64,
) types.Milestone {
	return types.Milestone{
		StartBlock:  start,
		EndBlock:    end,
		Hash:        hash,
		Proposer:    proposer,
		GiltChainId:  giltChainID,
		MilestoneId: milestoneID,
		Timestamp:   timestamp,
	}
}

func RandomBytes() []byte {
	b := make([]byte, 32)
	_, _ = rand.Read(b)
	return b
}
