package core

import (
	"fmt"
	"sort"
	"strings"
	"sync"
	"time"

	"github.com/ethereum/go-ethereum/common"
)

type BFTVoteType string

const (
	BFTVotePrevote   BFTVoteType = "PREVOTE"
	BFTVotePrecommit BFTVoteType = "PRECOMMIT"
	BFTVoteNewView   BFTVoteType = "NEWVIEW"
)

type BFTVote struct {
	ValidatorID string
	Epoch       uint64
	Round       uint64
	VoteType    BFTVoteType
	TargetHash  common.Hash
	Power       uint64
}

type BFTQuorumCert struct {
	Epoch     uint64
	Round     uint64
	VoteType  BFTVoteType
	BlockHash common.Hash
	Voters    []string
}

type BFTEvidence struct {
	ValidatorID string
	Epoch       uint64
	Round       uint64
	VoteType    BFTVoteType
	OldHash     common.Hash
	NewHash     common.Hash
	Timestamp   uint64
}

type BFTStateSnapshot struct {
	CurrentEpoch uint64
	CurrentRound uint64
	LockedQC     *BFTQuorumCert
	HighQC       *BFTQuorumCert
}

type BFTRoundState struct {
	mu sync.RWMutex

	currentEpoch uint64
	currentRound uint64
	lockedQC     *BFTQuorumCert
	highQC       *BFTQuorumCert
	lastProgress uint64

	// proposals are tracked by (epoch, round) for diagnostics.
	proposals map[string]common.Hash
	// voteByValidator detects equivocation by (epoch, round, voteType, validator).
	voteByValidator map[string]common.Hash
	// tally tracks vote power by (epoch, round, voteType, targetHash).
	tally map[string]map[string]uint64
	// voters tracks voter set for QC emission.
	voters map[string]map[string]map[string]struct{}
}

func NewBFTRoundState() *BFTRoundState {
	return &BFTRoundState{
		proposals:       make(map[string]common.Hash),
		voteByValidator: make(map[string]common.Hash),
		tally:           make(map[string]map[string]uint64),
		voters:          make(map[string]map[string]map[string]struct{}),
	}
}

func normalizeBFTVoteType(voteType string) (BFTVoteType, error) {
	upper := strings.ToUpper(strings.TrimSpace(voteType))
	switch BFTVoteType(upper) {
	case BFTVotePrevote, BFTVotePrecommit, BFTVoteNewView:
		return BFTVoteType(upper), nil
	default:
		return "", fmt.Errorf("invalid bft vote type: %s", voteType)
	}
}

func (s *BFTRoundState) SubmitProposal(epoch, round uint64, blockHash common.Hash) {
	s.mu.Lock()
	defer s.mu.Unlock()
	s.proposals[proposalKey(epoch, round)] = blockHash
	if epoch > s.currentEpoch || (epoch == s.currentEpoch && round > s.currentRound) {
		s.currentEpoch = epoch
		s.currentRound = round
	}
	s.lastProgress = uint64(time.Now().Unix())
}

func (s *BFTRoundState) SubmitVote(v BFTVote, quorumPower uint64) (qc *BFTQuorumCert, evidence *BFTEvidence, added bool) {
	s.mu.Lock()
	defer s.mu.Unlock()

	if v.Power == 0 {
		return nil, nil, false
	}
	key := voteKey(v.Epoch, v.Round, v.VoteType)
	validatorKey := key + "|" + strings.ToLower(v.ValidatorID)
	if oldHash, ok := s.voteByValidator[validatorKey]; ok {
		if oldHash != v.TargetHash {
			return nil, &BFTEvidence{
				ValidatorID: strings.ToLower(v.ValidatorID),
				Epoch:       v.Epoch,
				Round:       v.Round,
				VoteType:    v.VoteType,
				OldHash:     oldHash,
				NewHash:     v.TargetHash,
				Timestamp:   uint64(time.Now().Unix()),
			}, false
		}
		return nil, nil, false
	}

	if s.tally[key] == nil {
		s.tally[key] = make(map[string]uint64)
	}
	targetKey := v.TargetHash.Hex()
	s.tally[key][targetKey] += v.Power

	if s.voters[key] == nil {
		s.voters[key] = make(map[string]map[string]struct{})
	}
	if s.voters[key][targetKey] == nil {
		s.voters[key][targetKey] = make(map[string]struct{})
	}
	s.voters[key][targetKey][strings.ToLower(v.ValidatorID)] = struct{}{}
	s.voteByValidator[validatorKey] = v.TargetHash
	added = true
	s.lastProgress = uint64(time.Now().Unix())

	if quorumPower == 0 || s.tally[key][targetKey] < quorumPower {
		return nil, nil, true
	}
	voters := make([]string, 0, len(s.voters[key][targetKey]))
	for validator := range s.voters[key][targetKey] {
		voters = append(voters, validator)
	}
	sort.Strings(voters)
	return &BFTQuorumCert{
		Epoch:     v.Epoch,
		Round:     v.Round,
		VoteType:  v.VoteType,
		BlockHash: v.TargetHash,
		Voters:    voters,
	}, nil, true
}

