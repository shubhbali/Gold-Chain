package types

import (
	"bytes"
	"errors"
	"math/big"

	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/rlp"
)

// StateSyncTx is a system transaction that records Polygon-style state sync events.
type StateSyncTx struct {
	StateSyncData []*StateSyncData
}

func (tx *StateSyncTx) copy() TxData {
	if tx == nil {
		return nil
	}
	out := &StateSyncTx{}
	if tx.StateSyncData != nil {
		out.StateSyncData = make([]*StateSyncData, len(tx.StateSyncData))
		for i, d := range tx.StateSyncData {
			if d == nil {
				continue
			}
			cpy := *d
			out.StateSyncData[i] = &cpy
		}
	}
	return out
}

func (tx *StateSyncTx) txType() byte           { return StateSyncTxType }
func (tx *StateSyncTx) chainID() *big.Int      { return nil }
func (tx *StateSyncTx) accessList() AccessList { return nil }
func (tx *StateSyncTx) data() []byte           { return nil }
func (tx *StateSyncTx) gas() uint64            { return 0 }
func (tx *StateSyncTx) gasPrice() *big.Int     { return common.Big0 }
func (tx *StateSyncTx) gasTipCap() *big.Int    { return common.Big0 }
func (tx *StateSyncTx) gasFeeCap() *big.Int    { return common.Big0 }
func (tx *StateSyncTx) value() *big.Int        { return common.Big0 }
func (tx *StateSyncTx) nonce() uint64          { return 0 }
func (tx *StateSyncTx) to() *common.Address    { return &common.Address{} }
func (tx *StateSyncTx) gasTokenID() uint64     { return 0 }
func (tx *StateSyncTx) valueTokenID() uint64   { return 0 }

func (tx *StateSyncTx) effectiveGasPrice(dst *big.Int, _ *big.Int) *big.Int {
	return dst.SetUint64(0)
}

func (tx *StateSyncTx) rawSignatureValues() (v, r, s *big.Int) {
	return common.Big0, common.Big0, common.Big0
}

func (tx *StateSyncTx) setSignatureValues(_, _, _, _ *big.Int) {
	panic("setSignatureValues called on StateSyncTx")
}

func (tx *StateSyncTx) encode(buf *bytes.Buffer) error {
	if tx == nil {
		return errors.New("nil StateSyncTx")
	}
	enc := make([]StateSyncData, 0, len(tx.StateSyncData))
	for _, d := range tx.StateSyncData {
		if d == nil {
			continue
		}
		enc = append(enc, *d)
	}
	return rlp.Encode(buf, enc)
}

func (tx *StateSyncTx) decode(b []byte) error {
	if tx == nil {
		return errors.New("nil StateSyncTx")
	}
	var dec []StateSyncData
	if err := rlp.DecodeBytes(b, &dec); err != nil {
		return err
	}
	tx.StateSyncData = make([]*StateSyncData, len(dec))
	for i, entry := range dec {
		cpy := entry
		tx.StateSyncData[i] = &cpy
	}
	return nil
}

func (tx *StateSyncTx) sigHash(*big.Int) common.Hash {
	panic("sigHash called on StateSyncTx")
}
