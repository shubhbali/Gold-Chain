package fermi

import _ "embed"

// contract codes for Mainnet upgrade
var (
	//go:embed mainnet/StakeHubContract
	MainnetStakeHubContract string
)

// contract codes for Testnet upgrade
var (
	//go:embed testnet/StakeHubContract
	ChapelStakeHubContract string
)

// contract codes for Rialto upgrade
var (
	//go:embed rialto/StakeHubContract
	RialtoStakeHubContract string
)
