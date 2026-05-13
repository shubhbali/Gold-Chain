package keeper

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"time"

	"cosmossdk.io/collections"

	"github.com/giltchain/gilt-consensus/x/clerk/types"
)

func (k Keeper) lifecycleNow(now time.Time) time.Time {
	if now.IsZero() {
		return time.Unix(0, 0).UTC()
	}
	return now.UTC()
}

func (k Keeper) getBridgeLifecycleByKey(ctx context.Context, key string) (*types.BridgeLifecycleRecord, error) {
	payload, err := k.BridgeLifecycle.Get(ctx, key)
	if err != nil {
		return nil, err
	}

	var record types.BridgeLifecycleRecord
	if err := json.Unmarshal(payload, &record); err != nil {
		return nil, fmt.Errorf("failed to unmarshal lifecycle record %q: %w", key, err)
	}

	return &record, nil
}

func (k Keeper) GetBridgeLifecycleByID(ctx context.Context, stateID uint64) (*types.BridgeLifecycleRecord, error) {
	key, err := k.BridgeLifecycleByID.Get(ctx, stateID)
	if err != nil {
		return nil, err
	}
	return k.getBridgeLifecycleByKey(ctx, key)
}

func (k Keeper) HasBridgeLifecycleByID(ctx context.Context, stateID uint64) bool {
	present, _ := k.BridgeLifecycleByID.Has(ctx, stateID)
	return present
}

func (k Keeper) HasBridgeLifecycleByKey(ctx context.Context, key string) bool {
	present, _ := k.BridgeLifecycle.Has(ctx, key)
	return present
}

func (k Keeper) SetBridgeLifecycleState(
	ctx context.Context,
	sourceChainID string,
	txHash string,
	logIndex uint64,
	stateID uint64,
	nextState string,
	failureReason string,
	now time.Time,
) error {
	key := types.BridgeLifecycleCompositeKey(sourceChainID, txHash, logIndex, stateID)
	now = k.lifecycleNow(now)

	record, err := k.getBridgeLifecycleByKey(ctx, key)
	if err != nil {
		if !errors.Is(err, collections.ErrNotFound) {
			return err
		}

		if err := types.ValidateBridgeLifecycleTransition("", nextState); err != nil {
			return err
		}

		record = &types.BridgeLifecycleRecord{
			SourceChainID:   types.CanonicalChainID(sourceChainID),
			TxHash:          types.CanonicalTxHash(txHash),
			LogIndex:        logIndex,
			StateID:         stateID,
			LifecycleState:  nextState,
			FailureReason:   failureReason,
			CreatedAt:       now,
			UpdatedAt:       now,
			TransitionCount: 1,
		}
	} else {
		if record.LifecycleState == nextState {
			// idempotent write; refresh timestamp and reason only when provided
			record.UpdatedAt = now
			if failureReason != "" {
				record.FailureReason = failureReason
			}
		} else {
			if err := types.ValidateBridgeLifecycleTransition(record.LifecycleState, nextState); err != nil {
				return err
			}

			record.LifecycleState = nextState
			record.FailureReason = failureReason
			record.UpdatedAt = now
			record.TransitionCount++
		}
	}

	encoded, err := json.Marshal(record)
	if err != nil {
		return fmt.Errorf("failed to marshal lifecycle record %q: %w", key, err)
	}
	if err := k.BridgeLifecycle.Set(ctx, key, encoded); err != nil {
		return err
	}

	indexKey, indexErr := k.BridgeLifecycleByID.Get(ctx, stateID)
	if indexErr != nil {
		if !errors.Is(indexErr, collections.ErrNotFound) {
			return indexErr
		}
		return k.BridgeLifecycleByID.Set(ctx, stateID, key)
	}
	if indexKey != key {
		return fmt.Errorf("lifecycle state id %d already linked to a different key", stateID)
	}

	return nil
}

func (k Keeper) EnsureBridgeLifecyclePending(
	ctx context.Context,
	sourceChainID string,
	txHash string,
	logIndex uint64,
	stateID uint64,
	now time.Time,
) error {
	key := types.BridgeLifecycleCompositeKey(sourceChainID, txHash, logIndex, stateID)
	if !k.HasBridgeLifecycleByKey(ctx, key) {
		if err := k.SetBridgeLifecycleState(
			ctx, sourceChainID, txHash, logIndex, stateID, types.BridgeLifecycleSeen, "", now,
		); err != nil {
			return err
		}
	}

	record, err := k.getBridgeLifecycleByKey(ctx, key)
	if err != nil {
		return err
	}
	if record.LifecycleState == types.BridgeLifecycleSeen {
		return k.SetBridgeLifecycleState(
			ctx, sourceChainID, txHash, logIndex, stateID, types.BridgeLifecyclePending, "", now,
		)
	}

	return nil
}

func (k Keeper) ListBridgeLifecycleByStateID(
	ctx context.Context,
	fromStateID uint64,
	limit uint64,
) ([]types.BridgeLifecycleRecord, error) {
	if limit == 0 {
		return []types.BridgeLifecycleRecord{}, nil
	}

	rng := (&collections.Range[uint64]{}).StartInclusive(fromStateID)
	iterator, err := k.BridgeLifecycleByID.Iterate(ctx, rng)
	if err != nil {
		return nil, err
	}
	defer func() {
		_ = iterator.Close()
	}()

	records := make([]types.BridgeLifecycleRecord, 0, limit)
	for ; iterator.Valid(); iterator.Next() {
		if uint64(len(records)) >= limit {
			break
		}

		key, err := iterator.Value()
		if err != nil {
			return nil, err
		}

		record, err := k.getBridgeLifecycleByKey(ctx, key)
		if err != nil {
			return nil, err
		}

		records = append(records, *record)
	}

	return records, nil
}
