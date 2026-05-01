package types_test

import (
	"testing"

	"github.com/stretchr/testify/require"

	"github.com/giltchain/gilt-consensus/x/chainmanager/types"
)

func TestDefaultParams(t *testing.T) {
	t.Parallel()

	t.Run("returns non-nil default params", func(t *testing.T) {
		t.Parallel()

		params := types.DefaultParams()

		require.NotNil(t, params)
	})

	t.Run("default params have correct values", func(t *testing.T) {
		t.Parallel()

		params := types.DefaultParams()

		require.Equal(t, uint64(6), params.MainChainTxConfirmations)
		require.Equal(t, uint64(10), params.GiltChainTxConfirmations)
		require.NotEmpty(t, params.ChainParams.StateReceiverAddress)
		require.NotEmpty(t, params.ChainParams.ValidatorSetAddress)
	})
}

func TestNewParams(t *testing.T) {
	t.Parallel()

	t.Run("creates params with all fields", func(t *testing.T) {
		t.Parallel()

		chainParams := types.ChainParams{
			GiltChainId:          "137",
			GiltConsensusChainId: "giltconsensus-137",
			StateReceiverAddress: "0x0000000000000000000000000000000000001001",
			ValidatorSetAddress:  "0x0000000000000000000000000000000000001000",
		}

		params := types.NewParams(10, 20, chainParams)

		require.Equal(t, uint64(10), params.MainChainTxConfirmations)
		require.Equal(t, uint64(20), params.GiltChainTxConfirmations)
		require.Equal(t, chainParams, params.ChainParams)
	})

	t.Run("creates params with zero confirmations", func(t *testing.T) {
		t.Parallel()

		chainParams := types.ChainParams{
			StateReceiverAddress: "0x0000000000000000000000000000000000001001",
			ValidatorSetAddress:  "0x0000000000000000000000000000000000001000",
		}

		params := types.NewParams(0, 0, chainParams)

		require.Equal(t, uint64(0), params.MainChainTxConfirmations)
		require.Equal(t, uint64(0), params.GiltChainTxConfirmations)
	})
}

func TestParams_ValidateBasic(t *testing.T) {
	t.Parallel()

	t.Run("validates params with valid addresses", func(t *testing.T) {
		t.Parallel()

		params := types.NewParams(6, 10, validChainParams())

		err := params.ValidateBasic()
		require.NoError(t, err)
	})

	t.Run("rejects invalid slash manager address", func(t *testing.T) {
		t.Parallel()

		chainParams := validChainParams()
		chainParams.SlashManagerAddress = "0xinvalid"
		params := types.NewParams(6, 10, chainParams)

		err := params.ValidateBasic()
		require.Error(t, err)
		require.Contains(t, err.Error(), "slash_manager_address")
	})

	t.Run("rejects invalid root chain address", func(t *testing.T) {
		t.Parallel()

		chainParams := validChainParams()
		chainParams.RootChainAddress = "bad_address"
		params := types.NewParams(6, 10, chainParams)

		err := params.ValidateBasic()
		require.Error(t, err)
		require.Contains(t, err.Error(), "root_chain_address")
	})

	t.Run("rejects invalid staking info address", func(t *testing.T) {
		t.Parallel()

		chainParams := validChainParams()
		chainParams.StakingInfoAddress = "123"
		params := types.NewParams(6, 10, chainParams)

		err := params.ValidateBasic()
		require.Error(t, err)
		require.Contains(t, err.Error(), "staking_info_address")
	})

	t.Run("rejects invalid state sender address", func(t *testing.T) {
		t.Parallel()

		chainParams := validChainParams()
		chainParams.StateSenderAddress = "not_hex"
		params := types.NewParams(6, 10, chainParams)

		err := params.ValidateBasic()
		require.Error(t, err)
		require.Contains(t, err.Error(), "state_sender_address")
	})

	t.Run("rejects invalid state receiver address", func(t *testing.T) {
		t.Parallel()

		chainParams := validChainParams()
		chainParams.StateReceiverAddress = ""
		params := types.NewParams(6, 10, chainParams)

		err := params.ValidateBasic()
		require.Error(t, err)
		require.Contains(t, err.Error(), "state_receiver_address")
	})

	t.Run("rejects invalid validator set address", func(t *testing.T) {
		t.Parallel()

		chainParams := validChainParams()
		chainParams.ValidatorSetAddress = "0x"
		params := types.NewParams(6, 10, chainParams)

		err := params.ValidateBasic()
		require.Error(t, err)
		require.Contains(t, err.Error(), "validator_set_address")
	})

	t.Run("all addresses must be valid if provided", func(t *testing.T) {
		t.Parallel()

		params := types.NewParams(6, 10, validChainParams())

		err := params.ValidateBasic()
		require.NoError(t, err)
	})
}

func validChainParams() types.ChainParams {
	return types.ChainParams{
		SlashManagerAddress:  "0x1234567890123456789012345678901234567892",
		RootChainAddress:     "0x1234567890123456789012345678901234567893",
		StakingInfoAddress:   "0x1234567890123456789012345678901234567894",
		StateSenderAddress:   "0x1234567890123456789012345678901234567895",
		StateReceiverAddress: "0x1234567890123456789012345678901234567896",
		ValidatorSetAddress:  "0x1234567890123456789012345678901234567897",
	}
}

func TestDefaultConstants(t *testing.T) {
	t.Parallel()

	t.Run("default constants have correct values", func(t *testing.T) {
		t.Parallel()

		require.Equal(t, uint64(6), types.DefaultMainChainTxConfirmations)
		require.Equal(t, uint64(10), types.DefaultGiltChainTxConfirmations)
		require.Equal(t, "0x0000000000000000000000000000000000001001", types.DefaultStateReceiverAddress)
		require.Equal(t, "0x0000000000000000000000000000000000001000", types.DefaultValidatorSetAddress)
	})
}
