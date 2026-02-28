package core

import "testing"

func TestProposerIndexForHeight(t *testing.T) {
	tests := []struct {
		height uint64
		count  int
		want   int
	}{
		{height: 1, count: 3, want: 0},
		{height: 2, count: 3, want: 1},
		{height: 3, count: 3, want: 2},
		{height: 4, count: 3, want: 0},
		{height: 0, count: 3, want: 0},
		{height: 9, count: 1, want: 0},
		{height: 9, count: 0, want: -1},
	}
	for _, tc := range tests {
		got := proposerIndexForHeight(tc.height, tc.count)
		if got != tc.want {
			t.Fatalf("height=%d count=%d got=%d want=%d", tc.height, tc.count, got, tc.want)
		}
	}
}
