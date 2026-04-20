package giltconsensusapp

import (
	"context"

	giltTypes "github.com/giltchain/gilt-consensus/x/gilt/types"

	"github.com/ethereum/go-ethereum/log"
)

func (h *GiltConsensusAppClient) GetSpan(_ context.Context, _ uint64) (*giltTypes.Span, error) {
	log.Warn("GetSpan not implemented!")
	return nil, nil
}
