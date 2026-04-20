package mirror

import _ "embed"

// contract codes for Mainnet upgrade
var (
	//go:embed mainnet/TokenManagerContract
	MainnetTokenManagerContract string
	//go:embed mainnet/TokenHubContract
	MainnetTokenHubContract string
	//go:embed mainnet/RelayerIncentivizeContract
	MainnetRelayerIncentivizeContract string
)

// contract codes for Testnet upgrade
var (
	//go:embed testnet/TokenManagerContract
	ChapelTokenManagerContract string
	//go:embed testnet/TokenHubContract
	ChapelTokenHubContract string
	//go:embed testnet/RelayerIncentivizeContract
	ChapelRelayerIncentivizeContract string
)
