package types

import (
	"bytes"
	"math/big"
	"testing"

	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/rlp"
)

func TestStateSyncTxBinaryRoundTrip(t *testing.T) {
	tx := NewTx(&StateSyncTx{
		StateSyncData: []*StateSyncData{
			{
				ID:       1,
				Contract: common.HexToAddress("0x0000000000000000000000000000000000001111"),
				Data:     []byte{0x01, 0x02, 0x03},
				TxHash:   common.HexToHash("0x01"),
			},
			{
				ID:       2,
				Contract: common.HexToAddress("0x0000000000000000000000000000000000002222"),
				Data:     []byte{0x04, 0x05},
				TxHash:   common.HexToHash("0x02"),
			},
		},
	})
	blob, err := tx.MarshalBinary()
	if err != nil {
		t.Fatalf("marshal failed: %v", err)
	}
	var decoded Transaction
	if err := decoded.UnmarshalBinary(blob); err != nil {
		t.Fatalf("unmarshal failed: %v", err)
	}
	if decoded.Type() != StateSyncTxType {
		t.Fatalf("wrong tx type: got %d want %d", decoded.Type(), StateSyncTxType)
	}
	got := decoded.inner.(*StateSyncTx)
	if len(got.StateSyncData) != 2 {
		t.Fatalf("wrong state sync event count: got %d", len(got.StateSyncData))
	}
	if got.StateSyncData[0].ID != 1 || got.StateSyncData[1].ID != 2 {
		t.Fatalf("wrong state sync ids: got %d and %d", got.StateSyncData[0].ID, got.StateSyncData[1].ID)
	}
	if !bytes.Equal(got.StateSyncData[0].Data, []byte{0x01, 0x02, 0x03}) {
		t.Fatalf("wrong first state sync data: %x", got.StateSyncData[0].Data)
	}
}

func TestStateSyncTxSenderIsSystemless(t *testing.T) {
	tx := NewTx(&StateSyncTx{
		StateSyncData: []*StateSyncData{
			{
				ID:       1,
				Contract: common.HexToAddress("0x0000000000000000000000000000000000001111"),
				Data:     []byte{0xaa},
				TxHash:   common.HexToHash("0x01"),
			},
		},
	})
	signer := LatestSignerForChainID(big.NewInt(714))
	sender, err := Sender(signer, tx)
	if err != nil {
		t.Fatalf("sender lookup failed: %v", err)
	}
	if sender != (common.Address{}) {
		t.Fatalf("wrong sender: got %s want zero address", sender.Hex())
	}
}

func TestStateSyncReceiptRoundTrip(t *testing.T) {
	receipt := &Receipt{
		Type:              StateSyncTxType,
		Status:            ReceiptStatusSuccessful,
		CumulativeGasUsed: 99,
		TxHash:            common.HexToHash("0x1234"),
		GasUsed:           0,
		Logs: []*Log{
			{
				Address: common.HexToAddress("0x0000000000000000000000000000000000003333"),
				Topics:  []common.Hash{common.HexToHash("0x9999")},
				Data:    []byte{0x0a},
			},
		},
	}
	blob, err := rlp.EncodeToBytes(receipt)
	if err != nil {
		t.Fatalf("receipt encode failed: %v", err)
	}
	var decoded Receipt
	if err := rlp.DecodeBytes(blob, &decoded); err != nil {
		t.Fatalf("receipt decode failed: %v", err)
	}
	if decoded.Type != StateSyncTxType {
		t.Fatalf("wrong receipt type: got %d want %d", decoded.Type, StateSyncTxType)
	}
	if decoded.CumulativeGasUsed != 99 {
		t.Fatalf("wrong cumulative gas: got %d", decoded.CumulativeGasUsed)
	}
	if len(decoded.Logs) != 1 || decoded.Logs[0].Address != receipt.Logs[0].Address {
		t.Fatalf("receipt logs did not round-trip")
	}
}
