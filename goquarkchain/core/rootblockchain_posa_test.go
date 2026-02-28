package core

import (
	"testing"

	"github.com/QuarkChain/goquarkchain/cluster/config"
	"github.com/ethereum/go-ethereum/common"
)

func TestPOSARequiredPower(t *testing.T) {
	qc := config.NewQuarkChainConfig()
	qc.Root.ConsensusType = config.PoSA
	qc.Root.PoSAConfig.Validators = []string{
		"0x111111111111111111111111111111111111111100000000",
		"0x222222222222222222222222222222222222222200000000",
		"0x333333333333333333333333333333333333333300000000",
	}
	qc.Root.PoSAConfig.FinalityThresholdBps = 6666

	bc := &RootBlockChain{chainConfig: qc}
	if got := bc.totalPOSAValidatorPower(); got != 3 {
		t.Fatalf("unexpected total validator power: got %d want 3", got)
	}
	if got := bc.posaRequiredPower(); got != 2 {
		t.Fatalf("unexpected required power: got %d want 2", got)
	}
}

func TestSubmitPOSAVoteByValidatorUnknownValidator(t *testing.T) {
	qc := config.NewQuarkChainConfig()
	qc.Root.ConsensusType = config.PoSA
	qc.Root.PoSAConfig.Validators = []string{
		"0x111111111111111111111111111111111111111100000000",
	}
	bc := &RootBlockChain{
		chainConfig: qc,
		posaVotes:   NewPOSAVoteCollector(),
	}
	err := bc.SubmitPOSAVoteByValidator("0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa00000000", common.Hash{})
	if err == nil {
		t.Fatalf("expected error for unknown validator")
	}
}
