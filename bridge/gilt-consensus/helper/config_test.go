package helper

import (
	"fmt"
	"testing"

	cfg "github.com/cometbft/cometbft/config"
	"github.com/cosmos/cosmos-sdk/client/flags"
	"github.com/spf13/viper"
)

// TestGiltConsensusConfig checks giltconsensus configs
func TestGiltConsensusConfig(t *testing.T) {
	t.Parallel()

	// cli context
	cometBFTNode := "tcp://localhost:26657"
	viper.Set(CometBFTNodeFlag, cometBFTNode)
	viper.Set(flags.FlagLogLevel, "info")

	InitTestGiltConsensusConfig("")

	fmt.Println("Address", GetAddress())

	pubKey := GetPubKey()

	fmt.Println("PublicKey", pubKey.String())
}

func TestGiltConsensusConfigUpdateCometBFTConfig(t *testing.T) {
	t.Parallel()

	type testStruct struct {
		chain string
		viper string
		def   string
		value string
	}

	data := []testStruct{
		{chain: TestnetChain, viper: "viper", def: "default", value: "viper"},
		{chain: TestnetChain, viper: "viper", def: "", value: "viper"},
		{chain: TestnetChain, viper: "", def: "default", value: "default"},
		{chain: TestnetChain, viper: "viper", def: "default", value: "viper"},
		{chain: TestnetChain, viper: "viper", def: "", value: "viper"},
		{chain: TestnetChain, viper: "", def: "default", value: "default"},
		{chain: TestnetChain, viper: "", def: "", value: DefaultGiltTestnetTestnetSeeds},
		{chain: "mainnet", viper: "viper", def: "default", value: "viper"},
		{chain: "mainnet", viper: "viper", def: "", value: "viper"},
		{chain: "mainnet", viper: "", def: "default", value: "default"},
		{chain: "mainnet", viper: "", def: "", value: DefaultMainnetSeeds},
		{chain: "local", viper: "viper", def: "default", value: "viper"},
		{chain: "local", viper: "viper", def: "", value: "viper"},
		{chain: "local", viper: "", def: "default", value: "default"},
		{chain: "local", viper: "", def: "", value: ""},
	}

	oldConf := conf.Custom.Chain
	viperObj := viper.New()
	cometBFTConfig := cfg.DefaultConfig()

	for _, ts := range data {
		conf.Custom.Chain = ts.chain
		cometBFTConfig.P2P.Seeds = ts.def
		viperObj.Set(SeedsFlag, ts.viper)
		UpdateCometBFTConfig(cometBFTConfig, viperObj)

		if cometBFTConfig.P2P.Seeds != ts.value {
			t.Errorf("invalid UpdateCometBFTConfig, CometBFTConfig.P2P.Seeds not set correctly")
		}
	}

	conf.Custom.Chain = oldConf
}

func TestGetChainManagerAddressMigration(t *testing.T) {
	// Backup and defer restore for chainManagerAddressMigrations
	originalMigrations := make(map[string]map[int64]ChainManagerAddressMigration)
	for k, v := range chainManagerAddressMigrations {
		cp := make(map[int64]ChainManagerAddressMigration)
		for kk, vv := range v {
			cp[kk] = vv
		}
		originalMigrations[k] = cp
	}
	defer func() { chainManagerAddressMigrations = originalMigrations }()

	// Backup and defer restore for conf.Custom
	originalCustom := conf.Custom
	defer func() { conf.Custom = originalCustom }()

	// Backup and restore viper flags
	originalChain := viper.GetString(ChainFlag)
	defer viper.Set(ChainFlag, originalChain)

	// Set up the test
	newPolContractAddress := "0x0000000000000000000000000000000000001234"
	chainManagerAddressMigrations[TestnetChain] = map[int64]ChainManagerAddressMigration{
		350: {PolTokenAddress: newPolContractAddress},
	}

	InitTestGiltConsensusConfig(TestnetChain)
	migration, found := GetChainManagerAddressMigration(350)
	if !found {
		t.Errorf("Expected migration to be found")
	}
	if migration.PolTokenAddress != newPolContractAddress {
		t.Errorf("Expected pol token address to be %s, got %s", newPolContractAddress, migration.PolTokenAddress)
	}

	// test for non-existing migration
	_, found = GetChainManagerAddressMigration(351)
	if found {
		t.Errorf("Expected migration to not be found")
	}

	// test for the non-existing chain
	conf.Custom.GiltRPCUrl = ""
	conf.Custom.Chain = "newChain"

	_, found = GetChainManagerAddressMigration(350)
	if found {
		t.Errorf("Expected migration to not be found")
	}
}
