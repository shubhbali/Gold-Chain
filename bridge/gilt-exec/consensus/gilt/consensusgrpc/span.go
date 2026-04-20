package giltconsensusgrpc

import (
	"context"
	"strconv"
	"time"

	"github.com/ethereum/go-ethereum/consensus/gilt/consensusclient"
	"github.com/ethereum/go-ethereum/log"

	"github.com/giltchain/gilt-consensus/x/gilt/types"
)

func (h *GiltConsensusGRPCClient) GetSpan(ctx context.Context, spanID uint64) (*types.Span, error) {
	log.Info("Fetching span", "spanID", spanID)

	var err error

	ctxWithTimeout, cancel := context.WithTimeout(ctx, defaultTimeout)
	defer cancel()

	// Start the timer and set the request type on the context.
	start := time.Now()
	ctx = giltconsensus.WithRequestType(ctxWithTimeout, giltconsensus.SpanRequest)

	// Defer the metrics call.
	defer func() {
		giltconsensus.SendMetrics(ctx, start, err == nil)
	}()

	req := &types.QuerySpanByIdRequest{
		Id: strconv.FormatUint(spanID, 10),
	}

	res, err := h.giltQueryClient.GetSpanById(ctx, req)
	if err != nil {
		return nil, err
	}

	resSpan := res.GetSpan()

	log.Info("Fetched span", "spanID", spanID)

	return resSpan, nil
}

func (h *GiltConsensusGRPCClient) GetLatestSpan(ctx context.Context) (*types.Span, error) {
	log.Info("Fetching latest span")

	var err error

	ctxWithTimeout, cancel := context.WithTimeout(ctx, defaultTimeout)
	defer cancel()

	// Start the timer and set the request type on the context.
	start := time.Now()
	ctx = giltconsensus.WithRequestType(ctxWithTimeout, giltconsensus.LatestSpanRequest)

	// Defer the metrics call.
	defer func() {
		giltconsensus.SendMetrics(ctx, start, err == nil)
	}()

	req := &types.QueryLatestSpanRequest{}

	res, err := h.giltQueryClient.GetLatestSpan(ctx, req)
	if err != nil {
		return nil, err
	}

	resSpan := res.GetSpan()

	log.Info("Fetched latest span")

	return &resSpan, nil
}
