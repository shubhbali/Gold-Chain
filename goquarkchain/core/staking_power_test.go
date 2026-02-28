package core

import (
	"math/big"
	"testing"
)

func TestEffectiveStake(t *testing.T) {
	a := big.NewInt(100)
	b := big.NewInt(50)
	// 1x for A and 2x for B => 100 + 100 = 200
	got := EffectiveStake(a, b, 10000, 20000)
	if got.Cmp(big.NewInt(200)) != 0 {
		t.Fatalf("unexpected effective stake: got %s want 200", got.String())
	}
}

func TestValidateStakeRatio(t *testing.T) {
	a := big.NewInt(100)
	b := big.NewInt(10)
	if err := ValidateStakeRatio(a, b, 10); err != nil {
		t.Fatalf("expected ratio pass, got err: %v", err)
	}
	if err := ValidateStakeRatio(a, big.NewInt(9), 10); err == nil {
		t.Fatalf("expected ratio failure")
	}
}
