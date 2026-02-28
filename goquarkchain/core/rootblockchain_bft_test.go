package core

import (
	"math/big"
	"testing"

	"github.com/QuarkChain/goquarkchain/account"
	"github.com/QuarkChain/goquarkchain/cluster/config"
	"github.com/QuarkChain/goquarkchain/core/types"
	"github.com/ethereum/go-ethereum/crypto"
	lru "github.com/hashicorp/golang-lru"
)

func TestSubmitBFTVoteByValidatorAndEvidence(t *testing.T) {
	qc := config.NewQuarkChainConfig()
	qc.Root.ConsensusType = config.PoSA
	qc.Root.PoSAConfig.Validators = []string{
		"0x111111111111111111111111111111111111111100000000",
		"0x222222222222222222222222222222222222222200000000",
		"0x333333333333333333333333333333333333333300000000",
	}
	cache, _ := lru.New(8)
	target := types.NewRootBlockWithHeader(&types.RootBlockHeader{
		Number:          1,
		Difficulty:      big.NewInt(1),
		ToTalDifficulty: big.NewInt(1),
		CoinbaseAmount:  types.NewEmptyTokenBalances(),
		Extra:           []byte{0x01},
	})
	cache.Add(target.Hash(), target)
	altTarget := types.NewRootBlockWithHeader(&types.RootBlockHeader{
		Number:          1,
		Difficulty:      big.NewInt(1),
		ToTalDifficulty: big.NewInt(1),
		CoinbaseAmount:  types.NewEmptyTokenBalances(),
		Extra:           []byte{0x02},
	})
	cache.Add(altTarget.Hash(), altTarget)
	bc := &RootBlockChain{
		chainConfig:   qc,
		blockCache:    cache,
		posaLifecycle: NewPOSAValidatorLifecycle(),
		bftState:      NewBFTRoundState(),
		bftEvidence:   make([]BFTEvidence, 0),
	}
	if err := bc.SubmitBFTVoteByValidator(qc.Root.PoSAConfig.Validators[0], 1, 1, string(BFTVotePrevote), target.Hash()); err != nil {
		t.Fatalf("vote1 failed: %v", err)
	}
	if err := bc.SubmitBFTVoteByValidator(qc.Root.PoSAConfig.Validators[1], 1, 1, string(BFTVotePrevote), target.Hash()); err != nil {
		t.Fatalf("vote2 failed: %v", err)
	}
	status := bc.BFTStatus()
	if status["enabled"] != true {
		t.Fatalf("bft should be enabled")
	}
	if err := bc.SubmitBFTVoteByValidator(qc.Root.PoSAConfig.Validators[0], 1, 1, string(BFTVotePrevote), altTarget.Hash()); err == nil {
		t.Fatalf("expected equivocation error")
	}
	if len(bc.BFTEvidenceList()) == 0 {
		t.Fatalf("expected bft evidence")
	}
}

func TestSubmitSignedBFTVote(t *testing.T) {
	key, err := crypto.GenerateKey()
	if err != nil {
		t.Fatalf("generate key failed: %v", err)
	}
	validator := account.NewAddress(account.PublicKeyToRecipient(key.PublicKey), 0)

	qc := config.NewQuarkChainConfig()
	qc.Root.ConsensusType = config.PoSA
	qc.Root.PoSAConfig.Validators = []string{validator.ToHex()}
	qc.Root.PoSAConfig.MinValidatorCount = 1

	cache, _ := lru.New(8)
	target := types.NewRootBlockWithHeader(&types.RootBlockHeader{
		Number:          1,
		Difficulty:      big.NewInt(1),
		ToTalDifficulty: big.NewInt(1),
		CoinbaseAmount:  types.NewEmptyTokenBalances(),
		Extra:           []byte{0x03},
	})
	cache.Add(target.Hash(), target)

	bc := &RootBlockChain{
		chainConfig:   qc,
		blockCache:    cache,
		posaLifecycle: NewPOSAValidatorLifecycle(),
		bftState:      NewBFTRoundState(),
		bftEvidence:   make([]BFTEvidence, 0),
	}
	signHash := bftVoteSigningHash(qc.NetworkID, 1, 2, string(BFTVotePrecommit), target.Hash())
	sig, err := crypto.Sign(signHash.Bytes(), key)
	if err != nil {
		t.Fatalf("sign failed: %v", err)
	}
	var sigArr [65]byte
	copy(sigArr[:], sig)
	if err := bc.SubmitSignedBFTVote(1, 2, string(BFTVotePrecommit), target.Hash(), sigArr); err != nil {
		t.Fatalf("submit signed bft vote failed: %v", err)
	}
}

