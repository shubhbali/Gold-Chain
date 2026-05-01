package keeper

import (
	"context"
	"sort"

	errorsmod "cosmossdk.io/errors"
	sdkmath "cosmossdk.io/math"

	util "github.com/giltchain/gilt-consensus/common/hex"
	pricefeedtypes "github.com/giltchain/gilt-consensus/x/pricefeed/types"
	"github.com/giltchain/gilt-consensus/x/stake/types"
)

// RefreshAllValidatorRewardWeights refreshes stored reward weights when a new accepted price is available.
func (k Keeper) RefreshAllValidatorRewardWeights(ctx context.Context) error {
	k.PanicIfSetupIsIncomplete()

	params, price, ok, err := k.getUsableRewardPrice(ctx)
	if err != nil {
		return err
	}
	if !ok {
		return nil
	}

	validators := k.GetAllValidators(ctx)
	for _, validator := range validators {
		if validator.RewardWeightEpoch == price.Epoch {
			continue
		}
		if err := applyRewardWeight(validator, params, price); err != nil {
			return err
		}
		if err := k.AddValidator(ctx, *validator); err != nil {
			return err
		}
	}

	return nil
}

// RefreshValidatorRewardWeight refreshes one validator using the latest accepted price, if available.
func (k Keeper) RefreshValidatorRewardWeight(ctx context.Context, validator *types.Validator) error {
	k.PanicIfSetupIsIncomplete()

	params, price, ok, err := k.getUsableRewardPrice(ctx)
	if err != nil {
		return err
	}
	if !ok {
		validator.NormalizeRewardAccounting()
		return nil
	}
	return applyRewardWeight(validator, params, price)
}

// AllocateCurrentValidatorRewards splits rewards across current validators by EffectiveRewardWeight.
func (k Keeper) AllocateCurrentValidatorRewards(ctx context.Context, amount sdkmath.Int) ([]types.RewardAllocation, error) {
	k.PanicIfSetupIsIncomplete()
	if !amount.IsPositive() {
		return nil, nil
	}

	params, price, ok, err := k.getUsableRewardPrice(ctx)
	if err != nil {
		return nil, err
	}
	if !ok {
		return nil, nil
	}

	validators := k.GetCurrentValidators(ctx)
	sort.Slice(validators, func(i, j int) bool {
		return util.FormatAddress(validators[i].Signer) < util.FormatAddress(validators[j].Signer)
	})

	totalWeight := sdkmath.ZeroInt()
	allocations := make([]types.RewardAllocation, 0, len(validators))
	for _, validator := range validators {
		if validator.RewardWeightEpoch != price.Epoch {
			if err := applyRewardWeight(&validator, params, price); err != nil {
				return nil, err
			}
			if err := k.AddValidator(ctx, validator); err != nil {
				return nil, err
			}
		}
		validator.NormalizeRewardAccounting()
		if !validator.EffectiveRewardWeight.IsPositive() {
			continue
		}
		totalWeight = totalWeight.Add(validator.EffectiveRewardWeight)
		allocations = append(allocations, types.RewardAllocation{
			Signer: util.FormatAddress(validator.Signer),
			Weight: validator.EffectiveRewardWeight,
		})
	}
	if totalWeight.IsZero() {
		return nil, nil
	}

	allocated := sdkmath.ZeroInt()
	largestWeightIndex := 0
	for i := range allocations {
		allocations[i].Amount = amount.Mul(allocations[i].Weight).Quo(totalWeight)
		allocated = allocated.Add(allocations[i].Amount)
		if allocations[i].Weight.GT(allocations[largestWeightIndex].Weight) {
			largestWeightIndex = i
		}
	}
	if remainder := amount.Sub(allocated); remainder.IsPositive() {
		allocations[largestWeightIndex].Amount = allocations[largestWeightIndex].Amount.Add(remainder)
	}

	return allocations, nil
}

func applyRewardWeight(validator *types.Validator, params pricefeedtypes.Params, price pricefeedtypes.PriceSnapshot) error {
	result, err := types.CalculateRewardWeight(*validator, params, price)
	if err != nil {
		return err
	}

	validator.NormalizeRewardAccounting()
	validator.EffectiveRewardWeight = result.EffectiveRewardWeight
	validator.GoldRewardWeightBps = result.GoldRewardWeightBps
	validator.LastGiltPriceInGold = result.LastGiltPriceInGold
	validator.RewardWeightEpoch = result.RewardWeightEpoch

	return nil
}

func (k Keeper) getUsableRewardPrice(ctx context.Context) (pricefeedtypes.Params, pricefeedtypes.PriceSnapshot, bool, error) {
	if k.pricefeedKeeper == nil {
		return pricefeedtypes.Params{}, pricefeedtypes.PriceSnapshot{}, false, nil
	}

	fresh, err := k.pricefeedKeeper.IsLatestPriceFresh(ctx)
	if err != nil {
		if errorsmod.IsOf(err, pricefeedtypes.ErrNoPrice) {
			return pricefeedtypes.Params{}, pricefeedtypes.PriceSnapshot{}, false, nil
		}
		return pricefeedtypes.Params{}, pricefeedtypes.PriceSnapshot{}, false, err
	}
	if !fresh {
		k.Logger(ctx).Error("Skipping reward-weight refresh because latest price snapshot is stale")
		return pricefeedtypes.Params{}, pricefeedtypes.PriceSnapshot{}, false, nil
	}

	params, err := k.pricefeedKeeper.GetParams(ctx)
	if err != nil {
		return pricefeedtypes.Params{}, pricefeedtypes.PriceSnapshot{}, false, err
	}
	price, err := k.pricefeedKeeper.GetLatestPriceSnapshot(ctx)
	if err != nil {
		if errorsmod.IsOf(err, pricefeedtypes.ErrNoPrice) {
			return pricefeedtypes.Params{}, pricefeedtypes.PriceSnapshot{}, false, nil
		}
		return pricefeedtypes.Params{}, pricefeedtypes.PriceSnapshot{}, false, err
	}
	currentEpoch, err := k.currentRewardEpoch(ctx)
	if err != nil {
		return pricefeedtypes.Params{}, pricefeedtypes.PriceSnapshot{}, false, err
	}
	if currentEpoch < price.Epoch {
		k.Logger(ctx).Error("Skipping reward-weight refresh because latest price snapshot is for a future epoch", "current_epoch", currentEpoch, "price_epoch", price.Epoch)
		return pricefeedtypes.Params{}, pricefeedtypes.PriceSnapshot{}, false, nil
	}
	if currentEpoch > price.ValidUntilEpoch {
		k.Logger(ctx).Error("Skipping reward-weight refresh because latest price snapshot expired", "current_epoch", currentEpoch, "valid_until_epoch", price.ValidUntilEpoch)
		return pricefeedtypes.Params{}, pricefeedtypes.PriceSnapshot{}, false, nil
	}

	return params, price, true, nil
}

func (k Keeper) currentRewardEpoch(ctx context.Context) (uint64, error) {
	ackCount, err := k.checkpointKeeper.GetAckCount(ctx)
	if err != nil {
		return 0, err
	}
	return ackCount + 1, nil
}
