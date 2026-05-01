package types

import (
	"testing"

	sdkmath "cosmossdk.io/math"
	"github.com/stretchr/testify/require"

	pricefeedtypes "github.com/giltchain/gilt-consensus/x/pricefeed/types"
)

func TestCalculateRewardWeightGoldWeightCurve(t *testing.T) {
	params := pricefeedtypes.DefaultParams()
	price := pricefeedtypes.PriceSnapshot{
		Epoch:           1,
		GiltPriceInGold: scaledAmount(1),
		SourceAdapter:   pricefeedtypes.AdapterManual,
		ValidUntilEpoch: 1,
	}

	testCases := []struct {
		name                string
		selfGiltStake       sdkmath.Int
		delegatedGoldStake  sdkmath.Int
		expectedGoldBps     uint64
		expectedRewardValue sdkmath.Int
	}{
		{
			name:                "no GILT backing gives minimum GOLD reward weight",
			selfGiltStake:       sdkmath.ZeroInt(),
			delegatedGoldStake:  scaledAmount(100),
			expectedGoldBps:     6000,
			expectedRewardValue: scaledAmount(60),
		},
		{
			name:                "half target backing gives midpoint GOLD reward weight",
			selfGiltStake:       scaledAmount(5),
			delegatedGoldStake:  scaledAmount(95),
			expectedGoldBps:     8000,
			expectedRewardValue: scaledAmount(81),
		},
		{
			name:                "target backing gives full GOLD reward weight",
			selfGiltStake:       scaledAmount(10),
			delegatedGoldStake:  scaledAmount(90),
			expectedGoldBps:     10000,
			expectedRewardValue: scaledAmount(100),
		},
	}

	for _, tc := range testCases {
		t.Run(tc.name, func(t *testing.T) {
			result, err := CalculateRewardWeight(Validator{
				SelfGiltStake:      tc.selfGiltStake,
				DelegatedGoldStake: tc.delegatedGoldStake,
			}, params, price)

			require.NoError(t, err)
			require.Equal(t, tc.expectedGoldBps, result.GoldRewardWeightBps)
			require.True(t, tc.expectedRewardValue.Equal(result.EffectiveRewardWeight), "expected %s, got %s", tc.expectedRewardValue, result.EffectiveRewardWeight)
		})
	}
}

func TestNormalizeRewardAccountingInfersLegacySelfGiltStake(t *testing.T) {
	validator := Validator{VotingPower: 12}
	validator.NormalizeRewardAccounting()

	require.True(t, scaledAmount(12).Equal(validator.SelfGiltStake))
	require.True(t, validator.DelegatedGiltStake.IsZero())
	require.True(t, validator.DelegatedGoldStake.IsZero())
}

func scaledAmount(tokens int64) sdkmath.Int {
	return sdkmath.NewInt(tokens).MulRaw(pricefeedtypes.PriceScale)
}
