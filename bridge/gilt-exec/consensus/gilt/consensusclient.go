package gilt

import (
	"context"

	"github.com/ethereum/go-ethereum/consensus/gilt/clerk"
	"github.com/ethereum/go-ethereum/consensus/gilt/consensusclient/checkpoint"
	"github.com/ethereum/go-ethereum/consensus/gilt/consensusclient/milestone"

	"github.com/giltchain/gilt-consensus/x/gilt/types"
	ctypes "github.com/cometbft/cometbft/rpc/core/types"
)

//go:generate mockgen -source=consensusclient.go -destination=../../tests/gilt/mocks/IGiltConsensusClient.go -package=mocks
type IGiltConsensusClient interface {
	StateSyncEvents(ctx context.Context, fromID uint64, to int64) ([]*clerk.EventRecordWithTime, error)
	GetSpan(ctx context.Context, spanID uint64) (*types.Span, error)
	GetLatestSpan(ctx context.Context) (*types.Span, error)
	FetchCheckpoint(ctx context.Context, number int64) (*checkpoint.Checkpoint, error)
	FetchCheckpointCount(ctx context.Context) (int64, error)
	FetchMilestone(ctx context.Context) (*milestone.Milestone, error)
	FetchMilestoneCount(ctx context.Context) (int64, error)
	FetchStatus(ctx context.Context) (*ctypes.SyncInfo, error)
	Close()
}

type IGiltConsensusWSClient interface {
	SubscribeMilestoneEvents(ctx context.Context) <-chan *milestone.Milestone
	Unsubscribe(ctx context.Context) error
	Close() error
}
