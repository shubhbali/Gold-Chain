package types

import (
	"encoding/binary"
	"math/big"
	"sort"

	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/crypto"
	"github.com/ethereum/go-ethereum/params"
)

// TenToTheFive - To be used while sorting gilt logs
//
// Sorted using ( blockNumber * (10 ** 5) + logIndex )
const TenToTheFive uint64 = 100000

var (
	giltReceiptPrefix = []byte("gilt-gilt-receipt-") // giltReceiptPrefix + number + block hash -> gilt block receipt

	// SystemAddress address for system sender
	SystemAddress = common.HexToAddress("0xffffFFFfFFffffffffffffffFfFFFfffFFFfFFfE")
)

// GiltReceiptKey = giltReceiptPrefix + num (uint64 big endian) + hash
func GiltReceiptKey(number uint64, hash common.Hash) []byte {
	enc := make([]byte, 8)
	binary.BigEndian.PutUint64(enc, number)

	return append(append(giltReceiptPrefix, enc...), hash.Bytes()...)
}

// GetDerivedGiltTxHash get derived tx hash from receipt key
func GetDerivedGiltTxHash(receiptKey []byte) common.Hash {
	return common.BytesToHash(crypto.Keccak256(receiptKey))
}

// NewGiltTransaction create new gilt transaction for gilt receipt
func NewGiltTransaction() *Transaction {
	return NewTransaction(0, common.Address{}, big.NewInt(0), 0, big.NewInt(0), make([]byte, 0))
}

// DeriveFieldsForGiltReceipt fills the receipts with their computed fields based on consensus
// data and contextual infos like containing block and transactions.
func DeriveFieldsForGiltReceipt(receipt *Receipt, receipts Receipts, header *Header) error {
	// get derived tx hash
	number := header.Number.Uint64()
	hash := header.Hash()
	txHash := GetDerivedGiltTxHash(GiltReceiptKey(number, hash))
	txIndex := uint(len(receipts))

	// set tx hash and tx index
	receipt.TxHash = txHash
	receipt.TransactionIndex = txIndex
	receipt.BlockHash = hash
	receipt.BlockNumber = big.NewInt(0).SetUint64(number)

	logIndex := 0
	for i := 0; i < len(receipts); i++ {
		logIndex += len(receipts[i].Logs)
	}

	if len(receipts) > 0 {
		receipt.CumulativeGasUsed = receipts[len(receipts)-1].CumulativeGasUsed
	}

	// The derived log fields can simply be set from the block and transaction
	for j := 0; j < len(receipt.Logs); j++ {
		receipt.Logs[j].BlockNumber = number
		receipt.Logs[j].BlockHash = hash
		receipt.Logs[j].BlockTimestamp = header.Time
		receipt.Logs[j].TxHash = txHash
		receipt.Logs[j].TxIndex = txIndex
		receipt.Logs[j].Index = uint(logIndex)
		logIndex++
	}

	// Also derive the Bloom if not derived yet
	receipt.Bloom = CreateBloom(receipt)

	return nil
}

// DeriveFieldsForGiltLogs fills the receipts with their computed fields based on consensus
// data and contextual infos like containing block and transactions.
func DeriveFieldsForGiltLogs(logs []*Log, hash common.Hash, number uint64, txIndex uint, logIndex uint) {
	// get derived tx hash
	txHash := GetDerivedGiltTxHash(GiltReceiptKey(number, hash))

	// the derived log fields can simply be set from the block and transaction
	for j := 0; j < len(logs); j++ {
		logs[j].BlockNumber = number
		logs[j].BlockHash = hash
		logs[j].TxHash = txHash
		logs[j].TxIndex = txIndex
		logs[j].Index = logIndex
		logIndex++
	}
}

// MergeGiltLogs merges receipt logs and block receipt logs
func MergeGiltLogs(logs []*Log, giltLogs []*Log) []*Log {
	result := append(logs, giltLogs...)

	sort.SliceStable(result, func(i int, j int) bool {
		return (result[i].BlockNumber*TenToTheFive + uint64(result[i].Index)) < (result[j].BlockNumber*TenToTheFive + uint64(result[j].Index))
	})

	return result
}

func IsSprintEndBlock(giltCfg *params.GiltConfig, number uint64) bool {
	if giltCfg == nil {
		return false
	}
	if number%giltCfg.CalculateSprint(number) == 0 {
		return true
	}
	return false
}
