package core

import (
	"fmt"
	"math/big"

	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/core/types"
	"github.com/ethereum/go-ethereum/core/vm"
)

var nativeTokenRateDenominator = new(big.Int).SetUint64(types.NativeTokenRateDenominator)

func isGasTokenAllowed(state vm.StateDB, tokenID uint64) bool {
	if tokenID == types.DefaultNativeTokenID {
		return true
	}
	return nativeTokenBoolAt(state, types.NativeTokenManagerGasAllowedSlot(tokenID))
}

func isTransferTokenAllowed(state vm.StateDB, tokenID uint64) bool {
	if tokenID == types.DefaultNativeTokenID {
		return true
	}
	return nativeTokenBoolAt(state, types.NativeTokenManagerTransferAllowedSlot(tokenID))
}

func nativeTokenGasCost(state vm.StateDB, tokenID uint64, baseCost *big.Int) (*big.Int, error) {
	if baseCost == nil || baseCost.Sign() == 0 {
		return new(big.Int), nil
	}
	if tokenID == types.DefaultNativeTokenID {
		return new(big.Int).Set(baseCost), nil
	}
	if !isGasTokenAllowed(state, tokenID) {
		return nil, fmt.Errorf("gas token %d is not enabled", tokenID)
	}
	rate := nativeTokenUintAt(state, types.NativeTokenManagerGasRateSlot(tokenID))
	if rate.Sign() == 0 {
		return nil, fmt.Errorf("gas token %d has no conversion rate", tokenID)
	}
	converted := new(big.Int).Mul(baseCost, rate)
	converted.Div(converted, nativeTokenRateDenominator)
	return converted, nil
}

func nativeTokenBoolAt(state vm.StateDB, slot common.Hash) bool {
	current, _ := state.GetStateAndCommittedState(types.GeneralNativeTokenManagerAddress, slot)
	return current != (common.Hash{})
}

func nativeTokenUintAt(state vm.StateDB, slot common.Hash) *big.Int {
	current, _ := state.GetStateAndCommittedState(types.GeneralNativeTokenManagerAddress, slot)
	return current.Big()
}
