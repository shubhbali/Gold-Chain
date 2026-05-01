package types

import (
	"fmt"

	hexCodec "github.com/cosmos/cosmos-sdk/codec/address"
	sdk "github.com/cosmos/cosmos-sdk/types"

	util "github.com/giltchain/gilt-consensus/common/hex"
)

// ValidateBasic validates a GOLD delegation record.
func (d GoldDelegation) ValidateBasic() error {
	if d.ValId == 0 {
		return fmt.Errorf("validator id must be positive")
	}
	if !d.Amount.IsPositive() {
		return fmt.Errorf("GOLD delegation amount must be positive")
	}

	ac := hexCodec.NewHexCodec()
	addrBytes, err := ac.StringToBytes(d.Delegator)
	if err != nil {
		return fmt.Errorf("invalid delegator address: %w", err)
	}
	if sdk.AccAddress(addrBytes).Empty() {
		return fmt.Errorf("delegator address cannot be empty")
	}

	return nil
}

// Normalize standardizes the delegation address and Int fields before storage.
func (d *GoldDelegation) Normalize() {
	d.Delegator = util.FormatAddress(d.Delegator)
	d.Amount = normalizeInt(d.Amount)
}
