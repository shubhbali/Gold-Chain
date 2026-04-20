package rawdb

import (
	"math/big"

	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/core/types"
	"github.com/ethereum/go-ethereum/ethdb"
	"github.com/ethereum/go-ethereum/log"
	"github.com/ethereum/go-ethereum/params"
	"github.com/ethereum/go-ethereum/rlp"
)

var (
	// gilt receipt key
	giltReceiptKey = types.GiltReceiptKey

	// giltTxLookupPrefix + hash -> transaction/receipt lookup metadata
	giltTxLookupPrefix = []byte(giltTxLookupPrefixStr)
)

const (
	giltTxLookupPrefixStr = "gilt-gilt-tx-lookup-"

	// freezerGiltReceiptTable indicates the name of the freezer gilt receipts table.
	freezerGiltReceiptTable = "gilt-gilt-receipts"
)

// giltTxLookupKey = giltTxLookupPrefix + gilt tx hash
func giltTxLookupKey(hash common.Hash) []byte {
	return append(giltTxLookupPrefix, hash.Bytes()...)
}

func ReadGiltReceiptRLP(db ethdb.Reader, hash common.Hash, number uint64) rlp.RawValue {
	var data []byte

	// First, try to fetch from KV db
	data, _ = db.Get(giltReceiptKey(number, hash))
	if len(data) != 0 {
		return data
	}

	err := db.ReadAncients(func(reader ethdb.AncientReaderOp) error {
		// Check if the data is in ancients
		if isCanon(reader, number, hash) {
			data, _ = reader.Ancient(freezerGiltReceiptTable, number)
			return nil
		}

		return nil
	})
	if err != nil {
		log.Warn("Unable to read gilt receipt rlp", "number", number, "hash", hash, "err", err)
	}

	return data
}

// ReadRawGiltReceipt retrieves the block receipt belonging to a block.
// The receipt metadata fields are not guaranteed to be populated, so they
// should not be used. Use ReadGiltReceipt instead if the metadata is needed.
func ReadRawGiltReceipt(db ethdb.Reader, hash common.Hash, number uint64) *types.Receipt {
	// Retrieve the flattened receipt slice
	data := ReadGiltReceiptRLP(db, hash, number)
	if len(data) == 0 {
		return nil
	}

	// Convert the receipts from their storage form to their internal representation
	var storageReceipt types.ReceiptForStorage
	if err := rlp.DecodeBytes(data, &storageReceipt); err != nil {
		log.Error("Invalid gilt receipt RLP", "hash", hash, "err", err)
		return nil
	}

	return (*types.Receipt)(&storageReceipt)
}

// ReadGiltReceipt retrieves all the gilt block receipts belonging to a block, including
// its corresponding metadata fields. If it is unable to populate these metadata
// fields then nil is returned.
func ReadGiltReceipt(db ethdb.Reader, hash common.Hash, number uint64, config *params.ChainConfig) *types.Receipt {
	if config != nil && config.Gilt != nil && config.Gilt.Sprint != nil && !config.Gilt.IsSprintStart(number) {
		return nil
	}

	// Fetch the raw gilt receipt for given block
	giltReceipt := ReadRawGiltReceipt(db, hash, number)
	if giltReceipt == nil {
		return nil
	}

	// Fetch normal receipts to derive certain fields for gilt receipts. Don't return if no
	// receipts are present as a block with only state-sync transaction can exist.
	receipts := ReadRawReceipts(db, hash, number)

	header := ReadHeader(db, hash, number)
	if header == nil {
		log.Error("Missing header but have gilt receipt", "hash", hash, "number", number)
		return nil
	}

	if err := types.DeriveFieldsForGiltReceipt(giltReceipt, receipts, header); err != nil {
		log.Error("Failed to derive gilt receipt fields", "hash", hash, "number", number, "err", err)
		return nil
	}

	return giltReceipt
}

// WriteGiltReceipt stores all the gilt receipt belonging to a block.
func WriteGiltReceipt(db ethdb.KeyValueWriter, hash common.Hash, number uint64, giltReceipt *types.ReceiptForStorage) {
	// Convert the gilt receipt into their storage form and serialize them
	bytes, err := rlp.EncodeToBytes(giltReceipt)
	if err != nil {
		log.Crit("Failed to encode gilt receipt", "err", err)
	}

	// Store the flattened receipt slice
	if err := db.Put(giltReceiptKey(number, hash), bytes); err != nil {
		log.Crit("Failed to store gilt receipt", "err", err)
	}
}

