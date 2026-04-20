package giltconsensusapp

import (
	"context"
	"errors"

	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/consensus/gilt/consensusclient/milestone"

	"github.com/ethereum/go-ethereum/log"

	milestoneTypes "github.com/giltchain/gilt-consensus/x/milestone/types"
)

func (h *GiltConsensusAppClient) FetchMilestoneCount(_ context.Context) (int64, error) {
	log.Debug("Fetching milestone count")

	res, err := h.hApp.MilestoneKeeper.GetMilestoneCount(h.NewContext())
	if err != nil {
		return 0, err
	}

	log.Debug("Fetched Milestone Count", "res", int64(res))

	return int64(res), nil
}

func (h *GiltConsensusAppClient) FetchMilestone(_ context.Context) (*milestone.Milestone, error) {
	log.Debug("Fetching Latest Milestone")

	res, err := h.hApp.MilestoneKeeper.GetLastMilestone(h.NewContext())
	if err != nil {
		return nil, err
	}

	milestone := toGiltMilestone(res)
	log.Debug("Fetched Latest Milestone", "milestone", milestone)

	return milestone, nil
}

func (h *GiltConsensusAppClient) FetchNoAckMilestone(_ context.Context, milestoneID string) error {
	return errors.New("not implemented in giltconsensusv2")
}

func (h *GiltConsensusAppClient) FetchLastNoAckMilestone(_ context.Context) (string, error) {
	return "", errors.New("not implemented in giltconsensusv2")
}

func toGiltMilestone(hdMilestone *milestoneTypes.Milestone) *milestone.Milestone {
	return &milestone.Milestone{
		Proposer:   common.HexToAddress(hdMilestone.Proposer),
		StartBlock: hdMilestone.StartBlock,
		EndBlock:   hdMilestone.EndBlock,
		Hash:       common.BytesToHash(hdMilestone.Hash),
		GiltChainID: hdMilestone.GiltChainId,
		Timestamp:  hdMilestone.Timestamp,
	}
}
