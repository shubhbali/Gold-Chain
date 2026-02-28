package core

import (
	"fmt"
	"sync"
)

// ShardActivationState manages validator-driven shard activation.
// Rules enforced here:
// - activation is monotonic (+1 only)
// - cannot exceed configured max
// - cannot decrease
type ShardActivationState struct {
	mu sync.Mutex

	currentActive uint32
	maxActive     uint32
	quorumBps     uint32

	pendingTarget uint32
	votesPower    map[string]uint64
}

func NewShardActivationState(initialActive, maxActive, quorumBps uint32) *ShardActivationState {
	if initialActive == 0 {
		initialActive = 1
	}
	if maxActive < initialActive {
		maxActive = initialActive
	}
	if quorumBps == 0 {
		quorumBps = 6666
	}
	return &ShardActivationState{
		currentActive: initialActive,
		maxActive:     maxActive,
		quorumBps:     quorumBps,
		votesPower:    make(map[string]uint64),
	}
}

func (s *ShardActivationState) CurrentActiveShards() uint32 {
	s.mu.Lock()
	defer s.mu.Unlock()
	return s.currentActive
}

func (s *ShardActivationState) PendingTarget() uint32 {
	s.mu.Lock()
	defer s.mu.Unlock()
	return s.pendingTarget
}

func (s *ShardActivationState) PendingVotedPower() uint64 {
	s.mu.Lock()
	defer s.mu.Unlock()
	var voted uint64
	for _, p := range s.votesPower {
		voted += p
	}
	return voted
}

func (s *ShardActivationState) Propose(target uint32) error {
	s.mu.Lock()
	defer s.mu.Unlock()
	if target != s.currentActive+1 {
		return fmt.Errorf("invalid shard activation target: have %d want %d", target, s.currentActive+1)
	}
	if target > s.maxActive {
		return fmt.Errorf("invalid shard activation target: %d exceeds max %d", target, s.maxActive)
	}
	s.pendingTarget = target
	s.votesPower = make(map[string]uint64)
	return nil
}

func (s *ShardActivationState) Vote(validatorID string, power uint64, target uint32) error {
	s.mu.Lock()
	defer s.mu.Unlock()
	if s.pendingTarget == 0 {
		return fmt.Errorf("no pending shard activation proposal")
	}
	if target != s.pendingTarget {
		return fmt.Errorf("vote target mismatch: have %d want %d", target, s.pendingTarget)
	}
	if power == 0 {
		return nil
	}
	s.votesPower[validatorID] = power
	return nil
}

func (s *ShardActivationState) CanActivate(totalPower uint64) bool {
	s.mu.Lock()
	defer s.mu.Unlock()
	if s.pendingTarget == 0 || totalPower == 0 {
		return false
	}
	var voted uint64
	for _, p := range s.votesPower {
		voted += p
	}
	required := (totalPower*uint64(s.quorumBps) + 9999) / 10000
	return voted >= required
}

func (s *ShardActivationState) Activate(totalPower uint64) (uint32, error) {
	s.mu.Lock()
	defer s.mu.Unlock()
	if s.pendingTarget == 0 {
		return s.currentActive, fmt.Errorf("no pending shard activation proposal")
	}
	if totalPower == 0 {
		return s.currentActive, fmt.Errorf("total validator power is zero")
	}
	var voted uint64
	for _, p := range s.votesPower {
		voted += p
	}
	required := (totalPower*uint64(s.quorumBps) + 9999) / 10000
	if voted < required {
		return s.currentActive, fmt.Errorf("insufficient voting power for activation")
	}
	if s.pendingTarget != s.currentActive+1 {
		return s.currentActive, fmt.Errorf("pending target is not monotonic")
	}
	if s.pendingTarget > s.maxActive {
		return s.currentActive, fmt.Errorf("pending target exceeds max")
	}
	s.currentActive = s.pendingTarget
	s.pendingTarget = 0
	s.votesPower = make(map[string]uint64)
	return s.currentActive, nil
}
