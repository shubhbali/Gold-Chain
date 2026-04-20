package giltconsensusapp

import (
	"context"

	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/consensus/gilt/consensusclient/checkpoint"
	"github.com/ethereum/go-ethereum/log"

	hmTypes "github.com/giltchain/gilt-consensus/x/checkpoint/types"
)

func (h *GiltConsensusAppClient) FetchCheckpointCount(_ context.Context) (int64, error) {
	log.Info("Fetching checkpoint count")

	res, err := h.hApp.CheckpointKeeper.GetAckCount(h.NewContext())
	if err != nil {
		return 0, err
	}

	log.Info("Fetched checkpoint count")

	return int64(res), nil
}

func (h *GiltConsensusAppClient) FetchCheckpoint(_ context.Context, number int64) (*checkpoint.Checkpoint, error) {
	log.Info("Fetching checkpoint", "number", number)

	res, err := h.hApp.CheckpointKeeper.GetCheckpointByNumber(h.NewContext(), uint64(number))
	if err != nil {
		return nil, err
	}

	log.Info("Fetched checkpoint", "number", number)

	return toGiltCheckpoint(res), nil
}

func toGiltCheckpoint(hdCheckpoint hmTypes.Checkpoint) *checkpoint.Checkpoint {
	return &checkpoint.Checkpoint{
		Proposer:   common.HexToAddress(hdCheckpoint.Proposer),
		StartBlock: hdCheckpoint.StartBlock,
		EndBlock:   hdCheckpoint.EndBlock,
		RootHash:   common.BytesToHash(hdCheckpoint.RootHash),
		GiltChainID: hdCheckpoint.GiltChainId,
		Timestamp:  hdCheckpoint.Timestamp,
	}
}
