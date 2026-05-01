package types_test

import (
	"encoding/json"
	"testing"

	sdkmath "cosmossdk.io/math"
	"github.com/cosmos/cosmos-sdk/codec"
	codectypes "github.com/cosmos/cosmos-sdk/codec/types"
	"github.com/cosmos/cosmos-sdk/crypto/keys/secp256k1"
	"github.com/stretchr/testify/require"

	"github.com/giltchain/gilt-consensus/x/stake/types"
)

var genesisOneGilt = sdkmath.NewInt(1000000000000000000)

func TestNewGenesisState(t *testing.T) {
	t.Parallel()

	t.Run("creates genesis state with all parameters", func(t *testing.T) {
		t.Parallel()

		var validators []*types.Validator
		valSet := types.ValidatorSet{}
		stakingSeqs := []string{"seq1", "seq2"}

		gs := types.NewGenesisState(validators, valSet, stakingSeqs)

		require.NotNil(t, gs)
		require.Equal(t, validators, gs.Validators)
		require.Equal(t, valSet, gs.CurrentValidatorSet)
		require.Equal(t, stakingSeqs, gs.StakingSequences)
	})

	t.Run("creates genesis state with nil validators", func(t *testing.T) {
		t.Parallel()

		gs := types.NewGenesisState(nil, types.ValidatorSet{}, nil)

		require.NotNil(t, gs)
		require.Nil(t, gs.Validators)
		require.Nil(t, gs.StakingSequences)
	})
}

func TestDefaultGenesisState(t *testing.T) {
	t.Parallel()

	t.Run("returns default genesis state", func(t *testing.T) {
		t.Parallel()

		gs := types.DefaultGenesisState()

		require.NotNil(t, gs)
	})

	t.Run("default genesis state is valid", func(t *testing.T) {
		t.Parallel()

		gs := types.DefaultGenesisState()

		err := gs.Validate()
		require.NoError(t, err)
	})
}

func TestGenesisState_Validate(t *testing.T) {
	t.Parallel()

	t.Run("validates correct genesis state", func(t *testing.T) {
		t.Parallel()

		gs := types.GenesisState{}

		err := gs.Validate()
		require.NoError(t, err)
	})

	t.Run("rejects empty staking sequence", func(t *testing.T) {
		t.Parallel()

		gs := types.GenesisState{
			StakingSequences: []string{""},
		}

		err := gs.Validate()
		require.Error(t, err)
		require.Contains(t, err.Error(), "invalid sequence")
	})

	t.Run("rejects sequence with empty string in middle", func(t *testing.T) {
		t.Parallel()

		gs := types.GenesisState{
			StakingSequences: []string{"seq1", "", "seq3"},
		}

		err := gs.Validate()
		require.Error(t, err)
		require.Contains(t, err.Error(), "invalid sequence")
	})

	t.Run("validates genesis with valid sequences", func(t *testing.T) {
		t.Parallel()

		gs := types.GenesisState{
			StakingSequences: []string{"seq1", "seq2", "seq3"},
		}

		err := gs.Validate()
		require.NoError(t, err)
	})

	t.Run("accepts active validators without approval authority when approvals exist", func(t *testing.T) {
		t.Parallel()

		validators, valSet := genesisValidators(t, 4)
		gs := types.NewGenesisState(validators, valSet, nil)
		gs.ValidatorApprovals = genesisApprovals(validators)

		err := gs.Validate()
		require.NoError(t, err)
	})

	t.Run("rejects active validators without matching approvals", func(t *testing.T) {
		t.Parallel()

		validators, valSet := genesisValidators(t, 4)
		gs := types.NewGenesisState(validators, valSet, nil)

		err := gs.Validate()
		require.Error(t, err)
		require.Contains(t, err.Error(), "missing native approval")
	})

	t.Run("accepts active validators with explicit matching approvals", func(t *testing.T) {
		t.Parallel()

		validators, valSet := genesisValidators(t, 4)
		gs := types.NewGenesisState(validators, valSet, nil)
		gs.ValidatorApprovals = genesisApprovals(validators)

		err := gs.Validate()
		require.NoError(t, err)
	})

	t.Run("rejects duplicate validator ids in genesis validators", func(t *testing.T) {
		t.Parallel()

		validators, valSet := genesisValidators(t, 4)
		validators[1].ValId = validators[0].ValId
		gs := types.NewGenesisState(validators, valSet, nil)
		gs.ValidatorApprovals = genesisApprovals(validators)

		err := gs.Validate()
		require.Error(t, err)
		require.Contains(t, err.Error(), "duplicate validator id")
	})

	t.Run("rejects duplicate validator ids in current validator set", func(t *testing.T) {
		t.Parallel()

		validators, _ := genesisValidators(t, 4)
		valSet := types.ValidatorSet{
			Validators: []*types.Validator{
				validators[0],
				validators[1],
				validators[1],
				validators[3],
			},
		}
		gs := types.NewGenesisState(validators, valSet, nil)
		gs.ValidatorApprovals = genesisApprovals(validators)

		err := gs.Validate()
		require.Error(t, err)
		require.Contains(t, err.Error(), "duplicate current validator id")
	})

	t.Run("rejects duplicate active validator operators", func(t *testing.T) {
		t.Parallel()

		validators, valSet := genesisValidators(t, 4)
		validators[1].Operator = validators[0].OperatorAddress()
		validators[1].NormalizeLifecycleAccounting()
		for _, validator := range valSet.Validators {
			if validator.ValId == validators[1].ValId {
				validator.Operator = validators[0].OperatorAddress()
				validator.NormalizeLifecycleAccounting()
			}
		}
		gs := types.NewGenesisState(validators, valSet, nil)
		gs.ValidatorApprovals = genesisApprovals(validators)

		err := gs.Validate()
		require.Error(t, err)
		require.Contains(t, err.Error(), "active validator operator")
		require.Contains(t, err.Error(), "duplicated")
	})
}

