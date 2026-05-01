package types

import (
	"encoding/json"
	"fmt"

	"github.com/cosmos/cosmos-sdk/codec"
)

// NewGenesisState creates a pricefeed genesis state.
func NewGenesisState(params Params, snapshots []PriceSnapshot, latestEpoch uint64) *GenesisState {
	return &GenesisState{
		Params:         params,
		PriceSnapshots: snapshots,
		LatestEpoch:    latestEpoch,
	}
}

// DefaultGenesisState returns default pricefeed genesis state.
func DefaultGenesisState() *GenesisState {
	return NewGenesisState(DefaultParams(), nil, 0)
}

// Validate validates the provided pricefeed genesis state.
func (gs GenesisState) Validate() error {
	if err := gs.Params.ValidateBasic(); err != nil {
		return err
	}
	seen := make(map[uint64]struct{}, len(gs.PriceSnapshots))
	maxEpoch := uint64(0)
	for _, snapshot := range gs.PriceSnapshots {
		if err := snapshot.ValidateBasic(); err != nil {
			return err
		}
		if _, ok := seen[snapshot.Epoch]; ok {
			return fmt.Errorf("duplicate price snapshot epoch %d", snapshot.Epoch)
		}
		seen[snapshot.Epoch] = struct{}{}
		if snapshot.Epoch > maxEpoch {
			maxEpoch = snapshot.Epoch
		}
	}
	if gs.LatestEpoch != 0 {
		if _, ok := seen[gs.LatestEpoch]; !ok {
			return fmt.Errorf("latest_epoch %d has no matching snapshot", gs.LatestEpoch)
		}
		if gs.LatestEpoch != maxEpoch {
			return fmt.Errorf("latest_epoch must be the highest price snapshot epoch")
		}
	}

	return nil
}

// GetGenesisStateFromAppState returns x/pricefeed GenesisState given raw app state.
func GetGenesisStateFromAppState(cdc codec.JSONCodec, appState map[string]json.RawMessage) *GenesisState {
	var genesisState GenesisState
	if appState[ModuleName] != nil {
		cdc.MustUnmarshalJSON(appState[ModuleName], &genesisState)
	}

	return &genesisState
}
