package core

import (
	"math/big"
	"testing"

	"github.com/QuarkChain/goquarkchain/cluster/config"
	"github.com/QuarkChain/goquarkchain/core/types"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/ethdb"
	lru "github.com/hashicorp/golang-lru"
)

func TestPOSAEquivocationJailsValidator(t *testing.T) {
	validatorID := "0x111111111111111111111111111111111111111100000000"
	qc := config.NewQuarkChainConfig()
	qc.Root.ConsensusType = config.PoSA
	qc.Root.PoSAConfig.Validators = []string{validatorID}

	cache, _ := lru.New(16)
	genesis := types.NewRootBlockWithHeader(&types.RootBlockHeader{
		Number:          0,
		Difficulty:      big.NewInt(1),
		ToTalDifficulty: big.NewInt(1),
		CoinbaseAmount:  types.NewEmptyTokenBalances(),
		Extra:           []byte{0x01},
	})
	a1 := types.NewRootBlockWithHeader(&types.RootBlockHeader{
		Number:          1,
		ParentHash:      genesis.Hash(),
		Difficulty:      big.NewInt(1),
		ToTalDifficulty: big.NewInt(2),
		CoinbaseAmount:  types.NewEmptyTokenBalances(),
		Extra:           []byte{0x02},
	})
	b1 := types.NewRootBlockWithHeader(&types.RootBlockHeader{
		Number:          1,
		ParentHash:      genesis.Hash(),
		Difficulty:      big.NewInt(1),
		ToTalDifficulty: big.NewInt(2),
		CoinbaseAmount:  types.NewEmptyTokenBalances(),
		Extra:           []byte{0x03},
	})
	cache.Add(genesis.Hash(), genesis)
	cache.Add(a1.Hash(), a1)
	cache.Add(b1.Hash(), b1)

	bc := &RootBlockChain{
		chainConfig:   qc,
		posaVotes:     NewPOSAVoteCollector(),
		posaLifecycle: NewPOSAValidatorLifecycle(),
		blockCache:    cache,
	}
	if err := bc.SubmitPOSAVoteByValidator(validatorID, a1.Hash()); err != nil {
		t.Fatalf("first vote should succeed: %v", err)
	}
	if got := bc.POSAVotedPower(a1.Hash()); got != 1 {
		t.Fatalf("unexpected voted power after first vote: %d", got)
	}
	if err := bc.SubmitPOSAVoteByValidator(validatorID, b1.Hash()); err == nil {
		t.Fatalf("equivocation should fail")
	}
	status := bc.ValidatorStatus(validatorID)
	if active, _ := status["active"].(bool); active {
		t.Fatalf("validator should be inactive after equivocation")
	}
	if slashCount, _ := status["slashCount"].(uint64); slashCount == 0 {
		t.Fatalf("validator should have non-zero slash count")
	}
}

func TestPOSAStatePersistence(t *testing.T) {
	db := ethdb.NewMemDatabase()
	validatorID := "0x111111111111111111111111111111111111111100000000"
	qc := config.NewQuarkChainConfig()
	qc.Root.ConsensusType = config.PoSA
	qc.Root.PoSAConfig.Validators = []string{validatorID}

	targetHash := common.HexToHash("0x1234")
	bc := &RootBlockChain{
		db:            db,
		chainConfig:   qc,
		posaVotes:     NewPOSAVoteCollector(),
		posaLifecycle: NewPOSAValidatorLifecycle(),
	}
	bc.posaVotes.Add(POSAVote{
		ValidatorID: validatorID,
		TargetHash:  targetHash,
		TargetNum:   7,
		Power:       1,
	})
	bc.posaLifecycle.AddReward(validatorID, 3)
	bc.posaLifecycle.Jail(validatorID)
	bc.persistPOSAState()

	bc2 := &RootBlockChain{
		db:            db,
		chainConfig:   qc,
		posaVotes:     NewPOSAVoteCollector(),
		posaLifecycle: NewPOSAValidatorLifecycle(),
	}
	bc2.loadPOSAState()

	if got := bc2.POSAVotedPower(targetHash); got != 1 {
		t.Fatalf("unexpected restored voted power: got %d want 1", got)
	}
	status := bc2.ValidatorStatus(validatorID)
	if jailed, _ := status["jailed"].(bool); !jailed {
		t.Fatalf("validator should be restored as jailed")
	}
	if reward, _ := status["reward"].(uint64); reward != 3 {
		t.Fatalf("unexpected restored reward: got %d want 3", reward)
	}
}
