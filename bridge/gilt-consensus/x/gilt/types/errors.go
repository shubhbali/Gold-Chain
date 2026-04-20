package types

import "errors"

var (
	ErrInvalidChainID          = errors.New("invalid gilt chain id")
	ErrInvalidSpan             = errors.New("invalid span")
	ErrInvalidLastGiltSpanID    = errors.New("invalid last gilt span id")
	ErrInvalidSeedLength       = errors.New("invalid seed length")
	ErrFailedToQueryGilt        = errors.New("failed to query gilt")
	ErrLatestMilestoneNotFound = errors.New("latest milestone not found")
)