func TestSubmitSignedBFTProposal(t *testing.T) {
	key, err := crypto.GenerateKey()
	if err != nil {
		t.Fatalf("generate key failed: %v", err)
	}
	validator := account.NewAddress(account.PublicKeyToRecipient(key.PublicKey), 0)

	qc := config.NewQuarkChainConfig()
	qc.Root.ConsensusType = config.PoSA
	qc.Root.PoSAConfig.Validators = []string{validator.ToHex()}
	qc.Root.PoSAConfig.MinValidatorCount = 1

	cache, _ := lru.New(8)
	target := types.NewRootBlockWithHeader(&types.RootBlockHeader{
		Number:          1,
		Difficulty:      big.NewInt(1),
		ToTalDifficulty: big.NewInt(1),
		CoinbaseAmount:  types.NewEmptyTokenBalances(),
		Extra:           []byte{0x30},
	})
	cache.Add(target.Hash(), target)

	bc := &RootBlockChain{
		chainConfig:   qc,
		blockCache:    cache,
		posaLifecycle: NewPOSAValidatorLifecycle(),
		bftState:      NewBFTRoundState(),
		bftEvidence:   make([]BFTEvidence, 0),
	}
	signHash := bftProposalSigningHash(qc.NetworkID, 1, 1, target.Hash())
	sig, err := crypto.Sign(signHash.Bytes(), key)
	if err != nil {
		t.Fatalf("sign failed: %v", err)
	}
	var sigArr [65]byte
	copy(sigArr[:], sig)

	if err := bc.SubmitSignedBFTProposal(1, 1, target.Hash(), sigArr); err != nil {
		t.Fatalf("submit signed bft proposal failed: %v", err)
	}
	if !bc.bftState.HasProposal(1, 1) {
		t.Fatalf("expected bft proposal to be registered")
	}
}

func TestSubmitBFTProposalEnforcesExpectedProposer(t *testing.T) {
	qc := config.NewQuarkChainConfig()
	qc.Root.ConsensusType = config.PoSA
	qc.Root.PoSAConfig.Validators = []string{
		"0x111111111111111111111111111111111111111100000000",
		"0x222222222222222222222222222222222222222200000000",
		"0x333333333333333333333333333333333333333300000000",
	}
	cache, _ := lru.New(8)
	target := types.NewRootBlockWithHeader(&types.RootBlockHeader{
		Number:          1,
		Difficulty:      big.NewInt(1),
		ToTalDifficulty: big.NewInt(1),
		CoinbaseAmount:  types.NewEmptyTokenBalances(),
		Extra:           []byte{0x11},
	})
	cache.Add(target.Hash(), target)
	bc := &RootBlockChain{
		chainConfig:   qc,
		blockCache:    cache,
		posaLifecycle: NewPOSAValidatorLifecycle(),
		bftState:      NewBFTRoundState(),
		bftEvidence:   make([]BFTEvidence, 0),
	}
	if err := bc.SubmitBFTProposal(qc.Root.PoSAConfig.Validators[1], 1, 1, target.Hash()); err == nil {
		t.Fatalf("expected proposer mismatch error")
	}
	if err := bc.SubmitBFTProposal(qc.Root.PoSAConfig.Validators[0], 1, 1, target.Hash()); err != nil {
		t.Fatalf("expected proposer should succeed: %v", err)
	}
}

func TestSubmitBFTVoteRejectsStaleRound(t *testing.T) {
	qc := config.NewQuarkChainConfig()
	qc.Root.ConsensusType = config.PoSA
	qc.Root.PoSAConfig.Validators = []string{
		"0x111111111111111111111111111111111111111100000000",
		"0x222222222222222222222222222222222222222200000000",
		"0x333333333333333333333333333333333333333300000000",
	}
	cache, _ := lru.New(8)
	target := types.NewRootBlockWithHeader(&types.RootBlockHeader{
		Number:          1,
		Difficulty:      big.NewInt(1),
		ToTalDifficulty: big.NewInt(1),
		CoinbaseAmount:  types.NewEmptyTokenBalances(),
		Extra:           []byte{0x12},
	})
	cache.Add(target.Hash(), target)
	bc := &RootBlockChain{
		chainConfig:   qc,
		blockCache:    cache,
		posaLifecycle: NewPOSAValidatorLifecycle(),
		bftState:      NewBFTRoundState(),
		bftEvidence:   make([]BFTEvidence, 0),
	}
	// Move current BFT round forward.
	bc.bftState.SubmitProposal(2, 3, target.Hash())

	if err := bc.SubmitBFTVoteByValidator(qc.Root.PoSAConfig.Validators[0], 2, 2, string(BFTVotePrevote), target.Hash()); err == nil {
		t.Fatalf("expected stale round vote rejection")
	}
}

