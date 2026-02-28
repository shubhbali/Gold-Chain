package core

import (
	"sync"
	"sync/atomic"

	"github.com/ethereum/go-ethereum/common"
)

// FinalityState keeps root-chain finality checkpoints.
// This is an incremental scaffold; voting-derived updates will replace
// heuristic advancement in later steps.
type FinalityState struct {
	justifiedHeight uint64
	finalizedHeight uint64
	mu              sync.RWMutex
	justifiedHash   common.Hash
	finalizedHash   common.Hash
}

func NewFinalityState() *FinalityState {
	return &FinalityState{}
}

func (s *FinalityState) SetJustified(height uint64) {
	atomic.StoreUint64(&s.justifiedHeight, height)
}

func (s *FinalityState) SetFinalized(height uint64) {
	atomic.StoreUint64(&s.finalizedHeight, height)
}

func (s *FinalityState) SetJustifiedCheckpoint(height uint64, hash common.Hash) {
	atomic.StoreUint64(&s.justifiedHeight, height)
	s.mu.Lock()
	s.justifiedHash = hash
	s.mu.Unlock()
}

func (s *FinalityState) SetFinalizedCheckpoint(height uint64, hash common.Hash) {
	atomic.StoreUint64(&s.finalizedHeight, height)
	s.mu.Lock()
	s.finalizedHash = hash
	s.mu.Unlock()
}

func (s *FinalityState) Justified() uint64 {
	return atomic.LoadUint64(&s.justifiedHeight)
}

func (s *FinalityState) Finalized() uint64 {
	return atomic.LoadUint64(&s.finalizedHeight)
}

func (s *FinalityState) JustifiedHash() common.Hash {
	s.mu.RLock()
	defer s.mu.RUnlock()
	return s.justifiedHash
}

func (s *FinalityState) FinalizedHash() common.Hash {
	s.mu.RLock()
	defer s.mu.RUnlock()
	return s.finalizedHash
}
