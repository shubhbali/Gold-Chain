package types

import errorsmod "cosmossdk.io/errors"

var (
	ErrInvalidParams       = errorsmod.Register(ModuleName, 2, "invalid params")
	ErrInvalidPrice        = errorsmod.Register(ModuleName, 3, "invalid price")
	ErrUnauthorized        = errorsmod.Register(ModuleName, 4, "unauthorized")
	ErrNoPrice             = errorsmod.Register(ModuleName, 5, "no price snapshot")
	ErrNoPendingAdapter    = errorsmod.Register(ModuleName, 6, "no pending adapter")
	ErrAdapterNotActivated = errorsmod.Register(ModuleName, 7, "adapter activation height not reached")
)
