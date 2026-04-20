package types

import (
	"context"

	hmTypes "github.com/giltchain/gilt-consensus/types"
	cmTypes "github.com/giltchain/gilt-consensus/x/chainmanager/types"
	stakeTypes "github.com/giltchain/gilt-consensus/x/stake/types"
)

type TopupKeeper interface {
	GetAllDividendAccounts(ctx context.Context) ([]hmTypes.DividendAccount, error)
}

type StakeKeeper interface {
	GetValidatorSet(ctx context.Context) (validatorSet stakeTypes.ValidatorSet, err error)
	GetCurrentProposer(ctx context.Context) *stakeTypes.Validator
	IncrementAccum(ctx context.Context, times int) error
}

type ChainManagerKeeper interface {
	GetParams(ctx context.Context) (cmTypes.Params, error)
}
