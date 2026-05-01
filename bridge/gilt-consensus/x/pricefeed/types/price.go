package types

import (
	"fmt"

	sdkmath "cosmossdk.io/math"
)

var priceScaleInt = sdkmath.NewInt(PriceScale)

// ValidateBasic validates a price snapshot.
func (p PriceSnapshot) ValidateBasic() error {
	if p.Epoch == 0 {
		return fmt.Errorf("epoch must be positive")
	}
	if !p.GiltPriceInGold.IsPositive() {
		return fmt.Errorf("gilt_price_in_gold must be positive")
	}
	if err := validateAdapter(p.SourceAdapter); err != nil {
		return err
	}
	if p.ValidUntilEpoch < p.Epoch {
		return fmt.Errorf("valid_until_epoch cannot be before epoch")
	}

	return nil
}

// ExceedsDeviation returns true if next moves farther than maxDeviationBps from previous.
func ExceedsDeviation(previous sdkmath.Int, next sdkmath.Int, maxDeviationBps uint64) bool {
	if maxDeviationBps == 0 || !previous.IsPositive() {
		return false
	}
	diff := next.Sub(previous).Abs()
	deviation := diff.MulRaw(int64(BasisPoints)).Quo(previous)
	return deviation.GT(sdkmath.NewIntFromUint64(maxDeviationBps))
}

// ConvertGiltToGoldValue converts raw GILT amount to GOLD-denominated value using a 1e18-scaled price.
func ConvertGiltToGoldValue(giltAmount sdkmath.Int, giltPriceInGold sdkmath.Int) sdkmath.Int {
	if giltAmount.IsZero() || giltPriceInGold.IsZero() {
		return sdkmath.ZeroInt()
	}
	return giltAmount.Mul(giltPriceInGold).Quo(priceScaleInt)
}
