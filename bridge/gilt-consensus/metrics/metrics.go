package metrics

import (
	"github.com/giltchain/gilt-consensus/version"
)

const (
	// Namespace is the prefix for all metrics.
	Namespace = "giltconsensusv2"
)

func InitMetrics() {
	// Update version Info gauge.
	UpdateGiltConsensusV2Info(version.Version, version.Commit)
}
