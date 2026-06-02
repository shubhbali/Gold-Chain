package parlia

import (
	"encoding/hex"
	"math/big"
	"testing"
)

func TestMintableInflationRewardUsesStakeHubExpectedAmount(t *testing.T) {
	firstAmount := big.NewInt(1_234_567_890)
	nextAmount := big.NewInt(2_345_678_901)

	tests := []struct {
		name string
		cfg  *stakeHubInflationState
		want *big.Int
	}{
		{
			name: "first eligible interval mints exact expected amount",
			cfg: &stakeHubInflationState{
				enabled:            true,
				dayIndex:           42,
				expectedMintAmount: firstAmount,
			},
			want: firstAmount,
		},
		{
			name: "duplicate same-day interval mints zero",
			cfg: &stakeHubInflationState{
				enabled:            true,
				dayIndex:           42,
				expectedMintAmount: firstAmount,
				mintedByDay:        firstAmount,
			},
			want: new(big.Int),
		},
		{
			name: "next interval mints exact expected amount",
			cfg: &stakeHubInflationState{
				enabled:            true,
				dayIndex:           43,
				expectedMintAmount: nextAmount,
			},
			want: nextAmount,
		},
		{
			name: "disabled inflation mints zero",
			cfg: &stakeHubInflationState{
				enabled:            false,
				dayIndex:           44,
				expectedMintAmount: firstAmount,
			},
			want: new(big.Int),
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := mintableInflationReward(tt.cfg)
			if got.Cmp(tt.want) != 0 {
				t.Fatalf("got %s want %s", got, tt.want)
			}
			if tt.want.Sign() > 0 && got == tt.cfg.expectedMintAmount {
				t.Fatal("mintable reward must copy StakeHub expected amount")
			}
		})
	}
}

func TestEncodeExpectedInflationMintAmountCall(t *testing.T) {
	data := encodeSingleUint64Call("expectedInflationMintAmount(uint256)", 42)
	got := hex.EncodeToString(data)
	want := "f951a906000000000000000000000000000000000000000000000000000000000000002a"
	if got != want {
		t.Fatalf("got %s want %s", got, want)
	}
}

func TestEncodeInflationMintedByDayCall(t *testing.T) {
	data := encodeSingleUint64Call("inflationMintedByDay(uint256)", 42)
	got := hex.EncodeToString(data)
	want := "a3fdc48e000000000000000000000000000000000000000000000000000000000000002a"
	if got != want {
		t.Fatalf("got %s want %s", got, want)
	}
}
