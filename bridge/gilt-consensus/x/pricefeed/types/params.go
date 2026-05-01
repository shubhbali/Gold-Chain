package types

import (
	"fmt"

	sdkmath "cosmossdk.io/math"
)

const (
	DefaultTwapWindowSeconds  uint64 = 3600
	DefaultTargetGiltShareBps uint64 = 1000
	DefaultMinGoldWeightBps   uint64 = 6000
	DefaultMaxGoldWeightBps   uint64 = 10000
	DefaultMaxDeviationBps    uint64 = 2500
	DefaultMaxPriceAgeBlocks  uint64 = 3600
)

// DefaultParams returns the default pricefeed configuration.
func DefaultParams() Params {
	return Params{
		ActiveAdapter:           AdapterManual,
		AdapterRoute:            "",
		PendingAdapter:          "",
		PendingAdapterRoute:     "",
		PendingActivationHeight: 0,
		TwapWindowSeconds:       DefaultTwapWindowSeconds,
		MinLiquidity:            sdkmath.ZeroInt(),
		MaxPriceDeviationBps:    DefaultMaxDeviationBps,
		TargetGiltShareBps:      DefaultTargetGiltShareBps,
		MinGoldWeightBps:        DefaultMinGoldWeightBps,
		MaxGoldWeightBps:        DefaultMaxGoldWeightBps,
		MaxPriceAgeBlocks:       DefaultMaxPriceAgeBlocks,
	}
}

// ValidateBasic validates pricefeed parameters.
func (p Params) ValidateBasic() error {
	if err := validateAdapter(p.ActiveAdapter); err != nil {
		return err
	}
	if p.PendingAdapter != "" {
		if err := validateAdapter(p.PendingAdapter); err != nil {
			return err
		}
		if p.PendingActivationHeight == 0 {
			return fmt.Errorf("pending_activation_height must be set when pending_adapter is set")
		}
	}
	if p.TwapWindowSeconds == 0 {
		return fmt.Errorf("twap_window_seconds must be positive")
	}
	if p.MinLiquidity.IsNegative() {
		return fmt.Errorf("min_liquidity cannot be negative")
	}
	if p.MaxPriceDeviationBps > BasisPoints {
		return fmt.Errorf("max_price_deviation_bps cannot exceed %d", BasisPoints)
	}
	if p.TargetGiltShareBps > BasisPoints {
		return fmt.Errorf("target_gilt_share_bps cannot exceed %d", BasisPoints)
	}
	if p.MinGoldWeightBps > BasisPoints {
		return fmt.Errorf("min_gold_weight_bps cannot exceed %d", BasisPoints)
	}
	if p.MaxGoldWeightBps > BasisPoints {
		return fmt.Errorf("max_gold_weight_bps cannot exceed %d", BasisPoints)
	}
	if p.MinGoldWeightBps > p.MaxGoldWeightBps {
		return fmt.Errorf("min_gold_weight_bps cannot exceed max_gold_weight_bps")
	}
	if p.MaxPriceAgeBlocks == 0 {
		return fmt.Errorf("max_price_age_blocks must be positive")
	}

	return nil
}

// ValidateDirectUpdateFrom prevents governance param updates from bypassing the scheduled adapter switch flow.
func (p Params) ValidateDirectUpdateFrom(current Params) error {
	if p.ActiveAdapter != current.ActiveAdapter {
		return fmt.Errorf("active_adapter must be changed with ScheduleAdapterUpdate and ActivateAdapterUpdate")
	}
	if p.AdapterRoute != current.AdapterRoute {
		return fmt.Errorf("adapter_route must be changed with ScheduleAdapterUpdate and ActivateAdapterUpdate")
	}
	if p.PendingAdapter != current.PendingAdapter {
		return fmt.Errorf("pending_adapter must be changed with ScheduleAdapterUpdate")
	}
	if p.PendingAdapterRoute != current.PendingAdapterRoute {
		return fmt.Errorf("pending_adapter_route must be changed with ScheduleAdapterUpdate")
	}
	if p.PendingActivationHeight != current.PendingActivationHeight {
		return fmt.Errorf("pending_activation_height must be changed with ScheduleAdapterUpdate")
	}
	return nil
}

func validateAdapter(adapter string) error {
	switch adapter {
	case AdapterManual, AdapterDexTwap:
		return nil
	default:
		return fmt.Errorf("unsupported adapter %q", adapter)
	}
}
