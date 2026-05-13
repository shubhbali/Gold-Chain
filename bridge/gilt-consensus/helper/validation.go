package helper

import (
	"fmt"
	"math/big"
	"strings"
	"sync/atomic"

	"cosmossdk.io/log"

	"github.com/giltchain/gilt-consensus/sidetxs"
)

var invalidChainIDCount uint64

var lastInvalidChainID atomic.Value

func init() {
	lastInvalidChainID.Store("")
}

// ValidateChainID checks if the message chain ID matches the expected Gilt chain ID.
// Returns true if the chain ID is valid, false otherwise.
// This is used to ensure messages are from the correct blockchain network.
func ValidateChainID(
	msgChainID string,
	expectedChainID string,
	logger log.Logger,
	moduleName string,
) bool {
	expectedCanonical := CanonicalizeChainID(expectedChainID)
	receivedCanonical := CanonicalizeChainID(msgChainID)

	if expectedCanonical != receivedCanonical {
		invalidCount := atomic.AddUint64(&invalidChainIDCount, 1)
		lastInvalidChainID.Store(
			fmt.Sprintf(
				"module=%s expected=%s received=%s",
				moduleName,
				expectedCanonical,
				receivedCanonical,
			),
		)
		logger.Error("Invalid chain ID",
			"module", moduleName,
			"expected", expectedChainID,
			"received", msgChainID,
			"expectedCanonical", expectedCanonical,
			"receivedCanonical", receivedCanonical,
			"invalidCount", invalidCount,
		)
		return false
	}

	return true
}

func CanonicalizeChainID(chainID string) string {
	return strings.ToLower(strings.TrimSpace(chainID))
}

func ChainIDEqual(left, right string) bool {
	return CanonicalizeChainID(left) == CanonicalizeChainID(right)
}

func ChainIDValidationStats() (uint64, string) {
	last, _ := lastInvalidChainID.Load().(string)
	return atomic.LoadUint64(&invalidChainIDCount), last
}

// ValidateVotingPower validates that the given amount can produce valid voting power.
// This is typically used in stake-related operations to ensure the staked amount
// is enough to generate meaningful voting power.
// Returns true if the amount produces valid voting power, false otherwise.
func ValidateVotingPower(
	amount *big.Int,
	logger log.Logger,
	validatorID uint64,
	moduleName string,
) bool {
	_, err := GetPowerFromAmount(amount)
	if err != nil {
		logger.Error("Invalid voting power from amount",
			"module", moduleName,
			"amount", amount,
			"validatorId", validatorID,
			"error", err)
		return false
	}

	return true
}

// IsSideTxApproved checks if a side transaction received YES votes.
// This is a simple helper to make post-handler code more readable.
// Returns true if the side transaction was approved (VOTE_YES).
func IsSideTxApproved(sideTxResult sidetxs.Vote) bool {
	return sideTxResult == sidetxs.Vote_VOTE_YES
}
