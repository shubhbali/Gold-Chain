package core

import (
	"sync"

	"github.com/ethereum/go-ethereum/common"
)

// POSAVote represents a validator attestation for a root block.
type POSAVote struct {
	ValidatorID string
	TargetHash  common.Hash
	TargetNum   uint64
	Power       uint64
}

// POSAVoteCollector stores votes keyed by target block hash.
// This is an incremental scaffold for full finality vote rules.
type POSAVoteCollector struct {
	mu    sync.Mutex
	votes map[common.Hash]map[string]POSAVote
	// byTargetNum tracks validator vote targets for equivocation detection.
	byTargetNum map[uint64]map[string]common.Hash
}

func NewPOSAVoteCollector() *POSAVoteCollector {
	return &POSAVoteCollector{
		votes:       make(map[common.Hash]map[string]POSAVote),
		byTargetNum: make(map[uint64]map[string]common.Hash),
	}
}

func (c *POSAVoteCollector) Add(v POSAVote) {
	c.AddChecked(v)
}

func (c *POSAVoteCollector) AddChecked(v POSAVote) (added bool, equivocation bool) {
	c.mu.Lock()
	defer c.mu.Unlock()
	if c.byTargetNum[v.TargetNum] == nil {
		c.byTargetNum[v.TargetNum] = make(map[string]common.Hash)
	}
	if existing, ok := c.byTargetNum[v.TargetNum][v.ValidatorID]; ok {
		if existing != v.TargetHash {
			return false, true
		}
		return false, false
	}
	if c.votes[v.TargetHash] == nil {
		c.votes[v.TargetHash] = make(map[string]POSAVote)
	}
	c.votes[v.TargetHash][v.ValidatorID] = v
	c.byTargetNum[v.TargetNum][v.ValidatorID] = v.TargetHash
	return true, false
}

func (c *POSAVoteCollector) TotalPower(target common.Hash) uint64 {
	c.mu.Lock()
	defer c.mu.Unlock()
	var power uint64
	for _, v := range c.votes[target] {
		power += v.Power
	}
	return power
}

func (c *POSAVoteCollector) Reset(target common.Hash) {
	c.mu.Lock()
	defer c.mu.Unlock()
	for _, v := range c.votes[target] {
		if byValidator := c.byTargetNum[v.TargetNum]; byValidator != nil {
			delete(byValidator, v.ValidatorID)
			if len(byValidator) == 0 {
				delete(c.byTargetNum, v.TargetNum)
			}
		}
	}
	delete(c.votes, target)
}

func (c *POSAVoteCollector) RemoveValidator(validatorID string) {
	c.mu.Lock()
	defer c.mu.Unlock()
	for targetHash, byValidator := range c.votes {
		if v, ok := byValidator[validatorID]; ok {
			delete(byValidator, validatorID)
			if len(byValidator) == 0 {
				delete(c.votes, targetHash)
			}
			if byTarget := c.byTargetNum[v.TargetNum]; byTarget != nil {
				delete(byTarget, validatorID)
				if len(byTarget) == 0 {
					delete(c.byTargetNum, v.TargetNum)
				}
			}
		}
	}
}

func (c *POSAVoteCollector) Snapshot() []POSAVote {
	c.mu.Lock()
	defer c.mu.Unlock()
	out := make([]POSAVote, 0)
	for _, byValidator := range c.votes {
		for _, v := range byValidator {
			out = append(out, v)
		}
	}
	return out
}

func (c *POSAVoteCollector) Load(votes []POSAVote) {
	c.mu.Lock()
	defer c.mu.Unlock()
	c.votes = make(map[common.Hash]map[string]POSAVote)
	c.byTargetNum = make(map[uint64]map[string]common.Hash)
	for _, v := range votes {
		if c.votes[v.TargetHash] == nil {
			c.votes[v.TargetHash] = make(map[string]POSAVote)
		}
		if c.byTargetNum[v.TargetNum] == nil {
			c.byTargetNum[v.TargetNum] = make(map[string]common.Hash)
		}
		c.votes[v.TargetHash][v.ValidatorID] = v
		c.byTargetNum[v.TargetNum][v.ValidatorID] = v.TargetHash
	}
}