func (s *BFTRoundState) ApplyQC(qc *BFTQuorumCert) {
	if qc == nil {
		return
	}
	s.mu.Lock()
	defer s.mu.Unlock()
	if s.highQC == nil || isQCHigher(qc, s.highQC) {
		s.highQC = qc
	}
	if qc.VoteType == BFTVotePrecommit && (s.lockedQC == nil || isQCHigher(qc, s.lockedQC)) {
		s.lockedQC = qc
	}
	if qc.Epoch > s.currentEpoch || (qc.Epoch == s.currentEpoch && qc.Round > s.currentRound) {
		s.currentEpoch = qc.Epoch
		s.currentRound = qc.Round
	}
	s.lastProgress = uint64(time.Now().Unix())
}

func (s *BFTRoundState) Snapshot() *BFTStateSnapshot {
	s.mu.RLock()
	defer s.mu.RUnlock()
	return &BFTStateSnapshot{
		CurrentEpoch: s.currentEpoch,
		CurrentRound: s.currentRound,
		LockedQC:     cloneQC(s.lockedQC),
		HighQC:       cloneQC(s.highQC),
	}
}

func (s *BFTRoundState) Load(snapshot *BFTStateSnapshot) {
	if snapshot == nil {
		return
	}
	s.mu.Lock()
	defer s.mu.Unlock()
	s.currentEpoch = snapshot.CurrentEpoch
	s.currentRound = snapshot.CurrentRound
	s.lockedQC = cloneQC(snapshot.LockedQC)
	s.highQC = cloneQC(snapshot.HighQC)
	if s.currentEpoch == 0 {
		s.currentEpoch = 1
	}
	if s.currentRound == 0 {
		s.currentRound = 1
	}
	s.lastProgress = uint64(time.Now().Unix())
}

func (s *BFTRoundState) VotePower(epoch uint64, round uint64, voteType BFTVoteType, blockHash common.Hash) uint64 {
	s.mu.RLock()
	defer s.mu.RUnlock()
	key := voteKey(epoch, round, voteType)
	if byHash := s.tally[key]; byHash != nil {
		return byHash[blockHash.Hex()]
	}
	return 0
}

func (s *BFTRoundState) HasProposal(epoch, round uint64) bool {
	s.mu.RLock()
	defer s.mu.RUnlock()
	_, ok := s.proposals[proposalKey(epoch, round)]
	return ok
}

func (s *BFTRoundState) ProposalTarget(epoch, round uint64) (common.Hash, bool) {
	s.mu.RLock()
	defer s.mu.RUnlock()
	h, ok := s.proposals[proposalKey(epoch, round)]
	return h, ok
}

func (s *BFTRoundState) AdvanceOnTimeout(nowUnix uint64, timeoutSec uint64) (advanced bool, epoch uint64, round uint64) {
	s.mu.Lock()
	defer s.mu.Unlock()
	if timeoutSec == 0 {
		timeoutSec = 5
	}
	if s.currentEpoch == 0 {
		s.currentEpoch = 1
	}
	if s.currentRound == 0 {
		s.currentRound = 1
	}
	if nowUnix == 0 {
		nowUnix = uint64(time.Now().Unix())
	}
	if s.lastProgress == 0 {
		s.lastProgress = nowUnix
		return false, s.currentEpoch, s.currentRound
	}
	if nowUnix-s.lastProgress < timeoutSec {
		return false, s.currentEpoch, s.currentRound
	}
	s.currentRound++
	s.lastProgress = nowUnix
	return true, s.currentEpoch, s.currentRound
}

func cloneQC(qc *BFTQuorumCert) *BFTQuorumCert {
	if qc == nil {
		return nil
	}
	voters := make([]string, len(qc.Voters))
	copy(voters, qc.Voters)
	return &BFTQuorumCert{
		Epoch:     qc.Epoch,
		Round:     qc.Round,
		VoteType:  qc.VoteType,
		BlockHash: qc.BlockHash,
		Voters:    voters,
	}
}

func isQCHigher(a, b *BFTQuorumCert) bool {
	if a == nil {
		return false
	}
	if b == nil {
		return true
	}
	if a.Epoch != b.Epoch {
		return a.Epoch > b.Epoch
	}
	return a.Round > b.Round
}

func voteKey(epoch, round uint64, voteType BFTVoteType) string {
	return fmt.Sprintf("%d|%d|%s", epoch, round, voteType)
}

func proposalKey(epoch, round uint64) string {
	return fmt.Sprintf("%d|%d", epoch, round)
}
