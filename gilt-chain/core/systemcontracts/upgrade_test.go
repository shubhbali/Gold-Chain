package systemcontracts

import (
	"crypto/sha256"
	"math/big"
	"testing"

	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/core/state"
	"github.com/ethereum/go-ethereum/core/types"
	"github.com/ethereum/go-ethereum/core/vm"
	"github.com/ethereum/go-ethereum/params"
	"github.com/stretchr/testify/require"
)

func TestAllCodesHash(t *testing.T) {
	upgradesList := [13]map[string]*Upgrade{
		ramanujanUpgrade,
		nielsUpgrade,
		mirrorUpgrade,
		brunoUpgrade,
		eulerUpgrade,
		gibbsUpgrade,
		moranUpgrade,
		planckUpgrade,
		lubanUpgrade,
		platoUpgrade,
		keplerUpgrade,
		feynmanUpgrade,
		feynmanFixUpgrade}

	allCodes := make([]byte, 0, 10_000_000)
	for _, hardfork := range upgradesList {
		for _, network := range []string{mainNet, chapelNet} {
			allCodes = append(allCodes, []byte(network)...)
			if hardfork[network] != nil {
				for _, addressConfig := range hardfork[network].Configs {
					allCodes = append(allCodes, addressConfig.ContractAddr[:]...)
					allCodes = append(allCodes, addressConfig.Code[:]...)
				}
			}
		}
	}
	allCodeHash := sha256.Sum256(allCodes)
	require.Equal(t, allCodeHash[:], common.Hex2Bytes("b45e3c7531e0b041d5ce8fd42e4b0c21506134dcfebf503f1463d9ed739b1d55"))
}

func TestUpgradeBuildInSystemContractNilInterface(t *testing.T) {
	var (
		config               = params.GILTChainConfig
		blockNumber          = big.NewInt(37959559)
		lastBlockTime uint64 = 1713419337
		blockTime     uint64 = 1713419340
		statedb       vm.StateDB
	)

	GenesisHash = params.GILTGenesisHash

	upgradeBuildInSystemContract(config, blockNumber, lastBlockTime, blockTime, statedb)
}

func TestUpgradeBuildInSystemContractNilValue(t *testing.T) {
	var (
		config                   = params.GILTChainConfig
		blockNumber              = big.NewInt(37959559)
		lastBlockTime uint64     = 1713419337
		blockTime     uint64     = 1713419340
		statedb       vm.StateDB = (*state.StateDB)(nil)
	)

	GenesisHash = params.GILTGenesisHash

	upgradeBuildInSystemContract(config, blockNumber, lastBlockTime, blockTime, statedb)
}

func TestFinalGoldConfigSkipsHistoricalSystemContractUpgrades(t *testing.T) {
	oldGenesisHash := GenesisHash
	defer func() { GenesisHash = oldGenesisHash }()

	config := *params.GILTChainConfig
	require.True(t, config.DisableHistoricalSystemContractUpgrades)
	require.True(t, params.ChapelChainConfig.DisableHistoricalSystemContractUpgrades)
	GenesisHash = params.GILTGenesisHash

	statedb, err := state.New(types.EmptyRootHash, state.NewDatabaseForTesting())
	require.NoError(t, err)

	upgradeBuildInSystemContract(&config, big.NewInt(37959559), 1713419337, 1713419340, statedb)
	require.Empty(t, statedb.GetCode(common.HexToAddress(StakeHubContract)))
}

func TestHistoricalSystemContractUpgradesRemainExplicitlyAvailable(t *testing.T) {
	oldGenesisHash := GenesisHash
	defer func() { GenesisHash = oldGenesisHash }()

	config := *params.GILTChainConfig
	config.DisableHistoricalSystemContractUpgrades = false
	GenesisHash = params.GILTGenesisHash

	statedb, err := state.New(types.EmptyRootHash, state.NewDatabaseForTesting())
	require.NoError(t, err)

	upgradeBuildInSystemContract(&config, big.NewInt(37959559), 1713419337, 1713419340, statedb)
	require.NotEmpty(t, statedb.GetCode(common.HexToAddress(StakeHubContract)))
}
