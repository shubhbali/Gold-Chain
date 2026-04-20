package giltconsensusgrpc

import (
	"context"
	"crypto/tls"
	"fmt"
	"net"
	"net/url"
	"strings"
	"time"

	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/credentials"
	"google.golang.org/grpc/credentials/insecure"

	grpcRetry "github.com/grpc-ecosystem/go-grpc-middleware/retry"

	"github.com/ethereum/go-ethereum/consensus/gilt/consensusclient"
	"github.com/ethereum/go-ethereum/log"

	giltTypes "github.com/giltchain/gilt-consensus/x/gilt/types"
	checkpointTypes "github.com/giltchain/gilt-consensus/x/checkpoint/types"
	clerkTypes "github.com/giltchain/gilt-consensus/x/clerk/types"
	milestoneTypes "github.com/giltchain/gilt-consensus/x/milestone/types"
	ctypes "github.com/cometbft/cometbft/rpc/core/types"
)

const (
	stateFetchLimit = 50
	defaultTimeout  = 30 * time.Second
)

type GiltConsensusGRPCClient struct {
	conn                  *grpc.ClientConn
	client                *giltconsensus.GiltConsensusClient
	giltQueryClient        giltTypes.QueryClient
	checkpointQueryClient checkpointTypes.QueryClient
	clerkQueryClient      clerkTypes.QueryClient
	milestoneQueryClient  milestoneTypes.QueryClient
}

// NewGiltConsensusGRPCClient creates a new GiltConsensus gRPC client with appropriate credentials
// based on the provided address scheme.
func NewGiltConsensusGRPCClient(grpcAddress string, giltconsensusURL string, timeout time.Duration) (*GiltConsensusGRPCClient, error) {
	addr := grpcAddress
	var dialOpts []grpc.DialOption

	log.Info("Setting up GiltConsensus gRPC client", "address", grpcAddress)

	// URL mode
	if strings.Contains(grpcAddress, "://") {
		// Decide credentials and normalized address based on the provided scheme
		u, err := url.Parse(grpcAddress)
		if err != nil {
			log.Error("Invalid GiltConsensus gRPC URL", "url", grpcAddress, "err", err)
			return nil, err
		}

		switch u.Scheme {
		case "https":
			// Remote secure connection
			addr = u.Host
			if addr == "" {
				err := fmt.Errorf("invalid GiltConsensus gRPC https URL %q: empty host", grpcAddress)
				log.Error("Invalid GiltConsensus gRPC https URL", "url", grpcAddress, "err", err)
				return nil, err
			}

			tlsCfg := &tls.Config{
				ServerName: strings.Split(addr, ":")[0],
				MinVersion: tls.VersionTLS12,
			}
			dialOpts = append(dialOpts,
				grpc.WithTransportCredentials(credentials.NewTLS(tlsCfg)),
			)

		case "http":
			// plaintext only allowed for local host
			addr = u.Host
			if !isLocalhost(addr) {
				err := fmt.Errorf("insecure non-local GiltConsensus gRPC over http is not allowed (addr=%s); use https://host:port", addr)
				log.Error("Refusing insecure non-local GiltConsensus gRPC over http", "addr", addr, "err", err)
				return nil, err
			}
			dialOpts = append(dialOpts,
				grpc.WithTransportCredentials(insecure.NewCredentials()),
			)

		case "unix":
			// support unix://path for on-box GiltConsensus nodes
			path := u.Path
			if path == "" {
				err := fmt.Errorf("invalid unix GiltConsensus gRPC URL %q: empty path", grpcAddress)
				log.Error("Invalid unix GiltConsensus gRPC URL", "url", grpcAddress, "err", err)
				return nil, err
			}
			addr = "unix://" + path
			dialOpts = append(dialOpts,
				grpc.WithContextDialer(func(ctx context.Context, addr string) (net.Conn, error) {
					//nolint:noctx // used in grpc.WithContextDialer
					return net.DialTimeout("unix", strings.TrimPrefix(addr, "unix://"), timeout)
				}),
				grpc.WithTransportCredentials(insecure.NewCredentials()),
			)

		default:
			err := fmt.Errorf("unsupported GiltConsensus gRPC URL scheme %q in %q", u.Scheme, grpcAddress)
			log.Error("Unsupported GiltConsensus gRPC URL scheme", "url", grpcAddress, "scheme", u.Scheme, "err", err)
			return nil, err
		}
	} else {
		// No scheme provided, treat as host:port, but only allow if local
		if !isLocalhost(addr) {
			err := fmt.Errorf("insecure non-local GiltConsensus gRPC without scheme (addr=%s); use https://host:port", addr)
			log.Error("Refusing insecure non-local GiltConsensus gRPC without scheme", "addr", addr, "err", err)
			return nil, err
		}
		dialOpts = append(dialOpts,
			grpc.WithTransportCredentials(insecure.NewCredentials()),
		)
	}

	// Retry options
	retryOpts := []grpcRetry.CallOption{
		grpcRetry.WithMax(25),
		grpcRetry.WithBackoff(grpcRetry.BackoffLinear(5 * time.Second)),
		grpcRetry.WithCodes(codes.Internal, codes.Unavailable, codes.Aborted, codes.NotFound),
	}

	dialOpts = append(dialOpts,
		grpc.WithStreamInterceptor(grpcRetry.StreamClientInterceptor(retryOpts...)),
		grpc.WithUnaryInterceptor(grpcRetry.UnaryClientInterceptor(retryOpts...)),
	)

	// dial using address and dialOpts
	conn, err := grpc.NewClient(addr, dialOpts...)
	if err != nil {
		log.Error("Failed to connect to GiltConsensus gRPC", "addr", addr, "error", err)
		return nil, err
	}

	log.Info("Connected to GiltConsensus gRPC server", "grpcAddress", grpcAddress, "dialAddr", addr)

	return &GiltConsensusGRPCClient{
		conn:                  conn,
		client:                giltconsensus.NewGiltConsensusClient(giltconsensusURL, timeout),
		giltQueryClient:        giltTypes.NewQueryClient(conn),
		checkpointQueryClient: checkpointTypes.NewQueryClient(conn),
		clerkQueryClient:      clerkTypes.NewQueryClient(conn),
		milestoneQueryClient:  milestoneTypes.NewQueryClient(conn),
	}, nil
}

func (h *GiltConsensusGRPCClient) Close() {
	if h == nil || h.conn == nil {
		return
	}
	log.Debug("Shutdown detected, Closing GiltConsensus gRPC client")
	err := h.conn.Close()
	if err != nil {
		log.Error("Error closing GiltConsensus gRPC client connection", "err", err)
	}
}

func (h *GiltConsensusGRPCClient) FetchStatus(ctx context.Context) (*ctypes.SyncInfo, error) {
	return h.client.FetchStatus(ctx)
}

// isLocalhost returns true if host/port refers to localhost/loopback.
func isLocalhost(hostport string) bool {
	host, _, err := net.SplitHostPort(hostport)
	if err != nil {
		host = hostport
	}
	if host == "localhost" {
		return true
	}
	ip := net.ParseIP(host)
	return ip != nil && ip.IsLoopback()
}
