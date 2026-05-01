package keeper

import (
	"context"
	"fmt"

	sdkmath "cosmossdk.io/math"
	abci "github.com/cometbft/cometbft/abci/types"
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/giltchain/gilt-consensus/x/stake/types"
)

// InitGenesis sets validator information for genesis in x/stake module
func (k Keeper) InitGenesis(ctx context.Context, data *types.GenesisState) []abci.ValidatorUpdate {
	k.PanicIfSetupIsIncomplete()

	params := data.ValidatorLifecycleParams
	params.NormalizeDefaults()
	if err := k.SetValidatorLifecycleParams(ctx, params); err != nil {
		panic(fmt.Errorf("invalid validator lifecycle params while initializing stake genesis: %w", err))
	}

	for _, approval := range data.ValidatorApprovals {
		if err := k.SetValidatorApproval(ctx, approval); err != nil {
			panic(fmt.Errorf("error setting validator approval while initializing stake genesis: %w", err))
		}
	}

	// get the current validators' set
	var vals []*types.Validator
	if len(data.CurrentValidatorSet.Validators) == 0 {
		vals = data.Validators
	} else {
		vals = data.CurrentValidatorSet.Validators
	}

	if len(vals) != 0 {
		if err := validateUniqueActiveOperatorSet(vals); err != nil {
			panic(fmt.Errorf("invalid active operator uniqueness while initializing stake genesis: %w", err))
		}

		resultValSet := types.NewValidatorSet(vals)

		// at genesis, the previous validator set will be equal to the current validator set
		err := k.UpdatePreviousBlockValidatorSetInStore(ctx, *resultValSet)
		if err != nil {
			panic(fmt.Errorf("error updating previous validator set in store while initializing stake genesis: %w", err))
		}

		// add validators in store
		for _, validator := range resultValSet.Validators {
			validator.NormalizeLifecycleAccounting()
			if len(data.GoldDelegations) > 0 {
				validator.DelegatedGoldStake = sdkmath.ZeroInt()
				validator.EffectiveRewardWeight = sdkmath.ZeroInt()
			}
			// Add individual validator to the state
			if err := k.AddValidator(ctx, *validator); err != nil {
				panic(fmt.Errorf("error adding the validator while initializing stake genesis: %w", err))
			}

			// update validator set in store
			if err := k.UpdateValidatorSetInStore(ctx, *resultValSet); err != nil {
				panic(err)
			}

			// increment accum if initializing the validator set
			if len(data.CurrentValidatorSet.Validators) == 0 {
				err := k.IncrementAccum(ctx, 1)
				if err != nil {
					panic(fmt.Errorf("error incrementing the validators set accum while initializing stake genesis: %w", err))
				}
			}
		}
	}

	for _, delegation := range data.GoldDelegations {
		delegation.Normalize()
		if err := delegation.ValidateBasic(); err != nil {
			panic(fmt.Errorf("invalid GOLD delegation while initializing stake genesis: %w", err))
		}
		if err := k.SetGoldDelegation(ctx, delegation); err != nil {
			panic(fmt.Errorf("error setting GOLD delegation while initializing stake genesis: %w", err))
		}
		validator, err := k.GetValidatorFromValID(ctx, delegation.ValId)
		if err != nil {
			panic(fmt.Errorf("GOLD delegation references missing validator %d: %w", delegation.ValId, err))
		}
		validator.DelegatedGoldStake = validator.DelegatedGoldStake.Add(delegation.Amount)
		if err := k.RefreshValidatorRewardWeight(ctx, &validator); err != nil {
			panic(fmt.Errorf("error refreshing validator reward weight while initializing stake genesis: %w", err))
		}
		if err := k.AddValidator(ctx, validator); err != nil {
			panic(fmt.Errorf("error adding validator GOLD delegation while initializing stake genesis: %w", err))
		}
	}

	for _, sequence := range data.StakingSequences {
		err := k.SetStakingSequence(ctx, sequence)
		if err != nil {
			panic(fmt.Errorf("error in setting staking sequence while initializing stake genesis: %w", err))
		}
	}

	// set the last block txs
	if len(data.LastBlockTxs.Txs) > 0 {
		err := k.SetLastBlockTxs(ctx, data.LastBlockTxs.Txs)
		if err != nil {
			panic(fmt.Errorf("error in getting last block txs while initializing stake genesis: %w", err))
		}
	} else {
		// if no last block txs are provided, set it to empty
		err := k.SetLastBlockTxs(ctx, [][]byte{})
		if err != nil {
			panic(fmt.Errorf("error in setting last block txs while initializing stake genesis: %w", err))
		}
	}

	validators := k.GetAllValidators(ctx)
	cometVals := make([]abci.ValidatorUpdate, 0, len(validators))
	for _, validator := range validators {
		cmtPk, err := validator.CmtConsPublicKey()
		if err != nil {
			panic(err)
		}
		cometVals = append(cometVals, abci.ValidatorUpdate{
			PubKey: cmtPk,
			Power:  validator.GetVotingPower(),
		})
	}

	return cometVals
}

