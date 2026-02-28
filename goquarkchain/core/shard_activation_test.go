package core

import "testing"

func TestShardActivationMonotonic(t *testing.T) {
	s := NewShardActivationState(8, 16, 6666)

	if err := s.Propose(10); err == nil {
		t.Fatalf("expected reject for non-monotonic target")
	}
	if err := s.Propose(9); err != nil {
		t.Fatalf("unexpected propose error: %v", err)
	}

	_ = s.Vote("v1", 40, 9)
	_ = s.Vote("v2", 30, 9)
	if !s.CanActivate(100) {
		t.Fatalf("expected activation quorum")
	}
	if got, err := s.Activate(100); err != nil {
		t.Fatalf("unexpected activate error: %v", err)
	} else if got != 9 {
		t.Fatalf("unexpected active shards: got %d want 9", got)
	}
}

func TestShardActivationMaxCap(t *testing.T) {
	s := NewShardActivationState(16, 16, 6666)
	if err := s.Propose(17); err == nil {
		t.Fatalf("expected max cap rejection")
	}
}
