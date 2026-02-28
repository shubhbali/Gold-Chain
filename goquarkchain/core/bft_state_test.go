package core

import (
	"testing"

	"github.com/ethereum/go-ethereum/common"
)

func TestBFTRoundStateBuildsQC(t *testing.T) {
	s := NewBFTRoundState()
	hash := common.HexToHash("0x1")

	qc, evidence, added := s.SubmitVote(BFTVote{
		ValidatorID: "v1",
		Epoch:       1,
		Round:       2,
		VoteType:    BFTVotePrevote,
		TargetHash:  hash,
		Power:       1,
	}, 2)
	if evidence != nil || !added || qc != nil {
		t.Fatalf("unexpected first vote result")
	}

	qc, evidence, added = s.SubmitVote(BFTVote{
		ValidatorID: "v2",
		Epoch:       1,
		Round:       2,
		VoteType:    BFTVotePrevote,
		TargetHash:  hash,
		Power:       1,
	}, 2)
	if evidence != nil || !added || qc == nil {
		t.Fatalf("expected QC after threshold")
	}
	if qc.BlockHash != hash || qc.VoteType != BFTVotePrevote {
		t.Fatalf("unexpected qc content")
	}
}

func TestBFTRoundStateEquivocationEvidence(t *testing.T) {
	s := NewBFTRoundState()
	_, evidence, _ := s.SubmitVote(BFTVote{
		ValidatorID: "v1",
		Epoch:       1,
		Round:       1,
		VoteType:    BFTVotePrecommit,
		TargetHash:  common.HexToHash("0x1"),
		Power:       1,
	}, 2)
	if evidence != nil {
		t.Fatalf("unexpected evidence for first vote")
	}
	_, evidence, _ = s.SubmitVote(BFTVote{
		ValidatorID: "v1",
		Epoch:       1,
		Round:       1,
		VoteType:    BFTVotePrecommit,
		TargetHash:  common.HexToHash("0x2"),
		Power:       1,
	}, 2)
	if evidence == nil {
		t.Fatalf("expected equivocation evidence")
	}
}

func TestBFTRoundStateAdvanceOnTimeout(t *testing.T) {
	s := NewBFTRoundState()
	advanced, epoch, round := s.AdvanceOnTimeout(100, 5)
	if advanced {
		t.Fatalf("first timeout tick should initialize timer only")
	}
	if epoch != 1 || round != 1 {
		t.Fatalf("unexpected initial epoch/round: %d/%d", epoch, round)
	}

	advanced, epoch, round = s.AdvanceOnTimeout(103, 5)
	if advanced {
		t.Fatalf("should not advance before timeout")
	}
	if epoch != 1 || round != 1 {
		t.Fatalf("unexpected epoch/round before timeout: %d/%d", epoch, round)
	}

	advanced, epoch, round = s.AdvanceOnTimeout(106, 5)
	if !advanced {
		t.Fatalf("should advance after timeout")
	}
	if epoch != 1 || round != 2 {
		t.Fatalf("unexpected epoch/round after timeout: %d/%d", epoch, round)
	}
}
