package core

import (
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/core/rawdb"
	"github.com/ethereum/go-ethereum/core/types"
	"github.com/ethereum/go-ethereum/metrics"
	"github.com/ethereum/go-ethereum/rlp"
)

var (
	giltReceiptsCacheHit     = metrics.NewRegisteredGauge("gilt/receipts/cache/hit", nil)
	giltReceiptsCacheMiss    = metrics.NewRegisteredGauge("gilt/receipts/cache/miss", nil)
	giltReceiptsRLPCacheHit  = metrics.NewRegisteredGauge("gilt/rlpreceipts/cache/hit", nil)
	giltReceiptsRLPCacheMiss = metrics.NewRegisteredGauge("gilt/rlpreceipts/cache/miss", nil)
)

// GetGiltReceiptByHash retrieves the gilt block receipt in a given block.
func (bc *BlockChain) GetGiltReceiptByHash(hash common.Hash) *types.Receipt {
	if receipt, ok := bc.giltReceiptsCache.Get(hash); ok {
		giltReceiptsCacheHit.Update(1)
		return receipt
	}
	giltReceiptsCacheMiss.Update(1)

	// read header from hash
	number, found := rawdb.ReadHeaderNumber(bc.db, hash)
	if !found {
		return nil
	}

	// read gilt receipt by hash and number
	receipt := rawdb.ReadGiltReceipt(bc.db, hash, number, bc.chainConfig)
	if receipt == nil {
		return nil
	}

	// add into gilt receipt cache
	bc.giltReceiptsCache.Add(hash, receipt)

	return receipt
}

// GetGiltReceiptRLPByHash retrieves the gilt block receipt RLP in a given block.
func (bc *BlockChain) GetGiltReceiptRLPByHash(hash common.Hash) rlp.RawValue {
	if receiptRLP, ok := bc.giltReceiptsRLPCache.Get(hash); ok {
		giltReceiptsRLPCacheHit.Update(1)
		return receiptRLP
	}
	giltReceiptsRLPCacheMiss.Update(1)

	// read header from hash
	number, found := rawdb.ReadHeaderNumber(bc.db, hash)
	if !found {
		return nil
	}

	// read gilt receipt RLP by hash and number
	receiptRLP := rawdb.ReadGiltReceiptRLP(bc.db, hash, number)
	if receiptRLP == nil {
		return nil
	}

	// add into gilt receipt RLP cache
	bc.giltReceiptsRLPCache.Add(hash, receiptRLP)

	return receiptRLP
}
