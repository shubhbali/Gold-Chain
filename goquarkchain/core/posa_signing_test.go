package core

import (
	"math/big"
	"testing"

	"github.com/QuarkChain/goquarkchain/account"
	"github.com/QuarkChain/goquarkchain/cluster/config"
	"github.com/QuarkChain/goquarkchain/core/types"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/crypto"
	lru "github.com/hashicorp/golang-lru"
)

func TestSubmitSignedPOSAVote(t *testing.T) {
	key, err := crypto.GenerateKey()
	if err != nil {
		t.Fatalf("generate key failed: %v", err)
	}
	validatorAddr := account.NewAddress(account.PublicKeyToRecipient(key.PublicKey), 0)

	qc := config.NewQuarkChainConfig()
	qc.Root.ConsensusType = config.PoSA
	qc.Root.PoSAConfig.Validators = []string{validatorAddr.ToHex()}

	cache, _ := lru.New(8)
	target := types.NewRootBlockWithHeader(&types.RootBlockHeader{
		Number:          7,
		Difficulty:      big.NewInt(1),
		ToTalDifficulty: big.NewInt(1),
		CoinbaseAmount:  types.NewEmptyTokenBalances(),
	})
	targetHash := target.Hash()
	cache.Add(targetHash, target)

	bc := &RootBlockChain{
		chainConfig: qc,
		posaVotes:   NewPOSAVoteCollector(),
		blockCache:  cache,
	}

	signHash := posaVoteSigningHash(qc.NetworkID, targetHash, target.NumberU64())
	sig, err := crypto.Sign(signHash.Bytes(), key)
	if err != nil {
		t.Fatalf("sign vote failed: %v", err)
	}
	var sigArr [65]byte
	copy(sigArr[:], sig)

	if err := bc.SubmitSignedPOSAVote(targetHash, target.NumberU64(), sigArr); err != nil {
		t.Fatalf("submit signed vote failed: %v", err)
	}
	if got := bc.POSAVotedPower(targetHash); got != 1 {
		t.Fatalf("unexpected voted power: got %d want 1", got)
	}
}

func TestVoteShardActivationSigned(t *testing.T) {
	key, err := crypto.GenerateKey()
	if err != nil {
		t.Fatalf("generate key failed: %v", err)
	}
	validatorAddr := account.NewAddress(account.PublicKeyToRecipient(key.PublicKey), 0)

	qc := config.NewQuarkChainConfig()
	qc.Root.ConsensusType = config.PoSA
	qc.Root.PoSAConfig.Validators = []string{validatorAddr.ToHex()}
	qc.Root.PoSAConfig.ShardActivationDelayRootBlocks = 0

	bc := &RootBlockChain{
		chainConfig:     qc,
		shardActivation: NewShardActivationState(8, 16, 6666),
	}
	if err := bc.ProposeNextShardActivation(); err != nil {
		t.Fatalf("propose failed: %v", err)
	}

	signHash := shardActivationSigningHash(qc.NetworkID, 9)
	sig, err := crypto.Sign(signHash.Bytes(), key)
	if err != nil {
		t.Fatalf("sign activation vote failed: %v", err)
	}
	var sigArr [65]byte
	copy(sigArr[:], sig)

	if err := bc.VoteShardActivationSigned(9, sigArr); err != nil {
		t.Fatalf("vote activation failed: %v", err)
	}
	got, err := bc.TryActivateShardExpansion()
	if err != nil {
		t.Fatalf("activate failed: %v", err)
	}
	if got != 9 {
		t.Fatalf("unexpected active shard count: got %d want 9", got)
	}
}

func TestSubmitSignedPOSAVoteRejectsBadSignature(t *testing.T) {
	key, err := crypto.GenerateKey()
	if err != nil {
		t.Fatalf("generate key failed: %v", err)
	}
	otherKey, err := crypto.GenerateKey()
	if err != nil {
		t.Fatalf("generate other key failed: %v", err)
	}
	validatorAddr := account.NewAddress(account.PublicKeyToRecipient(key.PublicKey), 0)

	qc := config.NewQuarkChainConfig()
	qc.Root.ConsensusType = config.PoSA
	qc.Root.PoSAConfig.Validators = []string{validatorAddr.ToHex()}

	cache, _ := lru.New(8)
	target := types.NewRootBlockWithHeader(&types.RootBlockHeader{
		Number:          3,
		Difficulty:      big.NewInt(1),
		ToTalDifficulty: big.NewInt(1),
		CoinbaseAmount:  types.NewEmptyTokenBalances(),
	})
	targetHash := target.Hash()
	cache.Add(targetHash, target)

	bc := &RootBlockChain{
		chainConfig: qc,
		posaVotes:   NewPOSAVoteCollector(),
		blockCache:  cache,
	}

	signHash := posaVoteSigningHash(qc.NetworkID, targetHash, target.NumberU64())
	sig, err := crypto.Sign(signHash.Bytes(), otherKey)
	if err != nil {
		t.Fatalf("sign vote failed: %v", err)
	}
	var sigArr [65]byte
	copy(sigArr[:], sig)
	if err := bc.SubmitSignedPOSAVote(targetHash, target.NumberU64(), sigArr); err == nil {
		t.Fatalf("expected bad signature to be rejected")
	}
}

func TestPOSASigningHashStable(t *testing.T) {
	h := common.HexToHash("0x01")
	a := posaVoteSigningHash(1, h, 2)
	b := posaVoteSigningHash(1, h, 2)
	if a != b {
		t.Fatalf("vote signing hash should be deterministic")
	}
}
