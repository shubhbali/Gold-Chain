package gilt

import (
	"context"

	giltTypes "github.com/giltchain/gilt-consensus/x/gilt/types"
	stakeTypes "github.com/giltchain/gilt-consensus/x/stake/types"

	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/consensus/gilt/valset"
	"github.com/ethereum/go-ethereum/core"
	"github.com/ethereum/go-ethereum/core/state"
	"github.com/ethereum/go-ethereum/core/types"
	"github.com/ethereum/go-ethereum/core/vm"
	"github.com/ethereum/go-ethereum/rpc"
)

//go:generate mockgen -destination=./span_mock.go -package=gilt . Spanner
type Spanner interface {
	GetCurrentSpan(ctx context.Context, headerHash common.Hash, state *state.StateDB) (*giltTypes.Span, error)
	GetCurrentValidatorsByHash(ctx context.Context, headerHash common.Hash, blockNumber uint64) ([]*valset.Validator, error)
	GetCurrentValidatorsByBlockNrOrHash(ctx context.Context, blockNrOrHash rpc.BlockNumberOrHash, blockNumber uint64) ([]*valset.Validator, error)
	CommitSpan(ctx context.Context, minimalSpan giltTypes.Span, validators, producers []stakeTypes.MinimalVal, state vm.StateDB, header *types.Header, chainContext core.ChainContext) error
}