func validateUniqueActiveOperatorSet(validators []*types.Validator) error {
	seen := make(map[string]uint64, len(validators))
	for _, validator := range validators {
		if validator == nil || validator.Jailed || validator.VotingPower <= 0 {
			continue
		}
		validator.NormalizeLifecycleAccounting()

		operator := validator.OperatorAddress()
		if existingValID, ok := seen[operator]; ok && existingValID != validator.ValId {
			return fmt.Errorf("active operator %s is duplicated across validator %d and %d", operator, existingValID, validator.ValId)
		}
		seen[operator] = validator.ValId
	}
	return nil
}

// ExportGenesis returns a GenesisState for the given stake context and keeper.
// The GenesisState will contain the validators and the staking sequences
func (k Keeper) ExportGenesis(ctx sdk.Context) *types.GenesisState {
	k.PanicIfSetupIsIncomplete()

	validatorSet, err := k.GetValidatorSet(ctx)
	if err != nil {
		k.Logger(ctx).Error("Error in fetching validator set from store", "err", err)
		return nil
	}

	sequences, err := k.GetStakingSequences(ctx)
	if err != nil {
		k.Logger(ctx).Error("Error in fetching staking sequences from store", "err", err)
		return nil
	}

	previousValidatorSet, err := k.GetPreviousBlockValidatorSet(ctx)
	if err != nil {
		k.Logger(ctx).Error("Error in fetching previous validator set from store", "err", err)
		return nil
	}

	lastBlockTxs, err := k.GetLastBlockTxs(ctx)
	if err != nil {
		k.Logger(ctx).Error("Error in fetching last block txs from store", "err", err)
		return nil
	}

	penultimateValidatorSet, err := k.GetPenultimateBlockValidatorSet(ctx)
	if err != nil {
		k.Logger(ctx).Error("Error in fetching penultimate validator set from store", "err", err)
		return nil
	}
	goldDelegations, err := k.GetAllGoldDelegations(ctx)
	if err != nil {
		k.Logger(ctx).Error("Error in fetching GOLD delegations from store", "err", err)
		return nil
	}
	validatorApprovals, err := k.GetAllValidatorApprovals(ctx)
	if err != nil {
		k.Logger(ctx).Error("Error in fetching validator approvals from store", "err", err)
		return nil
	}
	validatorLifecycleParams, err := k.GetValidatorLifecycleParams(ctx)
	if err != nil {
		k.Logger(ctx).Error("Error in fetching validator lifecycle params from store", "err", err)
		return nil
	}

	return &types.GenesisState{
		Validators:                   k.GetAllValidators(ctx),
		CurrentValidatorSet:          validatorSet,
		StakingSequences:             sequences,
		PreviousBlockValidatorSet:    previousValidatorSet,
		LastBlockTxs:                 lastBlockTxs,
		PenultimateBlockValidatorSet: penultimateValidatorSet,
		GoldDelegations:              goldDelegations,
		ValidatorApprovals:           validatorApprovals,
		ValidatorLifecycleParams:     validatorLifecycleParams,
	}
}
