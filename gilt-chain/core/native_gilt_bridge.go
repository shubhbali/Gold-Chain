package core

import (
	"fmt"

	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/core/systemcontracts"
	"github.com/ethereum/go-ethereum/core/tracing"
	"github.com/ethereum/go-ethereum/core/types"
	"github.com/ethereum/go-ethereum/core/vm"
	"github.com/ethereum/go-ethereum/crypto"
	"github.com/holiman/uint256"
)

var (
	nativeGiltBridgeAddress           = common.HexToAddress(systemcontracts.NativeGiltBridgeContract)
	nativeGiltDepositedEventSignature = crypto.Keccak256Hash([]byte("NativeGiltDeposited(address,uint256)"))
	erc20TransferEventSignature       = crypto.Keccak256Hash([]byte("Transfer(address,address,uint256)"))
)

func ApplyNativeGiltBridgeLogEffects(statedb vm.StateDB, logs []*types.Log) error {
	for _, log := range logs {
		if log == nil || log.Address != nativeGiltBridgeAddress || len(log.Topics) == 0 {
			continue
		}

		switch log.Topics[0] {
		case nativeGiltDepositedEventSignature:
			if len(log.Topics) != 2 {
				return fmt.Errorf("native gilt bridge deposit log has %d topics", len(log.Topics))
			}
			amount := new(uint256.Int).SetBytes(log.Data)
			if amount.IsZero() {
				return fmt.Errorf("native gilt bridge deposit amount is zero")
			}
			account := common.BytesToAddress(log.Topics[1].Bytes()[12:])
			statedb.AddBalance(account, amount, tracing.BalanceChangeUnspecified)

		case erc20TransferEventSignature:
			if len(log.Topics) != 3 {
				return fmt.Errorf("native gilt bridge transfer log has %d topics", len(log.Topics))
			}
			if log.Topics[2] != (common.Hash{}) {
				continue
			}
			amount := new(uint256.Int).SetBytes(log.Data)
			if amount.IsZero() {
				return fmt.Errorf("native gilt bridge burn amount is zero")
			}
			account := common.BytesToAddress(log.Topics[1].Bytes()[12:])
			if statedb.GetBalance(account).Cmp(amount) < 0 {
				return fmt.Errorf("native gilt bridge insufficient balance for %s", account.Hex())
			}
			statedb.SubBalance(account, amount, tracing.BalanceChangeUnspecified)
		}
	}
	return nil
}
