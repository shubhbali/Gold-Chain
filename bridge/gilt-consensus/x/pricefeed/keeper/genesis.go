package keeper

import (
	"context"

	"github.com/giltchain/gilt-consensus/x/pricefeed/types"
)

// InitGenesis initializes pricefeed state.
func (k Keeper) InitGenesis(ctx context.Context, genesis *types.GenesisState) {
	if genesis == nil {
		genesis = types.DefaultGenesisState()
	}
	if err := k.SetParams(ctx, genesis.Params); err != nil {
		panic(err)
	}
	for _, snapshot := range genesis.PriceSnapshots {
		if err := k.snapshots.Set(ctx, snapshot.Epoch, snapshot); err != nil {
			panic(err)
		}
	}
	if genesis.LatestEpoch != 0 {
		if err := k.latestEpoch.Set(ctx, genesis.LatestEpoch); err != nil {
			panic(err)
		}
	}
}

// ExportGenesis exports pricefeed state.
func (k Keeper) ExportGenesis(ctx context.Context) *types.GenesisState {
	params, err := k.GetParams(ctx)
	if err != nil {
		panic(err)
	}
	var snapshots []types.PriceSnapshot
	if err := k.IteratePriceSnapshots(ctx, func(snapshot types.PriceSnapshot) error {
		snapshots = append(snapshots, snapshot)
		return nil
	}); err != nil {
		panic(err)
	}
	latestEpoch, err := k.latestEpoch.Get(ctx)
	if err != nil {
		latestEpoch = 0
	}
	return types.NewGenesisState(params, snapshots, latestEpoch)
}
