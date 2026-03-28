package core

import (
	"testing"

	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/core/state"
	"github.com/ethereum/go-ethereum/core/types"
	"github.com/holiman/uint256"
)

func TestApplyNativeGiltBridgeLogEffectsDeposit(t *testing.T) {
	statedb, _ := state.New(types.EmptyRootHash, state.NewDatabaseForTesting())
	account := common.HexToAddress("0x1001")
	amount := uint256.NewInt(7)

	logs := []*types.Log{{
		Address: nativeGiltBridgeAddress,
		Topics: []common.Hash{
			nativeGiltDepositedEventSignature,
			common.BytesToHash(common.LeftPadBytes(account.Bytes(), 32)),
		},
		Data: common.LeftPadBytes(amount.Bytes(), 32),
	}}

	if err := ApplyNativeGiltBridgeLogEffects(statedb, logs); err != nil {
		t.Fatalf("deposit hook failed: %v", err)
	}
	if got := statedb.GetBalance(account); got.Cmp(amount) != 0 {
		t.Fatalf("wrong balance after deposit: got %s want %s", got.String(), amount.String())
	}
}

func TestApplyNativeGiltBridgeLogEffectsWithdraw(t *testing.T) {
	statedb, _ := state.New(types.EmptyRootHash, state.NewDatabaseForTesting())
	account := common.HexToAddress("0x2002")
	statedb.AddBalance(account, uint256.NewInt(10), 0)

	logs := []*types.Log{{
		Address: nativeGiltBridgeAddress,
		Topics: []common.Hash{
			erc20TransferEventSignature,
			common.BytesToHash(common.LeftPadBytes(account.Bytes(), 32)),
			common.Hash{},
		},
		Data: common.LeftPadBytes(uint256.NewInt(4).Bytes(), 32),
	}}

	if err := ApplyNativeGiltBridgeLogEffects(statedb, logs); err != nil {
		t.Fatalf("withdraw hook failed: %v", err)
	}
	if got := statedb.GetBalance(account); got.Cmp(uint256.NewInt(6)) != 0 {
		t.Fatalf("wrong balance after withdraw: got %s want 6", got.String())
	}
}

func TestApplyNativeGiltBridgeLogEffectsRejectsInsufficientBalance(t *testing.T) {
	statedb, _ := state.New(types.EmptyRootHash, state.NewDatabaseForTesting())
	account := common.HexToAddress("0x3003")

	logs := []*types.Log{{
		Address: nativeGiltBridgeAddress,
		Topics: []common.Hash{
			erc20TransferEventSignature,
			common.BytesToHash(common.LeftPadBytes(account.Bytes(), 32)),
			common.Hash{},
		},
		Data: common.LeftPadBytes(uint256.NewInt(1).Bytes(), 32),
	}}

	if err := ApplyNativeGiltBridgeLogEffects(statedb, logs); err == nil {
		t.Fatalf("expected insufficient balance error")
	}
}
