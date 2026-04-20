package kepler

import _ "embed"

// contract codes for Mainnet upgrade
var (
	//go:embed mainnet/ValidatorContract
	MainnetValidatorContract string
	//go:embed mainnet/SlashContract
	MainnetSlashContract string
	//go:embed mainnet/SystemRewardContract
	MainnetSystemRewardContract string
)

// contract codes for Testnet upgrade
var (
	//go:embed testnet/ValidatorContract
	ChapelValidatorContract string
	//go:embed testnet/SlashContract
	ChapelSlashContract string
	//go:embed testnet/SystemRewardContract
	ChapelSystemRewardContract string
)
