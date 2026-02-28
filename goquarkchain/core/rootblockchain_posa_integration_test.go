package core

import (
	"math/big"
	"testing"

	"github.com/QuarkChain/goquarkchain/cluster/config"
	"github.com/QuarkChain/goquarkchain/core/types"
	lru "github.com/hashicorp/golang-lru"
)

func TestPOSAIntegrationFinalityShardActivationAndForkSafety(t *testing.T) {
	qc := config.NewQuarkChainConfig()
	qc.Root.ConsensusType = config.PoSA
	qc.Root.PoSAConfig.Validators = []string{
		"0x111111111111111111111111111111111111111100000000",
		"0x222222222222222222222222222222222222222200000000",
		"0x333333333333333333333333333333333333333300000000",
	}
	qc.Root.PoSAConfig.ShardActivationDelayRootBlocks = 0

	cache, _ := lru.New(32)
	genesis := newTestRootBlock(0, types.EmptyHash, []byte{0x00})
	parent := newTestRootBlock(1, genesis.Hash(), []byte{0x01})
	childCanon := newTestRootBlock(2, parent.Hash(), []byte{0x02})
	childFork := newTestRootBlock(2, parent.Hash(), []byte{0x12})
	cache.Add(genesis.Hash(), genesis)
	cache.Add(parent.Hash(), parent)
	cache.Add(childCanon.Hash(), childCanon)
	cache.Add(childFork.Hash(), childFork)

	bc := &RootBlockChain{
		chainConfig:     qc,
		blockCache:      cache,
		finality:        NewFinalityState(),
		posaVotes:       NewPOSAVoteCollector(),
		posaLifecycle:   NewPOSAValidatorLifecycle(),
		shardActivation: NewShardActivationState(8, 16, 6666),
	}
	bc.currentBlock.Store(childCanon)

	if err := bc.ProposeNextShardActivation(); err != nil {
		t.Fatalf("propose activation failed: %v", err)
	}
	if err := bc.VoteShardActivation(qc.Root.PoSAConfig.Validators[0]); err != nil {
		t.Fatalf("vote activation #1 failed: %v", err)
	}
	if err := bc.VoteShardActivation(qc.Root.PoSAConfig.Validators[1]); err != nil {
		t.Fatalf("vote activation #2 failed: %v", err)
	}
	bc.tryAutoActivateShardsOnCanonicalInsert()
	if got := bc.CurrentActiveShards(); got != 9 {
		t.Fatalf("unexpected active shards: got %d want 9", got)
	}

	// Justify parent and canonical child to finalize parent.
	bc.posaVotes.Add(POSAVote{ValidatorID: qc.Root.PoSAConfig.Validators[0], TargetHash: parent.Hash(), TargetNum: parent.NumberU64(), Power: 1})
	bc.posaVotes.Add(POSAVote{ValidatorID: qc.Root.PoSAConfig.Validators[1], TargetHash: parent.Hash(), TargetNum: parent.NumberU64(), Power: 1})
	bc.posaVotes.Add(POSAVote{ValidatorID: qc.Root.PoSAConfig.Validators[0], TargetHash: childCanon.Hash(), TargetNum: childCanon.NumberU64(), Power: 1})
	bc.posaVotes.Add(POSAVote{ValidatorID: qc.Root.PoSAConfig.Validators[1], TargetHash: childCanon.Hash(), TargetNum: childCanon.NumberU64(), Power: 1})
	bc.updateFinalityOnCanonicalInsert(childCanon)
	if got := bc.FinalizedRootHeight(); got != parent.NumberU64() {
		t.Fatalf("unexpected finalized height: got %d want %d", got, parent.NumberU64())
	}

	// Any competing child chain that does not include finalized parent must be rejected.
	altParent := newTestRootBlock(1, genesis.Hash(), []byte{0x21})
	altChild := newTestRootBlock(2, altParent.Hash(), []byte{0x22})
	cache.Add(altParent.Hash(), altParent)
	cache.Add(altChild.Hash(), altChild)
	if err := bc.ensureRespectsFinalizedCheckpoint(altChild); err != ErrFinalizedReorg {
		t.Fatalf("expected ErrFinalizedReorg, got %v", err)
	}
}

func newTestRootBlock(number uint64, parentHash [32]byte, extra []byte) *types.RootBlock {
	return types.NewRootBlockWithHeader(&types.RootBlockHeader{
		Number:          uint32(number),
		ParentHash:      parentHash,
		Difficulty:      big.NewInt(1),
		ToTalDifficulty: big.NewInt(1),
		CoinbaseAmount:  types.NewEmptyTokenBalances(),
		Extra:           extra,
	})
}