func TestExpectedBFTProposerSkipsJailedValidator(t *testing.T) {
	qc := config.NewQuarkChainConfig()
	qc.Root.ConsensusType = config.PoSA
	qc.Root.PoSAConfig.Validators = []string{
		"0x111111111111111111111111111111111111111100000000",
		"0x222222222222222222222222222222222222222200000000",
		"0x333333333333333333333333333333333333333300000000",
	}
	bc := &RootBlockChain{
		chainConfig:   qc,
		posaLifecycle: NewPOSAValidatorLifecycle(),
	}
	bc.posaLifecycle.Jail(qc.Root.PoSAConfig.Validators[0])

	got, err := bc.expectedBFTProposer(1, 1)
	if err != nil {
		t.Fatalf("expected proposer error: %v", err)
	}
	want := qc.Root.PoSAConfig.Validators[1]
	if got != want {
		t.Fatalf("unexpected proposer: got %s want %s", got, want)
	}
}

func TestMaybeAutoBFTProposal(t *testing.T) {
	key, err := crypto.GenerateKey()
	if err != nil {
		t.Fatalf("generate key failed: %v", err)
	}
	validator := account.NewAddress(account.PublicKeyToRecipient(key.PublicKey), 0).ToHex()

	qc := config.NewQuarkChainConfig()
	qc.Root.ConsensusType = config.PoSA
	qc.Root.PoSAConfig.Validators = []string{validator}
	qc.RootSignerPrivateKey = crypto.FromECDSA(key)
	cache, _ := lru.New(8)
	target := types.NewRootBlockWithHeader(&types.RootBlockHeader{
		Number:          1,
		Difficulty:      big.NewInt(1),
		ToTalDifficulty: big.NewInt(1),
		CoinbaseAmount:  types.NewEmptyTokenBalances(),
		Extra:           []byte{0x13},
	})
	cache.Add(target.Hash(), target)
	bc := &RootBlockChain{
		chainConfig:   qc,
		blockCache:    cache,
		posaLifecycle: NewPOSAValidatorLifecycle(),
		bftState:      NewBFTRoundState(),
		bftEvidence:   make([]BFTEvidence, 0),
	}
	bc.currentBlock.Store(target)
	bc.maybeAutoBFTProposal()
	if !bc.bftState.HasProposal(1, 1) {
		t.Fatalf("expected auto proposal for current round")
	}
}

func TestSubmitBFTVoteAutoRegistersProposalIfMissing(t *testing.T) {
	qc := config.NewQuarkChainConfig()
	qc.Root.ConsensusType = config.PoSA
	qc.Root.PoSAConfig.Validators = []string{
		"0x111111111111111111111111111111111111111100000000",
		"0x222222222222222222222222222222222222222200000000",
		"0x333333333333333333333333333333333333333300000000",
	}
	cache, _ := lru.New(8)
	target := types.NewRootBlockWithHeader(&types.RootBlockHeader{
		Number:          1,
		Difficulty:      big.NewInt(1),
		ToTalDifficulty: big.NewInt(1),
		CoinbaseAmount:  types.NewEmptyTokenBalances(),
		Extra:           []byte{0x14},
	})
	cache.Add(target.Hash(), target)
	bc := &RootBlockChain{
		chainConfig:   qc,
		blockCache:    cache,
		posaLifecycle: NewPOSAValidatorLifecycle(),
		bftState:      NewBFTRoundState(),
		bftEvidence:   make([]BFTEvidence, 0),
	}
	if bc.bftState.HasProposal(1, 1) {
		t.Fatalf("unexpected existing proposal in setup")
	}
	if err := bc.SubmitBFTVoteByValidator(qc.Root.PoSAConfig.Validators[0], 1, 1, string(BFTVotePrevote), target.Hash()); err != nil {
		t.Fatalf("vote should auto-register proposal: %v", err)
	}
	if !bc.bftState.HasProposal(1, 1) {
		t.Fatalf("expected proposal to be auto-registered by vote")
	}
}