func TestGetGenesisStateFromAppState(t *testing.T) {
	t.Parallel()

	t.Run("retrieves genesis state from app state", func(t *testing.T) {
		t.Parallel()

		interfaceRegistry := codectypes.NewInterfaceRegistry()
		types.RegisterInterfaces(interfaceRegistry)
		cdc := codec.NewProtoCodec(interfaceRegistry)

		gs := types.DefaultGenesisState()
		appState := make(map[string]json.RawMessage)
		appState[types.ModuleName] = cdc.MustMarshalJSON(gs)

		result := types.GetGenesisStateFromAppState(cdc, appState)

		require.NotNil(t, result)
	})

	t.Run("returns empty genesis state when module not in app state", func(t *testing.T) {
		t.Parallel()

		interfaceRegistry := codectypes.NewInterfaceRegistry()
		cdc := codec.NewProtoCodec(interfaceRegistry)

		appState := make(map[string]json.RawMessage)

		result := types.GetGenesisStateFromAppState(cdc, appState)

		require.NotNil(t, result)
	})
}

func TestSetGenesisStateToAppState(t *testing.T) {
	t.Parallel()

	t.Run("sets genesis state to app state", func(t *testing.T) {
		t.Parallel()

		interfaceRegistry := codectypes.NewInterfaceRegistry()
		types.RegisterInterfaces(interfaceRegistry)
		cdc := codec.NewProtoCodec(interfaceRegistry)

		appState := make(map[string]json.RawMessage)
		var validators []*types.Validator
		valSet := types.ValidatorSet{}

		result, err := types.SetGenesisStateToAppState(cdc, appState, validators, valSet)

		require.NoError(t, err)
		require.NotNil(t, result)
		require.Contains(t, result, types.ModuleName)
	})

	t.Run("updates existing app state", func(t *testing.T) {
		t.Parallel()

		interfaceRegistry := codectypes.NewInterfaceRegistry()
		types.RegisterInterfaces(interfaceRegistry)
		cdc := codec.NewProtoCodec(interfaceRegistry)

		// Initialize with the default state
		gs := types.DefaultGenesisState()
		appState := make(map[string]json.RawMessage)
		appState[types.ModuleName] = cdc.MustMarshalJSON(gs)

		// Update with new validators
		var validators []*types.Validator
		valSet := types.ValidatorSet{}

		result, err := types.SetGenesisStateToAppState(cdc, appState, validators, valSet)

		require.NoError(t, err)
		require.NotNil(t, result)
	})

	t.Run("sets validator genesis without explicit approval authority", func(t *testing.T) {
		t.Parallel()

		interfaceRegistry := codectypes.NewInterfaceRegistry()
		types.RegisterInterfaces(interfaceRegistry)
		cdc := codec.NewProtoCodec(interfaceRegistry)

		validators, valSet := genesisValidators(t, 4)
		appState := make(map[string]json.RawMessage)
		gs := types.DefaultGenesisState()
		appState[types.ModuleName] = cdc.MustMarshalJSON(gs)

		result, err := types.SetGenesisStateToAppState(cdc, appState, validators, valSet)

		require.NoError(t, err)
		require.NotNil(t, result)
	})
}

func genesisValidators(t *testing.T, count int) ([]*types.Validator, types.ValidatorSet) {
	t.Helper()

	validators := make([]*types.Validator, 0, count)
	for i := 0; i < count; i++ {
		pubKey := secp256k1.GenPrivKey().PubKey()
		validator, err := types.NewValidator(uint64(i+1), 1, 0, 1, 1, pubKey, pubKey.Address().String())
		require.NoError(t, err)
		validator.SelfGiltStake = genesisOneGilt
		validator.NormalizeLifecycleAccounting()
		validators = append(validators, validator)
	}
	return validators, *types.NewValidatorSet(validators)
}

func genesisApprovals(validators []*types.Validator) []types.ValidatorApproval {
	approvals := make([]types.ValidatorApproval, 0, len(validators))
	for _, validator := range validators {
		approvals = append(approvals, types.ValidatorApproval{
			ValId:           validator.ValId,
			Operator:        validator.OperatorAddress(),
			ActivationEpoch: validator.StartEpoch,
			MaxGiltStake:    validator.SelfGiltStake,
			SignerPubKey:    validator.PubKey,
			Nonce:           validator.Nonce,
		})
	}
	return approvals
}
