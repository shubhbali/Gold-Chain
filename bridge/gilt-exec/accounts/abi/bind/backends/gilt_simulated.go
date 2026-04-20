package backends

import (
	"context"

	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/core"
	"github.com/ethereum/go-ethereum/core/rawdb"
	"github.com/ethereum/go-ethereum/core/types"
	"github.com/ethereum/go-ethereum/event"
)

func (fb *filterBackend) GetGiltBlockReceipt(_ context.Context, hash common.Hash) (*types.Receipt, error) {
	number, found := rawdb.ReadHeaderNumber(fb.db, hash)
	if !found {
		return nil, nil
	}

	receipt := rawdb.ReadRawGiltReceipt(fb.db, hash, number)
	if receipt == nil {
		return nil, nil
	}

	return receipt, nil
}

func (fb *filterBackend) GetVoteOnHash(_ context.Context, _ uint64, _ uint64, _ string, _ string) (bool, error) {
	return false, nil
}

func (fb *filterBackend) GetGiltBlockLogs(ctx context.Context, hash common.Hash) ([]*types.Log, error) {
	receipt, err := fb.GetGiltBlockReceipt(ctx, hash)
	if err != nil || receipt == nil {
		return nil, err
	}

	return receipt.Logs, nil
}

// SubscribeStateSyncEvent subscribes to state sync events
func (fb *filterBackend) SubscribeStateSyncEvent(ch chan<- core.StateSyncEvent) event.Subscription {
	return fb.bc.SubscribeStateSyncEvent(ch)
}
