package bohr

import _ "embed"

// contract codes for Mainnet upgrade
var (
	//go:embed mainnet/ValidatorContract
	MainnetValidatorContract string
	//go:embed mainnet/StakeHubContract
	MainnetStakeHubContract string
)

// contract codes for Testnet upgrade
var (
	//go:embed testnet/ValidatorContract
	ChapelValidatorContract string
	//go:embed testnet/StakeHubContract
	ChapelStakeHubContract string
)
