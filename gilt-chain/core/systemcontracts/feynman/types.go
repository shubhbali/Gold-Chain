package feynman

import _ "embed"

// contract codes for Mainnet upgrade
var (
	//go:embed mainnet/ValidatorContract
	MainnetValidatorContract string
	//go:embed mainnet/SlashContract
	MainnetSlashContract string
	//go:embed mainnet/TokenHubContract
	MainnetTokenHubContract string
	//go:embed mainnet/GovHubContract
	MainnetGovHubContract string
	//go:embed mainnet/CrossChainContract
	MainnetCrossChainContract string
	//go:embed mainnet/StakingContract
	MainnetStakingContract string
	//go:embed mainnet/StakeHubContract
	MainnetStakeHubContract string
	//go:embed mainnet/StakeCreditContract
	MainnetStakeCreditContract string
	//go:embed mainnet/GovernorContract
	MainnetGovernorContract string
	//go:embed mainnet/GovTokenContract
	MainnetGovTokenContract string
	//go:embed mainnet/TimelockContract
	MainnetTimelockContract string
	//go:embed mainnet/TokenRecoverPortalContract
	MainnetTokenRecoverPortalContract string
)

// contract codes for Testnet upgrade
var (
	//go:embed testnet/ValidatorContract
	ChapelValidatorContract string
	//go:embed testnet/SlashContract
	ChapelSlashContract string
	//go:embed testnet/TokenHubContract
	ChapelTokenHubContract string
	//go:embed testnet/GovHubContract
	ChapelGovHubContract string
	//go:embed testnet/CrossChainContract
	ChapelCrossChainContract string
	//go:embed testnet/StakingContract
	ChapelStakingContract string
	//go:embed testnet/StakeHubContract
	ChapelStakeHubContract string
	//go:embed testnet/StakeCreditContract
	ChapelStakeCreditContract string
	//go:embed testnet/GovernorContract
	ChapelGovernorContract string
	//go:embed testnet/GovTokenContract
	ChapelGovTokenContract string
	//go:embed testnet/TimelockContract
	ChapelTimelockContract string
	//go:embed testnet/TokenRecoverPortalContract
	ChapelTokenRecoverPortalContract string
)
