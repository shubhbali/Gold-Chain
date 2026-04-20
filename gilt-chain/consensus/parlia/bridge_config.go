package parlia

import "time"

type BridgeConfig struct {
	HeimdallURL           string
	StateReceiverContract string
	StateSyncTimeout      time.Duration
	StateSyncDelay        time.Duration
}
