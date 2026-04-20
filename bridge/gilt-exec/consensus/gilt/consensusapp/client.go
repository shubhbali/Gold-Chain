package giltconsensusapp

import (
	"github.com/cosmos/cosmos-sdk/types"

	"github.com/ethereum/go-ethereum/log"

	"github.com/giltchain/gilt-consensus/app"
)

const (
	stateFetchLimit = 50
)

type GiltConsensusAppClient struct {
	hApp *app.GiltConsensusApp
}

func NewGiltConsensusAppClient() *GiltConsensusAppClient {
	return &GiltConsensusAppClient{
		// TODO HV2: Implement according to the new setup
		// hApp: service.GetGiltConsensusApp(),
	}
}

func (h *GiltConsensusAppClient) Close() {
	// Nothing to close as of now
	log.Warn("Shutdown detected, Closing GiltConsensus App conn")
}

func (h *GiltConsensusAppClient) NewContext() types.Context {
	return h.hApp.NewContext(true)
}
