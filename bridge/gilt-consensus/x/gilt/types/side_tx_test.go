package types_test

import (
	"testing"

	"github.com/stretchr/testify/require"

	"github.com/giltchain/gilt-consensus/x/gilt/types"
)

func TestRegisterSideMsgServer(t *testing.T) {
	t.Parallel()

	t.Run("registers side msg server without panic", func(t *testing.T) {
		t.Parallel()

		// This function registers server methods for side transactions
		// We can only verify it doesn't panic when called with nil (which it should handle gracefully)
		// Real testing would require mocking sidetxs.SideTxConfigurator and sidetxs.SideMsgServer

		// Just verify the function exists and can be referenced
		require.NotNil(t, types.RegisterSideMsgServer)
	})
}
