package core

import (
	"testing"

	"github.com/QuarkChain/goquarkchain/cluster/config"
)

func TestRootChainShardActivationFlow(t *testing.T) {
	qc := config.NewQuarkChainConfig()
	qc.Root.PoSAConfig.Validators = []string{
		"0x111111111111111111111111111111111111111100000000",
		"0x222222222222222222222222222222222222222200000000",
		"0x333333333333333333333333333333333333333300000000",
	}
	qc.Root.PoSAConfig.InitialActiveShards = 8
	qc.Root.PoSAConfig.MaxActiveShards = 16
	qc.Root.PoSAConfig.ShardActivationThresholdBps = 6666
	qc.Root.PoSAConfig.ShardActivationDelayRootBlocks = 0

	bc := &RootBlockChain{
		chainConfig:     qc,
		shardActivation: NewShardActivationState(8, 16, 6666),
	}

	if err := bc.ProposeNextShardActivation(); err != nil {
		t.Fatalf("propose failed: %v", err)
	}
	if err := bc.VoteShardActivation("0x111111111111111111111111111111111111111100000000"); err != nil {
		t.Fatalf("vote 1 failed: %v", err)
	}
	if err := bc.VoteShardActivation("0x222222222222222222222222222222222222222200000000"); err != nil {
		t.Fatalf("vote 2 failed: %v", err)
	}
	got, err := bc.TryActivateShardExpansion()
	if err != nil {
		t.Fatalf("activate failed: %v", err)
	}
	if got != 9 {
		t.Fatalf("unexpected active shards: got %d want 9", got)
	}
}
