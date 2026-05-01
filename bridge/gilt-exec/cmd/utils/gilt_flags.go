package utils

import (
	"os"
	"time"

	"github.com/urfave/cli/v2"

	"github.com/ethereum/go-ethereum/eth"
	"github.com/ethereum/go-ethereum/eth/ethconfig"
	"github.com/ethereum/go-ethereum/node"
)

var (
	//
	// Gilt Specific flags
	//

	// GiltConsensusURLFlag flag for giltconsensus url (comma-separated for failover)
	GiltConsensusURLFlag = &cli.StringFlag{
		Name:  "gilt.giltconsensus",
		Usage: "URL of GiltConsensus service (comma-separated for failover: \"url1,url2\")",
		Value: "http://localhost:1317",
	}

	// GiltConsensusTimeoutFlag flag for giltconsensus timeout
	GiltConsensusTimeoutFlag = &cli.DurationFlag{
		Name:  "gilt.giltconsensustimeout",
		Usage: "Timeout of GiltConsensus service",
		Value: 5 * time.Second,
	}

	// GiltConsensusgRPCAddressFlag flag for giltconsensus gRPC address (comma-separated for failover)
	GiltConsensusgRPCAddressFlag = &cli.StringFlag{
		Name:  "gilt.giltconsensusgRPC",
		Usage: "Address of GiltConsensus gRPC service (comma-separated for failover: \"addr1,addr2\")",
		Value: "",
	}

	// GiltConsensusWSAddressFlag flag for giltconsensus websocket subscription service (comma-separated for failover)
	GiltConsensusWSAddressFlag = &cli.StringFlag{
		Name:  "gilt.giltconsensusWS",
		Usage: "Address of GiltConsensus WS Subscription service (comma-separated for failover: \"addr1,addr2\")",
		Value: "",
	}

	// GiltFlags all gilt related flags
	GiltFlags = []cli.Flag{
		GiltConsensusURLFlag,
		GiltConsensusTimeoutFlag,
		GiltConsensusgRPCAddressFlag,
		GiltConsensusWSAddressFlag,
	}
)

// SetGiltConfig sets gilt config
func SetGiltConfig(ctx *cli.Context, cfg *eth.Config) {
	cfg.GiltConsensusURL = ctx.String(GiltConsensusURLFlag.Name)
	cfg.GiltConsensusTimeout = ctx.Duration(GiltConsensusTimeoutFlag.Name)
	cfg.GiltConsensusgRPCAddress = ctx.String(GiltConsensusgRPCAddressFlag.Name)
	cfg.GiltConsensusWSAddress = ctx.String(GiltConsensusWSAddressFlag.Name)
}

// CreateGiltEthereum Creates gilt ethereum object from eth.Config
func CreateGiltEthereum(cfg *ethconfig.Config) *eth.Ethereum {
	workspace, err := os.MkdirTemp("", "gilt-command-node-")
	if err != nil {
		Fatalf("Failed to create temporary keystore: %v", err)
	}

	// Create a networkless protocol stack and start an Ethereum service within
	stack, err := node.New(&node.Config{DataDir: workspace, UseLightweightKDF: true, Name: "gilt-command-node"})
	if err != nil {
		Fatalf("Failed to create node: %v", err)
	}

	ethereum, err := eth.New(stack, cfg)
	if err != nil {
		Fatalf("Failed to register Ethereum protocol: %v", err)
	}

	// Start the node and assemble the JavaScript console around it
	if err = stack.Start(); err != nil {
		Fatalf("Failed to start stack: %v", err)
	}

	stack.Attach()

	return ethereum
}