// DeleteGiltReceipt removes receipt data associated with a block hash.
func DeleteGiltReceipt(db ethdb.KeyValueWriter, hash common.Hash, number uint64) {
	key := giltReceiptKey(number, hash)

	if err := db.Delete(key); err != nil {
		log.Crit("Failed to delete gilt receipt", "err", err)
	}
}

// ReadGiltTransactionWithBlockHash retrieves a specific gilt (fake) transaction by tx hash and block hash, along with
// its added positional metadata.
func ReadGiltTransactionWithBlockHash(db ethdb.Reader, txHash common.Hash, blockHash common.Hash) (*types.Transaction, common.Hash, uint64, uint64) {
	blockNumber := ReadGiltTxLookupEntry(db, txHash)
	if blockNumber == nil {
		return nil, common.Hash{}, 0, 0
	}

	body := ReadBody(db, blockHash, *blockNumber)
	if body == nil {
		log.Error("Transaction referenced missing", "number", blockNumber, "hash", blockHash)
		return nil, common.Hash{}, 0, 0
	}

	// fetch receipt and return it
	return types.NewGiltTransaction(), blockHash, *blockNumber, uint64(len(body.Transactions))
}

// ReadGiltTransaction retrieves a specific gilt (fake) transaction by hash, along with
// its added positional metadata.
func ReadGiltTransaction(db ethdb.Reader, hash common.Hash) (*types.Transaction, common.Hash, uint64, uint64) {
	blockNumber := ReadGiltTxLookupEntry(db, hash)
	if blockNumber == nil {
		return nil, common.Hash{}, 0, 0
	}

	blockHash := ReadCanonicalHash(db, *blockNumber)
	if blockHash == (common.Hash{}) {
		return nil, common.Hash{}, 0, 0
	}

	body := ReadBody(db, blockHash, *blockNumber)
	if body == nil {
		log.Error("Transaction referenced missing", "number", blockNumber, "hash", blockHash)
		return nil, common.Hash{}, 0, 0
	}

	// fetch receipt and return it
	return types.NewGiltTransaction(), blockHash, *blockNumber, uint64(len(body.Transactions))
}

//
// Indexes for reverse lookup
//

// ReadGiltTxLookupEntry retrieves the positional metadata associated with a transaction
// hash to allow retrieving the gilt transaction or gilt receipt using tx hash.
func ReadGiltTxLookupEntry(db ethdb.Reader, txHash common.Hash) *uint64 {
	data, _ := db.Get(giltTxLookupKey(txHash))
	if len(data) == 0 {
		return nil
	}

	number := new(big.Int).SetBytes(data).Uint64()

	return &number
}

// WriteGiltTxLookupEntry stores a positional metadata for gilt transaction using block hash and block number
func WriteGiltTxLookupEntry(db ethdb.KeyValueWriter, hash common.Hash, number uint64) {
	txHash := types.GetDerivedGiltTxHash(giltReceiptKey(number, hash))
	if err := db.Put(giltTxLookupKey(txHash), big.NewInt(0).SetUint64(number).Bytes()); err != nil {
		log.Crit("Failed to store gilt transaction lookup entry", "err", err)
	}
}

// DeleteGiltTxLookupEntry removes gilt transaction data associated with block hash and block number
func DeleteGiltTxLookupEntry(db ethdb.KeyValueWriter, hash common.Hash, number uint64) {
	txHash := types.GetDerivedGiltTxHash(giltReceiptKey(number, hash))
	DeleteGiltTxLookupEntryByTxHash(db, txHash)
}

// DeleteGiltTxLookupEntryByTxHash removes gilt transaction data associated with a gilt tx hash.
func DeleteGiltTxLookupEntryByTxHash(db ethdb.KeyValueWriter, txHash common.Hash) {
	if err := db.Delete(giltTxLookupKey(txHash)); err != nil {
		log.Crit("Failed to delete gilt transaction lookup entry", "err", err)
	}
}
