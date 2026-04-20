package giltconsensus

import (
	"context"
	"errors"
	"fmt"
	"net"
	"time"

	"github.com/giltchain/gilt-consensus/x/gilt/types"
	ctypes "github.com/cometbft/cometbft/rpc/core/types"

	"github.com/ethereum/go-ethereum/consensus/gilt/clerk"
	"github.com/ethereum/go-ethereum/consensus/gilt/consensusclient/checkpoint"
	"github.com/ethereum/go-ethereum/consensus/gilt/consensusclient/milestone"
	"github.com/ethereum/go-ethereum/log"
)

const (
	defaultAttemptTimeout       = 30 * time.Second
	defaultProbeTimeout         = 5 * time.Second
	defaultHealthCheckInterval  = 10 * time.Second
	defaultConsecutiveThreshold = 3
	defaultPromotionCooldown    = 60 * time.Second
)

// Endpoint matches gilt.IGiltConsensusClient. It is exported so that external
// packages can build []Endpoint slices for NewMultiGiltConsensusClient without
// running into Go's covariant-slice restriction.
type Endpoint interface {
	StateSyncEvents(ctx context.Context, fromID uint64, to int64) ([]*clerk.EventRecordWithTime, error)
	GetSpan(ctx context.Context, spanID uint64) (*types.Span, error)
	GetLatestSpan(ctx context.Context) (*types.Span, error)
	FetchCheckpoint(ctx context.Context, number int64) (*checkpoint.Checkpoint, error)
	FetchCheckpointCount(ctx context.Context) (int64, error)
	FetchMilestone(ctx context.Context) (*milestone.Milestone, error)
	FetchMilestoneCount(ctx context.Context) (int64, error)
	FetchStatus(ctx context.Context) (*ctypes.SyncInfo, error)
	Close()
}

// MultiGiltConsensusClient wraps N giltconsensus clients (primary at index 0, failovers
// at 1..N-1) and transparently cascades through them when the active client is
// unreachable. A background health registry continuously probes ALL endpoints,
// requires consecutive successes + cooldown before promotion, and gives cascade
// full visibility into endpoint health.
type MultiGiltConsensusClient struct {
	clients        []Endpoint
	registry       *HealthRegistry
	attemptTimeout time.Duration
	probeTimeout   time.Duration
	probeCtx       context.Context // cancelled on Close to abort in-flight probes
	probeCancel    context.CancelFunc
}

func NewMultiGiltConsensusClient(clients ...Endpoint) (*MultiGiltConsensusClient, error) {
	if len(clients) == 0 {
		return nil, fmt.Errorf("NewMultiGiltConsensusClient requires at least one client")
	}

	probeCtx, probeCancel := context.WithCancel(context.Background())

	f := &MultiGiltConsensusClient{
		clients:        clients,
		attemptTimeout: defaultAttemptTimeout,
		probeTimeout:   defaultProbeTimeout,
		probeCtx:       probeCtx,
		probeCancel:    probeCancel,
	}

	f.registry = NewHealthRegistry(
		len(clients),
		f.probeEndpoint,
		nil, // HTTP client doesn't need onSwitch callback
		RegistryMetrics{
			ProbeAttempts:     failoverProbeAttempts,
			ProbeSuccesses:    failoverProbeSuccesses,
			ProactiveSwitches: failoverProactiveSwitches,
			ActiveGauge:       failoverActiveGauge,
			HealthyEndpoints:  failoverHealthyEndpoints,
		},
	)

	return f, nil
}

// probeEndpoint probes a single endpoint via FetchStatus.
func (f *MultiGiltConsensusClient) probeEndpoint(i int) error {
	ctx, cancel := context.WithTimeout(f.probeCtx, f.probeTimeout)
	defer cancel()

	_, err := f.clients[i].FetchStatus(ctx)

	return err
}

// ensureHealthRegistry lazily starts the health registry goroutine on the first
// API call. This allows tests to configure fields (thresholds, intervals) after
// construction but before the goroutine reads them.
func (f *MultiGiltConsensusClient) ensureHealthRegistry() {
	if len(f.clients) > 1 {
		f.registry.Start()
	}
}

func (f *MultiGiltConsensusClient) StateSyncEvents(ctx context.Context, fromID uint64, to int64) ([]*clerk.EventRecordWithTime, error) {
	return callWithFailover(f, ctx, func(ctx context.Context, c Endpoint) ([]*clerk.EventRecordWithTime, error) {
		return c.StateSyncEvents(ctx, fromID, to)
	})
}

func (f *MultiGiltConsensusClient) GetSpan(ctx context.Context, spanID uint64) (*types.Span, error) {
	return callWithFailover(f, ctx, func(ctx context.Context, c Endpoint) (*types.Span, error) {
		return c.GetSpan(ctx, spanID)
	})
}

func (f *MultiGiltConsensusClient) GetLatestSpan(ctx context.Context) (*types.Span, error) {
	return callWithFailover(f, ctx, func(ctx context.Context, c Endpoint) (*types.Span, error) {
		return c.GetLatestSpan(ctx)
	})
}

func (f *MultiGiltConsensusClient) FetchCheckpoint(ctx context.Context, number int64) (*checkpoint.Checkpoint, error) {
	return callWithFailover(f, ctx, func(ctx context.Context, c Endpoint) (*checkpoint.Checkpoint, error) {
		return c.FetchCheckpoint(ctx, number)
	})
}

