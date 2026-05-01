package types

import (
	"context"

	sdk "github.com/cosmos/cosmos-sdk/types"

	pricefeedtypes "github.com/giltchain/gilt-consensus/x/pricefeed/types"
)

// CheckpointKeeper defines the checkpoint keeper contract used by x/stake module
type CheckpointKeeper interface {
	GetAckCount(ctx context.Context) (uint64, error)
}

type BankKeeper interface {
	GetBalance(ctx context.Context, addr sdk.AccAddress, denom string) sdk.Coin
	SendCoins(ctx context.Context, fromAddr, toAddr sdk.AccAddress, amt sdk.Coins) error
	SendCoinsFromAccountToModule(ctx context.Context, senderAddr sdk.AccAddress, recipientModule string, amt sdk.Coins) error
	SendCoinsFromModuleToAccount(ctx context.Context, senderModule string, recipientAddr sdk.AccAddress, amt sdk.Coins) error
}

// PricefeedKeeper defines the pricefeed keeper contract used by x/stake.
type PricefeedKeeper interface {
	GetParams(ctx context.Context) (pricefeedtypes.Params, error)
	GetLatestPriceSnapshot(ctx context.Context) (pricefeedtypes.PriceSnapshot, error)
	IsLatestPriceFresh(ctx context.Context) (bool, error)
}
