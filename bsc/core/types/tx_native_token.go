package types

import (
	"bytes"
	"math/big"

	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/rlp"
)

// NativeTokenTx is a dynamic-fee transaction with token-aware gas and value.
type NativeTokenTx struct {
	ChainID      *big.Int
	Nonce        uint64
	GasTipCap    *big.Int
	GasFeeCap    *big.Int
	Gas          uint64
	To           *common.Address `rlp:"nil"`
	Value        *big.Int
	Data         []byte
	AccessList   AccessList
	GasTokenID   uint64
	ValueTokenID uint64

	V *big.Int
	R *big.Int
	S *big.Int
}

func (tx *NativeTokenTx) copy() TxData {
	cpy := &NativeTokenTx{
		Nonce:        tx.Nonce,
		To:           copyAddressPtr(tx.To),
		Data:         common.CopyBytes(tx.Data),
		Gas:          tx.Gas,
		AccessList:   make(AccessList, len(tx.AccessList)),
		GasTokenID:   tx.GasTokenID,
		ValueTokenID: tx.ValueTokenID,
		Value:        new(big.Int),
		ChainID:      new(big.Int),
		GasTipCap:    new(big.Int),
		GasFeeCap:    new(big.Int),
		V:            new(big.Int),
		R:            new(big.Int),
		S:            new(big.Int),
	}
	copy(cpy.AccessList, tx.AccessList)
	if tx.Value != nil {
		cpy.Value.Set(tx.Value)
	}
	if tx.ChainID != nil {
		cpy.ChainID.Set(tx.ChainID)
	}
	if tx.GasTipCap != nil {
		cpy.GasTipCap.Set(tx.GasTipCap)
	}
	if tx.GasFeeCap != nil {
		cpy.GasFeeCap.Set(tx.GasFeeCap)
	}
	if tx.V != nil {
		cpy.V.Set(tx.V)
	}
	if tx.R != nil {
		cpy.R.Set(tx.R)
	}
	if tx.S != nil {
		cpy.S.Set(tx.S)
	}
	return cpy
}

func (tx *NativeTokenTx) txType() byte           { return NativeTokenTxType }
func (tx *NativeTokenTx) chainID() *big.Int      { return tx.ChainID }
func (tx *NativeTokenTx) accessList() AccessList { return tx.AccessList }
func (tx *NativeTokenTx) data() []byte           { return tx.Data }
func (tx *NativeTokenTx) gas() uint64            { return tx.Gas }
func (tx *NativeTokenTx) gasFeeCap() *big.Int    { return tx.GasFeeCap }
func (tx *NativeTokenTx) gasTipCap() *big.Int    { return tx.GasTipCap }
func (tx *NativeTokenTx) gasPrice() *big.Int     { return tx.GasFeeCap }
func (tx *NativeTokenTx) value() *big.Int        { return tx.Value }
func (tx *NativeTokenTx) nonce() uint64          { return tx.Nonce }
func (tx *NativeTokenTx) to() *common.Address    { return tx.To }
func (tx *NativeTokenTx) gasTokenID() uint64     { return tx.GasTokenID }
func (tx *NativeTokenTx) valueTokenID() uint64   { return tx.ValueTokenID }

func (tx *NativeTokenTx) effectiveGasPrice(dst *big.Int, baseFee *big.Int) *big.Int {
	if baseFee == nil {
		return dst.Set(tx.GasFeeCap)
	}
	tip := dst.Sub(tx.GasFeeCap, baseFee)
	if tip.Cmp(tx.GasTipCap) > 0 {
		tip.Set(tx.GasTipCap)
	}
	return tip.Add(tip, baseFee)
}

func (tx *NativeTokenTx) rawSignatureValues() (v, r, s *big.Int) {
	return tx.V, tx.R, tx.S
}

func (tx *NativeTokenTx) setSignatureValues(chainID, v, r, s *big.Int) {
	tx.ChainID, tx.V, tx.R, tx.S = chainID, v, r, s
}

func (tx *NativeTokenTx) encode(b *bytes.Buffer) error {
	return rlp.Encode(b, tx)
}

func (tx *NativeTokenTx) decode(input []byte) error {
	return rlp.DecodeBytes(input, tx)
}

func (tx *NativeTokenTx) sigHash(chainID *big.Int) common.Hash {
	return prefixedRlpHash(
		NativeTokenTxType,
		[]any{
			chainID,
			tx.Nonce,
			tx.GasTipCap,
			tx.GasFeeCap,
			tx.Gas,
			tx.To,
			tx.Value,
			tx.Data,
			tx.AccessList,
			tx.GasTokenID,
			tx.ValueTokenID,
		},
	)
}