func (f *MultiGiltConsensusClient) FetchCheckpointCount(ctx context.Context) (int64, error) {
	return callWithFailover(f, ctx, func(ctx context.Context, c Endpoint) (int64, error) {
		return c.FetchCheckpointCount(ctx)
	})
}

func (f *MultiGiltConsensusClient) FetchMilestone(ctx context.Context) (*milestone.Milestone, error) {
	return callWithFailover(f, ctx, func(ctx context.Context, c Endpoint) (*milestone.Milestone, error) {
		return c.FetchMilestone(ctx)
	})
}

func (f *MultiGiltConsensusClient) FetchMilestoneCount(ctx context.Context) (int64, error) {
	return callWithFailover(f, ctx, func(ctx context.Context, c Endpoint) (int64, error) {
		return c.FetchMilestoneCount(ctx)
	})
}

func (f *MultiGiltConsensusClient) FetchStatus(ctx context.Context) (*ctypes.SyncInfo, error) {
	return callWithFailover(f, ctx, func(ctx context.Context, c Endpoint) (*ctypes.SyncInfo, error) {
		return c.FetchStatus(ctx)
	})
}

func (f *MultiGiltConsensusClient) Close() {
	f.probeCancel() // cancel in-flight probes first
	f.registry.Stop()

	for _, c := range f.clients {
		c.Close()
	}
}

// callWithFailover executes fn against the active client. If the active client
// fails with a failover-eligible error, it marks it unhealthy and cascades
// through remaining clients using health registry information.
func callWithFailover[T any](f *MultiGiltConsensusClient, ctx context.Context, fn func(context.Context, Endpoint) (T, error)) (T, error) {
	f.ensureHealthRegistry()

	active := f.registry.Active()

	subCtx, cancel := context.WithTimeout(ctx, f.attemptTimeout)
	result, err := fn(subCtx, f.clients[active])
	cancel()

	if err == nil {
		return result, nil
	}

	if !isFailoverError(err, ctx) {
		var zero T
		return zero, err
	}

	// Mark the active endpoint unhealthy in the registry.
	f.registry.MarkUnhealthy(active, err)

	if active == 0 {
		log.Warn("GiltConsensus failover: primary failed, cascading", "err", err)
	}

	return cascadeClients(f, ctx, fn, active, err)
}

// cascadeClients tries all endpoints in priority order using health registry
// information. It uses a three-pass approach:
//  1. Healthy + cooled endpoints in priority order (skipping failed active)
//  2. Healthy but NOT cooled endpoints in priority order
//  3. Unhealthy endpoints in priority order (last resort)
func cascadeClients[T any](f *MultiGiltConsensusClient, ctx context.Context, fn func(context.Context, Endpoint) (T, error), failed int, lastErr error) (T, error) {
	n := len(f.clients)

	// Build candidate lists based on health state.
	snap := f.registry.HealthSnapshot()
	cooldown := f.registry.PromotionCooldown

	var cooled, uncooled, unhealthy []int

	for i := 0; i < n; i++ {
		if i == failed {
			continue
		}

		if snap[i].Healthy {
			if time.Since(snap[i].HealthySince) >= cooldown {
				cooled = append(cooled, i)
			} else {
				uncooled = append(uncooled, i)
			}
		} else {
			unhealthy = append(unhealthy, i)
		}
	}

	// Try each pass in order.
	passes := [][]int{cooled, uncooled, unhealthy}

	for _, candidates := range passes {
		for _, i := range candidates {
			subCtx, cancel := context.WithTimeout(ctx, f.attemptTimeout)
			result, err := fn(subCtx, f.clients[i])
			cancel()

			if err == nil {
				f.registry.SetActive(i)
				f.registry.MarkSuccess(i)

				failoverSwitchCounter.Inc(1)

				log.Warn("GiltConsensus failover: switched to client", "index", i)

				return result, nil
			}

			lastErr = err

			if !isFailoverError(err, ctx) {
				var zero T
				return zero, err
			}

			// Mark this endpoint unhealthy too.
			f.registry.MarkUnhealthy(i, err)
		}
	}

	var zero T
	return zero, lastErr
}

// isFailoverError returns true if the error warrants trying the secondary.
// It distinguishes between sub-context timeouts (failover-eligible) and
// caller context cancellation (not eligible).
func isFailoverError(err error, callerCtx context.Context) bool {
	if err == nil {
		return false
	}

	// If the caller's context is done, this is not a failover scenario
	if callerCtx.Err() != nil {
		return false
	}

	// Shutdown detected - not a transport error
	if errors.Is(err, ErrShutdownDetected) {
		return false
	}

	// 503 is a GiltConsensus feature-gate, not a transport issue
	if errors.Is(err, ErrServiceUnavailable) {
		return false
	}

	// Transport errors
	var netErr net.Error
	if errors.As(err, &netErr) {
		return true
	}

	// No response from GiltConsensus
	if errors.Is(err, ErrNoResponse) {
		return true
	}

	// Server-side HTTP error (5xx, excluding 503 which is already handled above).
	// Client errors (4xx) are logical errors; the secondary would return the same response.
	var httpErr *HTTPStatusError
	if errors.As(err, &httpErr) {
		return httpErr.StatusCode >= 500
	}

	// Sub-context deadline exceeded (the caller's context is still alive at this point)
	if errors.Is(err, context.DeadlineExceeded) {
		return true
	}

	// Context canceled from sub-context (caller ctx is still alive)
	if errors.Is(err, context.Canceled) {
		return true
	}

	return false
}
