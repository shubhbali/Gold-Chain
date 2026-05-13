package types

import (
	"fmt"
	"strconv"
	"strings"
	"time"
)

// BridgeLifecycleRecord stores canonical state for one bridge event.
type BridgeLifecycleRecord struct {
	SourceChainID   string    `json:"source_chain_id"`
	TxHash          string    `json:"tx_hash"`
	LogIndex        uint64    `json:"log_index"`
	StateID         uint64    `json:"state_id"`
	LifecycleState  string    `json:"lifecycle_state"`
	FailureReason   string    `json:"failure_reason,omitempty"`
	CreatedAt       time.Time `json:"created_at"`
	UpdatedAt       time.Time `json:"updated_at"`
	TransitionCount uint64    `json:"transition_count"`
}

func CanonicalChainID(chainID string) string {
	return strings.ToLower(strings.TrimSpace(chainID))
}

func CanonicalTxHash(txHash string) string {
	return strings.ToLower(strings.TrimSpace(txHash))
}

// BridgeLifecycleCompositeKey creates stable storage key:
// source_chain_id|tx_hash|log_index|state_id
func BridgeLifecycleCompositeKey(sourceChainID, txHash string, logIndex, stateID uint64) string {
	return strings.Join(
		[]string{
			CanonicalChainID(sourceChainID),
			CanonicalTxHash(txHash),
			strconv.FormatUint(logIndex, 10),
			strconv.FormatUint(stateID, 10),
		},
		"|",
	)
}

func ParseBridgeLifecycleCompositeKey(key string) (sourceChainID, txHash string, logIndex, stateID uint64, err error) {
	parts := strings.Split(key, "|")
	if len(parts) != 4 {
		return "", "", 0, 0, fmt.Errorf("invalid lifecycle key format %q", key)
	}

	logIndex, err = strconv.ParseUint(parts[2], 10, 64)
	if err != nil {
		return "", "", 0, 0, fmt.Errorf("invalid lifecycle key log index in %q: %w", key, err)
	}

	stateID, err = strconv.ParseUint(parts[3], 10, 64)
	if err != nil {
		return "", "", 0, 0, fmt.Errorf("invalid lifecycle key state id in %q: %w", key, err)
	}

	return parts[0], parts[1], logIndex, stateID, nil
}
