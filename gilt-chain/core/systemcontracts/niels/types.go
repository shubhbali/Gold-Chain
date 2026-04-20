package niels

import _ "embed"

// contract codes for Testnet upgrade
var (
	//go:embed testnet/ValidatorContract
	ChapelValidatorContract string
	//go:embed testnet/SlashContract
	ChapelSlashContract string
	//go:embed testnet/SystemRewardContract
	ChapelSystemRewardContract string
	//go:embed testnet/LightClientContract
	ChapelLightClientContract string
	//go:embed testnet/TokenHubContract
	ChapelTokenHubContract string
	//go:embed testnet/RelayerIncentivizeContract
	ChapelRelayerIncentivizeContract string
	//go:embed testnet/RelayerHubContract
	ChapelRelayerHubContract string
	//go:embed testnet/GovHubContract
	ChapelGovHubContract string
	//go:embed testnet/TokenManagerContract
	ChapelTokenManagerContract string
	//go:embed testnet/CrossChainContract
	ChapelCrossChainContract string
)
