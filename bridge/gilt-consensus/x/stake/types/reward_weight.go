package types

import (
	"fmt"

	sdkmath "cosmossdk.io/math"

	pricefeedtypes "github.com/giltchain/gilt-consensus/x/pricefeed/types"
)

// RewardWeightResult is the deterministic output of the GILT/GOLD reward-weight formula.
type RewardWeightResult struct {
	EffectiveRewardWeight sdkmath.Int
	GoldRewardWeightBps   uint64
	LastGiltPriceInGold   sdkmath.Int
	RewardWeightEpoch     uint64
}

// RewardAllocation is a deterministic fee reward amount for one validator signer.
type RewardAllocation struct {
	Signer string
	Weight sdkmath.Int
	Amount sdkmath.Int
}

// NormalizeRewardAccounting ensures custom Int fields are usable after genesis/proto migrations.
func (v *Validator) NormalizeRewardAccounting() {
	v.SelfGiltStake = normalizeInt(v.SelfGiltStake)
	v.DelegatedGiltStake = normalizeInt(v.DelegatedGiltStake)
	v.DelegatedGoldStake = normalizeInt(v.DelegatedGoldStake)
	v.EffectiveRewardWeight = normalizeInt(v.EffectiveRewardWeight)
	v.LastGiltPriceInGold = normalizeInt(v.LastGiltPriceInGold)

	if v.SelfGiltStake.IsZero() && v.DelegatedGiltStake.IsZero() && v.DelegatedGoldStake.IsZero() && v.VotingPower > 0 {
		v.SelfGiltStake = sdkmath.NewInt(v.VotingPower).Mul(sdkmath.NewInt(pricefeedtypes.PriceScale))
	}
}

// NormalizeRewardAccounting ensures validator sets can safely include legacy validators.
func (vals *ValidatorSet) NormalizeRewardAccounting() {
	if vals == nil {
		return
	}
	for _, validator := range vals.Validators {
		if validator != nil {
			validator.NormalizeLifecycleAccounting()
		}
	}
	if vals.Proposer != nil {
		vals.Proposer.NormalizeLifecycleAccounting()
	}
}

// CalculateRewardWeight converts GILT into GOLD value and applies the configured GOLD weight curve.
func CalculateRewardWeight(
	validator Validator,
	params pricefeedtypes.Params,
	price pricefeedtypes.PriceSnapshot,
) (RewardWeightResult, error) {
	validator.NormalizeRewardAccounting()

	if err := params.ValidateBasic(); err != nil {
		return RewardWeightResult{}, err
	}
	if err := price.ValidateBasic(); err != nil {
		return RewardWeightResult{}, err
	}
	if validator.SelfGiltStake.IsNegative() || validator.DelegatedGiltStake.IsNegative() || validator.DelegatedGoldStake.IsNegative() {
		return RewardWeightResult{}, fmt.Errorf("stake balances cannot be negative")
	}

	totalGiltStake := validator.SelfGiltStake.Add(validator.DelegatedGiltStake)
	goldValue := validator.DelegatedGoldStake
	giltValue := pricefeedtypes.ConvertGiltToGoldValue(totalGiltStake, price.GiltPriceInGold)
	totalValue := giltValue.Add(goldValue)

	goldWeightBps := params.MinGoldWeightBps
	if goldValue.IsZero() {
		goldWeightBps = params.MaxGoldWeightBps
	} else if params.TargetGiltShareBps > 0 && !totalValue.IsZero() {
		giltShareBps := giltValue.MulRaw(int64(pricefeedtypes.BasisPoints)).Quo(totalValue)
		backingScoreBps := giltShareBps.MulRaw(int64(pricefeedtypes.BasisPoints)).Quo(sdkmath.NewIntFromUint64(params.TargetGiltShareBps))
		if backingScoreBps.GT(sdkmath.NewIntFromUint64(pricefeedtypes.BasisPoints)) {
			backingScoreBps = sdkmath.NewIntFromUint64(pricefeedtypes.BasisPoints)
		}

		weightRange := params.MaxGoldWeightBps - params.MinGoldWeightBps
		goldWeightBps = params.MinGoldWeightBps + backingScoreBps.MulRaw(int64(weightRange)).Quo(sdkmath.NewIntFromUint64(pricefeedtypes.BasisPoints)).Uint64()
	}

	weightedGoldValue := goldValue.MulRaw(int64(goldWeightBps)).Quo(sdkmath.NewIntFromUint64(pricefeedtypes.BasisPoints))
	return RewardWeightResult{
		EffectiveRewardWeight: giltValue.Add(weightedGoldValue),
		GoldRewardWeightBps:   goldWeightBps,
		LastGiltPriceInGold:   price.GiltPriceInGold,
		RewardWeightEpoch:     price.Epoch,
	}, nil
}

func normalizeInt(value sdkmath.Int) sdkmath.Int {
	if value.IsNil() {
		return sdkmath.ZeroInt()
	}
	return value
}
