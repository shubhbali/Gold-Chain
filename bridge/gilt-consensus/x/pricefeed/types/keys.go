package types

import "cosmossdk.io/collections"

const (
	// ModuleName is the name of the pricefeed module.
	ModuleName = "pricefeed"

	// StoreKey is the store key string for pricefeed.
	StoreKey = ModuleName

	// RouterKey is the message route for pricefeed.
	RouterKey = ModuleName
)

var (
	ParamsKey      = collections.NewPrefix(0)
	SnapshotKey    = collections.NewPrefix(1)
	LatestEpochKey = collections.NewPrefix(2)
)

const (
	AdapterManual  = "manual"
	AdapterDexTwap = "dex_twap"
)

const (
	BasisPoints = uint64(10_000)
	PriceScale  = int64(1_000_000_000_000_000_000)
)
