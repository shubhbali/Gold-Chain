package types_test

import (
	"testing"

	sdkmath "cosmossdk.io/math"
	"github.com/stretchr/testify/require"

	"github.com/giltchain/gilt-consensus/x/pricefeed/types"
)

func TestGenesisValidateRequiresLatestEpochToBeHighest(t *testing.T) {
	genesis := types.GenesisState{
		Params: types.DefaultParams(),
		PriceSnapshots: []types.PriceSnapshot{
			{
				Epoch:           1,
				GiltPriceInGold: sdkmath.NewInt(types.PriceScale),
				SourceAdapter:   types.AdapterManual,
				ValidUntilEpoch: 1,
			},
			{
				Epoch:           2,
				GiltPriceInGold: sdkmath.NewInt(types.PriceScale),
				SourceAdapter:   types.AdapterManual,
				ValidUntilEpoch: 2,
			},
		},
		LatestEpoch: 1,
	}

	require.ErrorContains(t, genesis.Validate(), "latest_epoch must be the highest")
	genesis.LatestEpoch = 2
	require.NoError(t, genesis.Validate())
}
