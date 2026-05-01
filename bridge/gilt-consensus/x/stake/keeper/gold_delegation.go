package keeper

import (
	"context"
	"errors"
	"fmt"

	"cosmossdk.io/collections"
	sdkmath "cosmossdk.io/math"
	hexCodec "github.com/cosmos/cosmos-sdk/codec/address"
	sdk "github.com/cosmos/cosmos-sdk/types"

	util "github.com/giltchain/gilt-consensus/common/hex"
	"github.com/giltchain/gilt-consensus/x/stake/types"
)

// DelegateGold escrows GOLD and adds it to a validator's reward-weight accounting.
func (k *Keeper) DelegateGold(ctx context.Context, delegator string, valID uint64, amount sdkmath.Int) error {
	k.PanicIfSetupIsIncomplete()
	if !amount.IsPositive() {
		return types.ErrInvalidMsg.Wrapf("invalid GOLD amount %v", amount)
	}

	delegatorAddr, normalizedDelegator, err := parseDelegator(delegator)
	if err != nil {
		return err
	}

	validator, err := k.GetValidatorFromValID(ctx, valID)
	if err != nil {
		return err
	}

	coin := sdk.NewCoins(sdk.NewCoin(types.GoldDenom, amount))
	if err := k.bankKeeper.SendCoinsFromAccountToModule(ctx, delegatorAddr, types.ModuleName, coin); err != nil {
		return err
	}

	delegation, err := k.getGoldDelegationOrZero(ctx, normalizedDelegator, valID)
	if err != nil {
		return err
	}
	delegation.Amount = delegation.Amount.Add(amount)
	if err := k.SetGoldDelegation(ctx, delegation); err != nil {
		return err
	}

	validator.DelegatedGoldStake = validator.DelegatedGoldStake.Add(amount)
	if err := k.RefreshValidatorRewardWeight(ctx, &validator); err != nil {
		return err
	}
	return k.AddValidator(ctx, validator)
}

// UndelegateGold removes GOLD from reward-weight accounting and releases escrow.
func (k *Keeper) UndelegateGold(ctx context.Context, delegator string, valID uint64, amount sdkmath.Int) error {
	k.PanicIfSetupIsIncomplete()
	if !amount.IsPositive() {
		return types.ErrInvalidMsg.Wrapf("invalid GOLD amount %v", amount)
	}

	delegatorAddr, normalizedDelegator, err := parseDelegator(delegator)
	if err != nil {
		return err
	}

	validator, err := k.GetValidatorFromValID(ctx, valID)
	if err != nil {
		return err
	}
	delegation, err := k.GetGoldDelegation(ctx, normalizedDelegator, valID)
	if err != nil {
		return err
	}
	if delegation.Amount.LT(amount) {
		return types.ErrInvalidMsg.Wrapf("insufficient GOLD delegation: have %s, need %s", delegation.Amount, amount)
	}
	if validator.DelegatedGoldStake.LT(amount) {
		return types.ErrInvalidMsg.Wrapf("validator delegated GOLD accounting is below undelegation amount")
	}

	coin := sdk.NewCoins(sdk.NewCoin(types.GoldDenom, amount))
	if err := k.bankKeeper.SendCoinsFromModuleToAccount(ctx, types.ModuleName, delegatorAddr, coin); err != nil {
		return err
	}

	delegation.Amount = delegation.Amount.Sub(amount)
	if delegation.Amount.IsZero() {
		if err := k.RemoveGoldDelegation(ctx, normalizedDelegator, valID); err != nil {
			return err
		}
	} else if err := k.SetGoldDelegation(ctx, delegation); err != nil {
		return err
	}

	validator.DelegatedGoldStake = validator.DelegatedGoldStake.Sub(amount)
	if err := k.RefreshValidatorRewardWeight(ctx, &validator); err != nil {
		return err
	}
	return k.AddValidator(ctx, validator)
}

// SetGoldDelegation stores a GOLD delegation.
func (k *Keeper) SetGoldDelegation(ctx context.Context, delegation types.GoldDelegation) error {
	k.PanicIfSetupIsIncomplete()
	delegation.Normalize()
	if err := delegation.ValidateBasic(); err != nil {
		return err
	}
	return k.goldDelegations.Set(ctx, goldDelegationKey(delegation.Delegator, delegation.ValId), delegation)
}

// GetGoldDelegation returns a GOLD delegation by delegator and validator id.
func (k *Keeper) GetGoldDelegation(ctx context.Context, delegator string, valID uint64) (types.GoldDelegation, error) {
	k.PanicIfSetupIsIncomplete()
	return k.goldDelegations.Get(ctx, goldDelegationKey(delegator, valID))
}

// RemoveGoldDelegation deletes a GOLD delegation.
func (k *Keeper) RemoveGoldDelegation(ctx context.Context, delegator string, valID uint64) error {
	k.PanicIfSetupIsIncomplete()
	return k.goldDelegations.Remove(ctx, goldDelegationKey(delegator, valID))
}

// GetAllGoldDelegations returns every stored GOLD delegation.
func (k *Keeper) GetAllGoldDelegations(ctx context.Context) ([]types.GoldDelegation, error) {
	k.PanicIfSetupIsIncomplete()
	iterator, err := k.goldDelegations.Iterate(ctx, nil)
	if err != nil {
		return nil, err
	}
	defer func() {
		if err := iterator.Close(); err != nil {
			k.Logger(ctx).Error("Error closing gold delegation iterator", "error", err)
		}
	}()

	delegations := make([]types.GoldDelegation, 0)
	for ; iterator.Valid(); iterator.Next() {
		delegation, err := iterator.Value()
		if err != nil {
			return nil, err
		}
		delegation.Normalize()
		delegations = append(delegations, delegation)
	}
	return delegations, nil
}

func (k *Keeper) getGoldDelegationOrZero(ctx context.Context, delegator string, valID uint64) (types.GoldDelegation, error) {
	delegation, err := k.GetGoldDelegation(ctx, delegator, valID)
	if err == nil {
		delegation.Normalize()
		return delegation, nil
	}
	if errors.Is(err, collections.ErrNotFound) {
		return types.GoldDelegation{
			Delegator: util.FormatAddress(delegator),
			ValId:     valID,
			Amount:    sdkmath.ZeroInt(),
		}, nil
	}
	return types.GoldDelegation{}, err
}

func parseDelegator(delegator string) (sdk.AccAddress, string, error) {
	normalized := util.FormatAddress(delegator)
	addrBytes, err := hexCodec.NewHexCodec().StringToBytes(normalized)
	if err != nil {
		return nil, "", types.ErrInvalidMsg.Wrapf("invalid delegator %s", delegator)
	}
	addr := sdk.AccAddress(addrBytes)
	if addr.Empty() {
		return nil, "", types.ErrInvalidMsg.Wrapf("invalid delegator %s", delegator)
	}
	return addr, normalized, nil
}

func goldDelegationKey(delegator string, valID uint64) string {
	return fmt.Sprintf("%020d/%s", valID, util.FormatAddress(delegator))
}
