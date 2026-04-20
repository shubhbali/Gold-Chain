package feynman_fix

import _ "embed"

// contract codes for Testnet upgrade
var (
	//go:embed testnet/ValidatorContract
	ChapelValidatorContract string
	//go:embed testnet/StakeHubContract
	ChapelStakeHubContract string
)
