package types

import (
	"context"

	chainmanagertypes "github.com/giltchain/gilt-consensus/x/chainmanager/types"
	milestonetypes "github.com/giltchain/gilt-consensus/x/milestone/types"
	staketypes "github.com/giltchain/gilt-consensus/x/stake/types"
)

type StakeKeeper interface {
	GetSpanEligibleValidators(ctx context.Context) []staketypes.Validator
	GetValidatorSet(ctx context.Context) (staketypes.ValidatorSet, error)
	GetValidatorFromValID(ctx context.Context, valID uint64) (staketypes.Validator, error)
	GetValIdFromAddress(ctx context.Context, address string) (uint64, error)
}

type ChainManagerKeeper interface {
	GetParams(ctx context.Context) (chainmanagertypes.Params, error)
}

type MilestoneKeeper interface {
	GetLastMilestone(ctx context.Context) (*milestonetypes.Milestone, error)
}
