package planck

import _ "embed"

// contract codes for Mainnet upgrade
var (
	//go:embed mainnet/SlashContract
	MainnetSlashContract string
	//go:embed mainnet/TokenHubContract
	MainnetTokenHubContract string
	//go:embed mainnet/CrossChainContract
	MainnetCrossChainContract string
)

// contract codes for Testnet upgrade
var (
	//go:embed testnet/SlashContract
	ChapelSlashContract string
	//go:embed testnet/TokenHubContract
	ChapelTokenHubContract string
	//go:embed testnet/CrossChainContract
	ChapelCrossChainContract string
	//go:embed testnet/StakingContract
	ChapelStakingContract string
)
