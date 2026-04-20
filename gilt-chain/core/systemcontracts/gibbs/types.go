package gibbs

import _ "embed"

// contract codes for Testnet upgrade
var (
	//go:embed testnet/TokenHubContract
	ChapelTokenHubContract string
	//go:embed testnet/StakingContract
	ChapelStakingContract string
)

// contract codes for Mainnet upgrade
var (
	//go:embed mainnet/TokenHubContract
	MainnetTokenHubContract string
	//go:embed mainnet/StakingContract
	MainnetStakingContract string
)
