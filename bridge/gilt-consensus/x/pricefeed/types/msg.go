package types

import sdk "github.com/cosmos/cosmos-sdk/types"

var (
	_ sdk.Msg = &MsgUpdateParams{}
	_ sdk.Msg = &MsgSetPriceSnapshot{}
	_ sdk.Msg = &MsgScheduleAdapterUpdate{}
	_ sdk.Msg = &MsgActivateAdapterUpdate{}
)

// ValidateBasic validates MsgUpdateParams.
func (msg MsgUpdateParams) ValidateBasic() error {
	if msg.Authority == "" {
		return ErrUnauthorized.Wrap("authority is required")
	}
	if err := msg.Params.ValidateBasic(); err != nil {
		return ErrInvalidParams.Wrap(err.Error())
	}
	return nil
}

// ValidateBasic validates MsgSetPriceSnapshot.
func (msg MsgSetPriceSnapshot) ValidateBasic() error {
	if msg.Authority == "" {
		return ErrUnauthorized.Wrap("authority is required")
	}
	if err := msg.Price.ValidateBasic(); err != nil {
		return ErrInvalidPrice.Wrap(err.Error())
	}
	return nil
}

// ValidateBasic validates MsgScheduleAdapterUpdate.
func (msg MsgScheduleAdapterUpdate) ValidateBasic() error {
	if msg.Authority == "" {
		return ErrUnauthorized.Wrap("authority is required")
	}
	if err := validateAdapter(msg.Adapter); err != nil {
		return ErrInvalidParams.Wrap(err.Error())
	}
	if msg.ActivationHeight == 0 {
		return ErrInvalidParams.Wrap("activation_height must be positive")
	}
	return nil
}

// ValidateBasic validates MsgActivateAdapterUpdate.
func (msg MsgActivateAdapterUpdate) ValidateBasic() error {
	if msg.Authority == "" {
		return ErrUnauthorized.Wrap("authority is required")
	}
	return nil
}
