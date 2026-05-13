package types

import "fmt"

const (
	BridgeLifecycleSeen               = "seen"
	BridgeLifecyclePending            = "pending_confirmations"
	BridgeLifecycleConfirmed          = "confirmed"
	BridgeLifecycleFinalizedAction    = "finalized_actionable"
	BridgeLifecycleSubmitted          = "submitted"
	BridgeLifecycleCompleted          = "completed"
	BridgeLifecycleFailedRetryable    = "failed_retryable"
	BridgeLifecycleFailedTerminal     = "failed_terminal"
)

// BridgeLifecycleOrder defines strict forward progress for canonical lifecycle transitions.
var BridgeLifecycleOrder = []string{
	BridgeLifecycleSeen,
	BridgeLifecyclePending,
	BridgeLifecycleConfirmed,
	BridgeLifecycleFinalizedAction,
	BridgeLifecycleSubmitted,
	BridgeLifecycleCompleted,
}

func BridgeLifecycleRank(state string) int {
	for idx, current := range BridgeLifecycleOrder {
		if current == state {
			return idx
		}
	}

	return -1
}

func ValidateBridgeLifecycleTransition(currentState, nextState string) error {
	if currentState == "" {
		if nextState == BridgeLifecycleSeen || nextState == BridgeLifecycleFailedRetryable || nextState == BridgeLifecycleFailedTerminal {
			return nil
		}
		return fmt.Errorf("invalid initial lifecycle state %q", nextState)
	}

	if currentState == nextState {
		return nil
	}

	if currentState == BridgeLifecycleFailedTerminal || currentState == BridgeLifecycleCompleted {
		return fmt.Errorf("cannot transition terminal state %q to %q", currentState, nextState)
	}

	// Recovery path from retryable failures back into execution.
	if currentState == BridgeLifecycleFailedRetryable {
		if nextState == BridgeLifecycleSubmitted || nextState == BridgeLifecycleFailedTerminal {
			return nil
		}
		return fmt.Errorf("invalid recovery transition from %q to %q", currentState, nextState)
	}

	// Non-terminal failures can be recorded from any in-flight state.
	if nextState == BridgeLifecycleFailedRetryable || nextState == BridgeLifecycleFailedTerminal {
		return nil
	}

	currentRank := BridgeLifecycleRank(currentState)
	nextRank := BridgeLifecycleRank(nextState)
	if currentRank < 0 || nextRank < 0 {
		return fmt.Errorf("unknown lifecycle transition %q -> %q", currentState, nextState)
	}

	if nextRank != currentRank+1 {
		return fmt.Errorf("non-monotonic lifecycle transition %q -> %q", currentState, nextState)
	}

	return nil
}
