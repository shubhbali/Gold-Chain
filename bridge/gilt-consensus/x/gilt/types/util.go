package types

import (
	"fmt"
	"sort"
	"strings"

	staketypes "github.com/giltchain/gilt-consensus/x/stake/types"
)

// SortValidatorByAddress sorts a slice of validators by address.
// To sort it, we compare the values of the Signer(GiltConsensusAddress i.e. [20]byte)
func SortValidatorByAddress(a []staketypes.Validator) []staketypes.Validator {
	sort.Slice(a, func(i, j int) bool {
		return strings.Compare(a[i].Signer, a[j].Signer) < 0
	})

	return a
}

// SortSpansById sorts spans by SpanID
func SortSpansById(a []Span) {
	sort.Slice(a, func(i, j int) bool {
		return a[i].Id < a[j].Id
	})
}

func IsBlockCloseToSpanEnd(blockNumber, spanEnd uint64) bool {
	// Check if the block number is within 100 blocks of the span end
	return blockNumber <= spanEnd && blockNumber >= (spanEnd-100)
}

func GenerateGiltCommittedSpans(latestGiltBlock uint64, latestGiltUsedSpan *Span) []Span {
	spanLength := latestGiltUsedSpan.EndBlock - latestGiltUsedSpan.StartBlock
	estimatedSpans := (latestGiltBlock - latestGiltUsedSpan.EndBlock) / spanLength
	if estimatedSpans > 0 {
		estimatedSpans++ // Add buffer
	}
	spans := make([]Span, 0, estimatedSpans)
	prevSpan := latestGiltUsedSpan
	for latestGiltBlock > prevSpan.EndBlock {
		startBlock := prevSpan.EndBlock + 1
		newSpan := Span{
			Id:                prevSpan.Id + 1,
			StartBlock:        startBlock,
			EndBlock:          startBlock + spanLength,
			GiltChainId:        latestGiltUsedSpan.GiltChainId,
			SelectedProducers: latestGiltUsedSpan.SelectedProducers,
			ValidatorSet:      latestGiltUsedSpan.ValidatorSet,
		}
		spans = append(spans, newSpan)
		prevSpan = &newSpan
	}
	return spans
}

// CalcCurrentGiltSpanId computes the Gilt span ID corresponding to latestGiltBlock,
// using latestGiltConsensusSpan as the reference. It returns an error if inputs are invalid
// (nil span, zero, or negative span length) or if arithmetic overflow is detected.
func CalcCurrentGiltSpanId(latestGiltBlock uint64, latestGiltConsensusSpan *Span) (uint64, error) {
	if latestGiltConsensusSpan == nil {
		return 0, fmt.Errorf("nil GiltConsensus span provided")
	}
	if latestGiltConsensusSpan.EndBlock < latestGiltConsensusSpan.StartBlock {
		return 0, fmt.Errorf(
			"invalid GiltConsensus span: EndBlock (%d) must be >= StartBlock (%d)",
			latestGiltConsensusSpan.EndBlock,
			latestGiltConsensusSpan.StartBlock,
		)
	}

	if latestGiltBlock < latestGiltConsensusSpan.StartBlock {
		return 0, fmt.Errorf(
			"latestGiltBlock (%d) must be >= GiltConsensus span StartBlock (%d)",
			latestGiltBlock,
			latestGiltConsensusSpan.StartBlock,
		)
	}

	if latestGiltBlock <= latestGiltConsensusSpan.EndBlock {
		return latestGiltConsensusSpan.Id, nil
	}

	spanLength := latestGiltConsensusSpan.EndBlock - latestGiltConsensusSpan.StartBlock + 1

	offset := latestGiltBlock - latestGiltConsensusSpan.StartBlock
	quotient := offset / spanLength

	spanId := latestGiltConsensusSpan.Id + quotient

	if spanId < latestGiltConsensusSpan.Id {
		return 0, fmt.Errorf(
			"overflow detected computing span ID: reference ID=%d quotient=%d",
			latestGiltConsensusSpan.Id, quotient,
		)
	}

	return spanId, nil
}

const (
	PlannedDowntimeMinimumTimeInFuture = 150
	PlannedDowntimeMaximumTimeInFuture = 100 * DefaultSpanDuration // ~2 weeks
	PlannedDowntimeMinRange            = 150                       // It will be down minimum for the whole span, this here is just for tx validation
	PlannedDowntimeMaxRange            = 14 * DefaultSpanDuration  // ~48 hours
)

// LogSpan returns a human-readable summary of the span for logging purposes.
// It extracts the key fields without dumping the entire validator set, which causes unreadable logs.
func (s *Span) LogSpan() string {
	if s == nil {
		return "nil"
	}

	selectedProducers := ""
	if len(s.SelectedProducers) > 0 {
		producerIDs := make([]string, 0, len(s.SelectedProducers))
		for _, p := range s.SelectedProducers {
			producerIDs = append(producerIDs, fmt.Sprintf("valID=%d", p.ValId))
		}
		selectedProducers = strings.Join(producerIDs, ", ")
	}

	validatorCount := len(s.ValidatorSet.Validators)

	return fmt.Sprintf(
		"id=%d startBlock=%d endBlock=%d validatorCount=%d selectedProducers=[%s] giltChainId=%s",
		s.Id,
		s.StartBlock,
		s.EndBlock,
		validatorCount,
		selectedProducers,
		s.GiltChainId,
	)
}
