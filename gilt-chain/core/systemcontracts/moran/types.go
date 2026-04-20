package moran

import _ "embed"

// contract codes for Mainnet upgrade
var (
	//go:embed mainnet/RelayerHubContract
	MainnetRelayerHubContract string
	//go:embed mainnet/LightClientContract
	MainnetLightClientContract string
	//go:embed mainnet/CrossChainContract
	MainnetCrossChainContract string
)

// contract codes for Testnet upgrade
var (
	//go:embed testnet/RelayerHubContract
	ChapelRelayerHubContract string
	//go:embed testnet/LightClientContract
	ChapelLightClientContract string
	//go:embed testnet/CrossChainContract
	ChapelCrossChainContract string
)
