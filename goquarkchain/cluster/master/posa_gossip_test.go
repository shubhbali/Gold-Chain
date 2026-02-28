package master

import (
	"encoding/binary"
	"math/big"
	"testing"

	"github.com/QuarkChain/goquarkchain/account"
	"github.com/QuarkChain/goquarkchain/cluster/config"
	"github.com/QuarkChain/goquarkchain/consensus"
	"github.com/QuarkChain/goquarkchain/core"
	"github.com/QuarkChain/goquarkchain/p2p"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/crypto"
	"github.com/ethereum/go-ethereum/ethdb"
)

func TestHandleNewPOSAVoteAppliesToRootState(t *testing.T) {
	key, err := crypto.GenerateKey()
	if err != nil {
		t.Fatalf("generate key failed: %v", err)
	}
	validator := account.NewAddress(account.PublicKeyToRecipient(key.PublicKey), 0).ToHex()

	qc := config.NewQuarkChainConfig()
	qc.Root.ConsensusType = config.PoSA
	qc.Root.PoSAConfig.MinValidatorCount = 1
	qc.Root.PoSAConfig.Validators = []string{validator}
	db := ethdb.NewMemDatabase()
	core.NewGenesis(qc).MustCommitRootBlock(db)
	root, err := core.NewRootBlockChain(db, qc, consensus.NewFakeEngine(&consensus.EthDifficultyCalculator{
		AdjustmentCutoff:  7,
		AdjustmentFactor:  512,
		MinimumDifficulty: big.NewInt(1),
	}))
	if err != nil {
		t.Fatalf("new root chain failed: %v", err)
	}
	pm := &ProtocolManager{
		rootBlockChain: root,
		peers:          newPeerSet(),
	}
	target := root.CurrentBlock()

	signHash := posaVoteSigningHash(qc.NetworkID, target.Hash(), target.NumberU64())
	sig, err := crypto.Sign(signHash.Bytes(), key)
	if err != nil {
		t.Fatalf("sign vote failed: %v", err)
	}
	var sigArr [65]byte
	copy(sigArr[:], sig)

	pm.HandleNewPOSAVote(&p2p.POSAVoteCommand{
		TargetHash:   target.Hash(),
		TargetNumber: target.NumberU64(),
		Signature:    sigArr,
	}, "peer-x")
	if got := root.POSAVotedPower(target.Hash()); got != 1 {
		t.Fatalf("unexpected voted power: got %d want 1", got)
	}
}

func posaVoteSigningHash(networkID uint32, targetHash common.Hash, targetNum uint64) common.Hash {
	msg := make([]byte, 0, len("QKC_POSA_VOTE_V1")+4+32+8)
	msg = append(msg, []byte("QKC_POSA_VOTE_V1")...)
	var b4 [4]byte
	binary.BigEndian.PutUint32(b4[:], networkID)
	msg = append(msg, b4[:]...)
	msg = append(msg, targetHash.Bytes()...)
	var b8 [8]byte
	binary.BigEndian.PutUint64(b8[:], targetNum)
	msg = append(msg, b8[:]...)
	return crypto.Keccak256Hash(msg)
}
