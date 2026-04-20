package types

import (
	"context"

	chainmanagertypes "github.com/giltchain/gilt-consensus/x/chainmanager/types"
)

// ChainKeeper defines the chain keeper contract used by x/clerk module
type ChainKeeper interface {
	GetParams(ctx context.Context) (chainmanagertypes.Params, error)
}
