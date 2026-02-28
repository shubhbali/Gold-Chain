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

func TestHandleNewBFTProposalAppliesToRootState(t *testing.T) {
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

	signHash := bftProposalSigningHash(qc.NetworkID, 1, 1, target.Hash())
	sig, err := crypto.Sign(signHash.Bytes(), key)
	if err != nil {
		t.Fatalf("sign proposal failed: %v", err)
	}
	var sigArr [65]byte
	copy(sigArr[:], sig)

	pm.HandleNewBFTProposal(&p2p.BFTProposalCommand{
		Epoch:      1,
		Round:      1,
		TargetHash: target.Hash(),
		Signature:  sigArr,
	}, "peer-x")

	status := root.BFTStatus()
	if status["proposalTarget"] != target.Hash().Hex() {
		t.Fatalf("unexpected proposal target: got %v want %s", status["proposalTarget"], target.Hash().Hex())
	}
}

func bftProposalSigningHash(networkID uint32, epoch uint64, round uint64, targetHash common.Hash) common.Hash {
	msg := make([]byte, 0, len("QKC_BFT_PROPOSAL_V1")+4+8+8+32)
	msg = append(msg, []byte("QKC_BFT_PROPOSAL_V1")...)
	var b4 [4]byte
	binary.BigEndian.PutUint32(b4[:], networkID)
	msg = append(msg, b4[:]...)
	var b8 [8]byte
	binary.BigEndian.PutUint64(b8[:], epoch)
	msg = append(msg, b8[:]...)
	binary.BigEndian.PutUint64(b8[:], round)
	msg = append(msg, b8[:]...)
	msg = append(msg, targetHash.Bytes()...)
	return crypto.Keccak256Hash(msg)
}
