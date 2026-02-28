package core

import (
	"errors"
	"math/big"
	"sync/atomic"
	"testing"

	"github.com/QuarkChain/goquarkchain/cluster/config"
	"github.com/QuarkChain/goquarkchain/core/types"
	lru "github.com/hashicorp/golang-lru"
)

func TestEnsureRespectsFinalizedCheckpointRejectsRollback(t *testing.T) {
	qc := config.NewQuarkChainConfig()
	qc.Root.ConsensusType = config.PoSA

	cache, _ := lru.New(16)
	genesis := testRootBlock(0, types.EmptyHash, []byte{0x00})
	a1 := testRootBlock(1, genesis.Hash(), []byte{0x01})
	a2 := testRootBlock(2, a1.Hash(), []byte{0x02})
	b1 := testRootBlock(1, genesis.Hash(), []byte{0x11})
	b2 := testRootBlock(2, b1.Hash(), []byte{0x12})

	cache.Add(genesis.Hash(), genesis)
	cache.Add(a1.Hash(), a1)
	cache.Add(a2.Hash(), a2)
	cache.Add(b1.Hash(), b1)
	cache.Add(b2.Hash(), b2)

	bc := &RootBlockChain{
		chainConfig: qc,
		blockCache:  cache,
		finality:    NewFinalityState(),
	}
	bc.finality.SetFinalizedCheckpoint(1, a1.Hash())

	if err := bc.ensureRespectsFinalizedCheckpoint(a2); err != nil {
		t.Fatalf("expected canonical descendant to pass, got %v", err)
	}
	if err := bc.ensureRespectsFinalizedCheckpoint(b2); !errors.Is(err, ErrFinalizedReorg) {
		t.Fatalf("expected ErrFinalizedReorg, got %v", err)
	}
}

func TestPOSAFinalityRequiresParentJustification(t *testing.T) {
	qc := config.NewQuarkChainConfig()
	qc.Root.ConsensusType = config.PoSA
	qc.Root.PoSAConfig.Validators = []string{
		"0x111111111111111111111111111111111111111100000000",
		"0x222222222222222222222222222222222222222200000000",
		"0x333333333333333333333333333333333333333300000000",
	}
	cache, _ := lru.New(8)
	genesis := testRootBlock(0, types.EmptyHash, []byte{0x00})
	parent := testRootBlock(1, genesis.Hash(), []byte{0x01})
	child := testRootBlock(2, parent.Hash(), []byte{0x02})
	cache.Add(genesis.Hash(), genesis)
	cache.Add(parent.Hash(), parent)
	cache.Add(child.Hash(), child)
	bc := &RootBlockChain{
		chainConfig:   qc,
		finality:      NewFinalityState(),
		posaVotes:     NewPOSAVoteCollector(),
		posaLifecycle: NewPOSAValidatorLifecycle(),
		blockCache:    cache,
	}
	bc.currentBlock.Store(child)
	atomic.StoreUint64(&bc.finality.finalizedHeight, 0)

	// Child justified only: no parent finalization yet.
	bc.posaVotes.Add(POSAVote{ValidatorID: qc.Root.PoSAConfig.Validators[0], TargetHash: child.Hash(), TargetNum: child.NumberU64(), Power: 1})
	bc.posaVotes.Add(POSAVote{ValidatorID: qc.Root.PoSAConfig.Validators[1], TargetHash: child.Hash(), TargetNum: child.NumberU64(), Power: 1})
	bc.updateFinalityOnCanonicalInsert(child)
	if got := bc.FinalizedRootHeight(); got != 0 {
		t.Fatalf("expected no finalization without parent justification, got %d", got)
	}

	// Parent justified too: parent can be finalized.
	bc.posaVotes.Add(POSAVote{ValidatorID: qc.Root.PoSAConfig.Validators[0], TargetHash: parent.Hash(), TargetNum: parent.NumberU64(), Power: 1})
	bc.posaVotes.Add(POSAVote{ValidatorID: qc.Root.PoSAConfig.Validators[1], TargetHash: parent.Hash(), TargetNum: parent.NumberU64(), Power: 1})
	bc.updateFinalityOnCanonicalInsert(child)
	if got := bc.FinalizedRootHeight(); got != parent.NumberU64() {
		t.Fatalf("expected parent finalized, got %d want %d", got, parent.NumberU64())
	}
}

func TestAutoActivateShardsOnCanonicalInsert(t *testing.T) {
	qc := config.NewQuarkChainConfig()
	qc.Root.ConsensusType = config.PoSA
	qc.Root.PoSAConfig.Validators = []string{
		"0x111111111111111111111111111111111111111100000000",
		"0x222222222222222222222222222222222222222200000000",
		"0x333333333333333333333333333333333333333300000000",
	}
	qc.Root.PoSAConfig.ShardActivationDelayRootBlocks = 0

	bc := &RootBlockChain{
		chainConfig:     qc,
		shardActivation: NewShardActivationState(8, 16, 6666),
	}
	if err := bc.ProposeNextShardActivation(); err != nil {
		t.Fatalf("propose failed: %v", err)
	}
	if err := bc.VoteShardActivation("0x111111111111111111111111111111111111111100000000"); err != nil {
		t.Fatalf("vote1 failed: %v", err)
	}
	if err := bc.VoteShardActivation("0x222222222222222222222222222222222222222200000000"); err != nil {
		t.Fatalf("vote2 failed: %v", err)
	}

	bc.tryAutoActivateShardsOnCanonicalInsert()
	if got := bc.CurrentActiveShards(); got != 9 {
		t.Fatalf("unexpected active shards: got %d want 9", got)
	}
}

func testRootBlock(number uint64, parentHash [32]byte, extra []byte) *types.RootBlock {
	return types.NewRootBlockWithHeader(&types.RootBlockHeader{
		Number:          uint32(number),
		ParentHash:      parentHash,
		Difficulty:      big.NewInt(1),
		ToTalDifficulty: big.NewInt(1),
		CoinbaseAmount:  types.NewEmptyTokenBalances(),
		Extra:           extra,
	})
}
