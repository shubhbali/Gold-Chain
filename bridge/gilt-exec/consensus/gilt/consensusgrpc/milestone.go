package giltconsensusgrpc

import (
	"context"
	"time"

	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/consensus/gilt/consensusclient"
	"github.com/ethereum/go-ethereum/consensus/gilt/consensusclient/milestone"
	"github.com/ethereum/go-ethereum/log"
)

func (h *GiltConsensusGRPCClient) FetchMilestoneCount(ctx context.Context) (int64, error) {
	log.Info("Fetching milestone count")

	var err error

	// Start the timer and set the request type on the context.
	start := time.Now()
	ctx = giltconsensus.WithRequestType(ctx, giltconsensus.MilestoneCountRequest)

	// Defer the metrics call.
	defer func() {
		giltconsensus.SendMetrics(ctx, start, err == nil)
	}()

	res, err := h.milestoneQueryClient.GetMilestoneCount(ctx, nil)
	if err != nil {
		return 0, err
	}

	count := int64(res.GetCount())

	log.Info("Fetched milestone count", "count", count)

	return count, nil
}

func (h *GiltConsensusGRPCClient) FetchMilestone(ctx context.Context) (*milestone.Milestone, error) {
	log.Debug("Fetching milestone")

	var err error

	// Start the timer and set the request type on the context.
	start := time.Now()
	ctx = giltconsensus.WithRequestType(ctx, giltconsensus.StateSyncRequest)

	// Defer the metrics call.
	defer func() {
		giltconsensus.SendMetrics(ctx, start, err == nil)
	}()

	res, err := h.milestoneQueryClient.GetLatestMilestone(ctx, nil)
	if err != nil {
		return nil, err
	}

	fetchedMilestone := res.GetMilestone()

	milestone := &milestone.Milestone{
		Proposer:        common.HexToAddress(fetchedMilestone.Proposer),
		StartBlock:      fetchedMilestone.StartBlock,
		EndBlock:        fetchedMilestone.EndBlock,
		Hash:            common.BytesToHash(fetchedMilestone.Hash),
		GiltChainID:      fetchedMilestone.GiltChainId,
		MilestoneID:     fetchedMilestone.MilestoneId,
		Timestamp:       fetchedMilestone.Timestamp,
		TotalDifficulty: fetchedMilestone.TotalDifficulty,
	}

	log.Debug("Fetched milestone")

	return milestone, nil
}
