package keeper

import (
	"bytes"
	"context"
	"fmt"

	"cosmossdk.io/collections"
	"cosmossdk.io/core/store"
	"cosmossdk.io/log"
	"github.com/cosmos/cosmos-sdk/codec"
	"github.com/cosmos/cosmos-sdk/codec/address"
	sdk "github.com/cosmos/cosmos-sdk/types"
	authtypes "github.com/cosmos/cosmos-sdk/x/auth/types"
	govtypes "github.com/cosmos/cosmos-sdk/x/gov/types"

	"github.com/giltchain/gilt-consensus/x/pricefeed/types"
)

// Keeper stores pricefeed params and accepted GILT/GOLD price snapshots.
type Keeper struct {
	cdc          codec.BinaryCodec
	storeService store.KVStoreService
	schema       collections.Schema
	params       collections.Item[types.Params]
	snapshots    collections.Map[uint64, types.PriceSnapshot]
	latestEpoch  collections.Item[uint64]
	authority    string
}

// NewKeeper creates a new pricefeed keeper.
func NewKeeper(cdc codec.BinaryCodec, storeService store.KVStoreService, authority string) Keeper {
	bz, err := address.NewHexCodec().StringToBytes(authority)
	if err != nil {
		panic(fmt.Errorf("invalid pricefeed authority address: %w", err))
	}
	if !bytes.Equal(bz, authtypes.NewModuleAddress(govtypes.ModuleName)) {
		panic(fmt.Errorf("invalid pricefeed authority address: %s", authority))
	}

	sb := collections.NewSchemaBuilder(storeService)
	k := Keeper{
		cdc:          cdc,
		storeService: storeService,
		params:       collections.NewItem(sb, types.ParamsKey, "params", codec.CollValue[types.Params](cdc)),
		snapshots:    collections.NewMap(sb, types.SnapshotKey, "price_snapshot", collections.Uint64Key, codec.CollValue[types.PriceSnapshot](cdc)),
		latestEpoch:  collections.NewItem(sb, types.LatestEpochKey, "latest_epoch", collections.Uint64Value),
		authority:    authority,
	}

	schema, err := sb.Build()
	if err != nil {
		panic(err)
	}
	k.schema = schema

	return k
}

// Logger returns a module-specific logger.
func (k Keeper) Logger(ctx context.Context) log.Logger {
	sdkCtx := sdk.UnwrapSDKContext(ctx)
	return sdkCtx.Logger().With("module", "x/"+types.ModuleName)
}

// GetAuthority returns the governance authority.
func (k Keeper) GetAuthority() string {
	return k.authority
}

// SetParams sets pricefeed params.
func (k Keeper) SetParams(ctx context.Context, params types.Params) error {
	if err := params.ValidateBasic(); err != nil {
		return err
	}
	return k.params.Set(ctx, params)
}

// GetParams returns pricefeed params.
func (k Keeper) GetParams(ctx context.Context) (types.Params, error) {
	params, err := k.params.Get(ctx)
	if err != nil {
		k.Logger(ctx).Error("Failed to get pricefeed params", "error", err)
		return types.Params{}, err
	}
	return params, nil
}

// SetPriceSnapshot stores an accepted price snapshot and marks it latest.
func (k Keeper) SetPriceSnapshot(ctx context.Context, snapshot types.PriceSnapshot) error {
	if err := snapshot.ValidateBasic(); err != nil {
		return err
	}
	params, err := k.GetParams(ctx)
	if err != nil {
		return err
	}
	if snapshot.SourceAdapter != params.ActiveAdapter {
		return fmt.Errorf("snapshot source %q does not match active adapter %q", snapshot.SourceAdapter, params.ActiveAdapter)
	}
	if params.AdapterRoute != "" && snapshot.AdapterRoute != params.AdapterRoute {
		return fmt.Errorf("snapshot route does not match active adapter route")
	}
	if latest, err := k.GetLatestPriceSnapshot(ctx); err == nil {
		if snapshot.Epoch <= latest.Epoch {
			return fmt.Errorf("price snapshot epoch must increase")
		}
		if types.ExceedsDeviation(latest.GiltPriceInGold, snapshot.GiltPriceInGold, params.MaxPriceDeviationBps) {
			return fmt.Errorf("price movement exceeds max_price_deviation_bps")
		}
	}

	sdkCtx := sdk.UnwrapSDKContext(ctx)
	if snapshot.BlockHeight == 0 {
		snapshot.BlockHeight = uint64(sdkCtx.BlockHeight())
	}

	if err := k.snapshots.Set(ctx, snapshot.Epoch, snapshot); err != nil {
		return err
	}
	return k.latestEpoch.Set(ctx, snapshot.Epoch)
}

// GetPriceSnapshot returns a price snapshot by epoch.
func (k Keeper) GetPriceSnapshot(ctx context.Context, epoch uint64) (types.PriceSnapshot, error) {
	snapshot, err := k.snapshots.Get(ctx, epoch)
	if err != nil {
		return types.PriceSnapshot{}, err
	}
	return snapshot, nil
}

// GetLatestPriceSnapshot returns the latest accepted price snapshot.
func (k Keeper) GetLatestPriceSnapshot(ctx context.Context) (types.PriceSnapshot, error) {
	epoch, err := k.latestEpoch.Get(ctx)
	if err != nil {
		return types.PriceSnapshot{}, types.ErrNoPrice.Wrap(err.Error())
	}
	return k.GetPriceSnapshot(ctx, epoch)
}

// IsLatestPriceFresh checks max age against current block height.
func (k Keeper) IsLatestPriceFresh(ctx context.Context) (bool, error) {
	params, err := k.GetParams(ctx)
	if err != nil {
		return false, err
	}
	snapshot, err := k.GetLatestPriceSnapshot(ctx)
	if err != nil {
		return false, err
	}
	sdkCtx := sdk.UnwrapSDKContext(ctx)
	currentHeight := uint64(sdkCtx.BlockHeight())
	if currentHeight < snapshot.BlockHeight {
		return false, nil
	}
	return currentHeight <= snapshot.BlockHeight+params.MaxPriceAgeBlocks, nil
}

// IteratePriceSnapshots iterates all stored price snapshots.
func (k Keeper) IteratePriceSnapshots(ctx context.Context, f func(types.PriceSnapshot) error) error {
	iterator, err := k.snapshots.Iterate(ctx, nil)
	if err != nil {
		return err
	}
	defer func() {
		if err := iterator.Close(); err != nil {
			k.Logger(ctx).Error("Error closing price snapshot iterator", "error", err)
		}
	}()

	for ; iterator.Valid(); iterator.Next() {
		snapshot, err := iterator.Value()
		if err != nil {
			return err
		}
		if err := f(snapshot); err != nil {
			return err
		}
	}

	return nil
}
