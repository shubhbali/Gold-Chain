package types

import (
	"math/big"

	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/crypto"
)

const (
	DefaultNativeTokenID              uint64 = 0
	NativeTokenTxType                        = 0x05
	NativeTokenRateDenominator               = 1_000_000_000_000_000_000
	GeneralNativeTokenManagerContract        = "0x0000000000000000000000000000000000002007"
)

var GeneralNativeTokenManagerAddress = common.HexToAddress(GeneralNativeTokenManagerContract)

const (
	nativeTokenGasAllowedSlot      = 0
	nativeTokenTransferAllowedSlot = 1
	nativeTokenGasRateSlot         = 2
	nativeTokenBalanceSlot         = 3
)

func NativeTokenManagerGasAllowedSlot(tokenID uint64) common.Hash {
	return nativeTokenManagerMappingSlot(tokenID, nativeTokenGasAllowedSlot)
}

func NativeTokenManagerTransferAllowedSlot(tokenID uint64) common.Hash {
	return nativeTokenManagerMappingSlot(tokenID, nativeTokenTransferAllowedSlot)
}

func NativeTokenManagerGasRateSlot(tokenID uint64) common.Hash {
	return nativeTokenManagerMappingSlot(tokenID, nativeTokenGasRateSlot)
}

func NativeTokenManagerBalanceSlot(account common.Address, tokenID uint64) common.Hash {
	outer := crypto.Keccak256Hash(paddedAddress(account), paddedUint64(nativeTokenBalanceSlot))
	return crypto.Keccak256Hash(paddedUint64(tokenID), outer.Bytes())
}

func nativeTokenManagerMappingSlot(tokenID uint64, slot uint64) common.Hash {
	return crypto.Keccak256Hash(paddedUint64(tokenID), paddedUint64(slot))
}

func paddedUint64(value uint64) []byte {
	out := make([]byte, 32)
	new(big.Int).SetUint64(value).FillBytes(out)
	return out
}

func paddedAddress(addr common.Address) []byte {
	return common.LeftPadBytes(addr.Bytes(), 32)
}
