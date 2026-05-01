package pricefeed

import (
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/giltchain/gilt-consensus/x/pricefeed/keeper"
	"github.com/giltchain/gilt-consensus/x/pricefeed/types"
)

// InitGenesis initializes pricefeed genesis state.
func InitGenesis(ctx sdk.Context, keeper keeper.Keeper, genesisState types.GenesisState) {
	keeper.InitGenesis(ctx, &genesisState)
}

// ExportGenesis exports pricefeed genesis state.
func ExportGenesis(ctx sdk.Context, keeper keeper.Keeper) *types.GenesisState {
	return keeper.ExportGenesis(ctx)
}
