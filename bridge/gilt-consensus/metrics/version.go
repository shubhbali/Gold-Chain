package metrics

import (
	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promauto"
)

// giltconsensusV2InfoGauge stores the GiltConsensusV2 version and commit details.
var giltconsensusV2InfoGauge = promauto.NewGaugeVec(prometheus.GaugeOpts{
	Namespace: Namespace,
	Name:      "info",
	Help:      "GiltConsensusV2 version and commit details",
}, []string{"version", "commit"})

// UpdateGiltConsensusV2Info updates the giltconsensusv2_info metric with the current version and commit details.
func UpdateGiltConsensusV2Info(version, commit string) {
	giltconsensusV2InfoGauge.WithLabelValues(
		version,
		commit,
	).Set(1)
}
