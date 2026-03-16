package parlia

import (
	"math/big"
	"testing"

	"github.com/ethereum/go-ethereum/params"
)

func TestCurrentInflationBpsForDay(t *testing.T) {
	cfg := &stakeHubInflationState{
		startDayIndex:   10,
		initialBps:      1_000,
		minBps:          100,
		decayBpsPerYear: 5_000,
	}
	cases := []struct {
		dayIndex uint64
		want     uint64
	}{
		{10, 1_000},
		{10 + 365, 500},
		{10 + 730, 250},
		{10 + 1_095, 125},
		{10 + 1_460, 100},
	}
	for _, tc := range cases {
		if got := currentInflationBpsForDay(cfg, tc.dayIndex); got != tc.want {
			t.Fatalf("day %d: got %d want %d", tc.dayIndex, got, tc.want)
		}
	}
}

func TestMintableInflationRewardForFullYear(t *testing.T) {
	cfg := &stakeHubInflationState{
		enabled:           true,
		startDayIndex:     0,
		initialBps:        1_000,
		minBps:            150,
		decayBpsPerYear:   1_500,
		baseSupply:        new(big.Int).Mul(big.NewInt(1_000), big.NewInt(params.Ether)),
		mintedAmount:      new(big.Int),
		lastMintTimestamp: 1,
	}

	blockTime := uint64(365*24*60*60 + 1)
	got := mintableInflationReward(cfg, blockTime)
	want := new(big.Int).Mul(big.NewInt(100), big.NewInt(params.Ether))
	diff := new(big.Int).Sub(new(big.Int).Set(want), got)
	if diff.Sign() < 0 {
		diff.Neg(diff)
	}
	if diff.Cmp(big.NewInt(1_000_000_000_000)) > 0 {
		t.Fatalf("got %s want %s diff %s", got, want, diff)
	}
}

func TestMintableInflationRewardCompoundsAcrossRateBoundary(t *testing.T) {
	cfg := &stakeHubInflationState{
		enabled:           true,
		startDayIndex:     0,
		initialBps:        1_000,
		minBps:            150,
		decayBpsPerYear:   5_000,
		baseSupply:        new(big.Int).Mul(big.NewInt(1_000), big.NewInt(params.Ether)),
		mintedAmount:      new(big.Int),
		lastMintTimestamp: 1,
	}

	blockTime := uint64((365+365/2)*24*60*60 + 1)
	got := mintableInflationReward(cfg, blockTime)

	yearOne := new(big.Int).Mul(big.NewInt(100), big.NewInt(params.Ether))
	halfYearTwo := new(big.Int).Mul(big.NewInt(27), big.NewInt(params.Ether))
	minWant := new(big.Int).Add(yearOne, halfYearTwo)
	if got.Cmp(minWant) < 0 {
		t.Fatalf("got %s want at least %s", got, minWant)
	}
}
