package ethconfig

import (
	"context"
	"math/big"
	"testing"

	giltTypes "github.com/giltchain/gilt-consensus/x/gilt/types"
	stakeTypes "github.com/giltchain/gilt-consensus/x/stake/types"
	ctypes "github.com/cometbft/cometbft/rpc/core/types"
	"github.com/ethereum/go-ethereum/consensus/gilt"
	"github.com/ethereum/go-ethereum/consensus/gilt/clerk"
	"github.com/ethereum/go-ethereum/consensus/gilt/consensusclient"
	"github.com/ethereum/go-ethereum/consensus/gilt/consensusclient/checkpoint"
	"github.com/ethereum/go-ethereum/consensus/gilt/consensusclient/milestone"
	"github.com/ethereum/go-ethereum/consensus/gilt/consensusws"
	"github.com/ethereum/go-ethereum/core/rawdb"
	"github.com/ethereum/go-ethereum/params"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

// mockGiltConsensusClient implements gilt.IGiltConsensusClient for testing
type mockGiltConsensusClient struct{}

func (m *mockGiltConsensusClient) Close() {}
func (m *mockGiltConsensusClient) StateSyncEvents(context.Context, uint64, int64) ([]*clerk.EventRecordWithTime, error) {
	return nil, nil
}
func (m *mockGiltConsensusClient) GetSpan(_ context.Context, spanID uint64) (*giltTypes.Span, error) {
	return &giltTypes.Span{
		Id: spanID, StartBlock: 0, EndBlock: 255,
		ValidatorSet: stakeTypes.ValidatorSet{
			Validators: []*stakeTypes.Validator{{ValId: 1, Signer: "0x96C42C56fdb78294F96B0cFa33c92bed7D75F96a", VotingPower: 100}},
		},
	}, nil
}
func (m *mockGiltConsensusClient) GetLatestSpan(ctx context.Context) (*giltTypes.Span, error) {
	return m.GetSpan(ctx, 0)
}
func (m *mockGiltConsensusClient) FetchCheckpoint(context.Context, int64) (*checkpoint.Checkpoint, error) {
	return nil, nil
}
func (m *mockGiltConsensusClient) FetchCheckpointCount(context.Context) (int64, error) { return 0, nil }
func (m *mockGiltConsensusClient) FetchMilestone(context.Context) (*milestone.Milestone, error) {
	return nil, nil
}
func (m *mockGiltConsensusClient) FetchMilestoneCount(context.Context) (int64, error) { return 0, nil }
func (m *mockGiltConsensusClient) FetchStatus(context.Context) (*ctypes.SyncInfo, error) {
	return &ctypes.SyncInfo{CatchingUp: false}, nil
}

// newTestGiltChainConfig creates a minimal Gilt chain config for testing
func newTestGiltChainConfig() *params.ChainConfig {
	return &params.ChainConfig{
		ChainID:             big.NewInt(137),
		HomesteadBlock:      big.NewInt(0),
		EIP150Block:         big.NewInt(0),
		EIP155Block:         big.NewInt(0),
		EIP158Block:         big.NewInt(0),
		ByzantiumBlock:      big.NewInt(0),
		ConstantinopleBlock: big.NewInt(0),
		PetersburgBlock:     big.NewInt(0),
		IstanbulBlock:       big.NewInt(0),
		MuirGlacierBlock:    big.NewInt(0),
		BerlinBlock:         big.NewInt(0),
		LondonBlock:         big.NewInt(0),
		Gilt: &params.GiltConfig{
			Period:                map[string]uint64{"0": 2},
			ProducerDelay:         map[string]uint64{"0": 4},
			Sprint:                map[string]uint64{"0": 64},
			BackupMultiplier:      map[string]uint64{"0": 2},
			ValidatorContract:     "0x0000000000000000000000000000000000001000",
			StateReceiverContract: "0x0000000000000000000000000000000000001001",
		},
	}
}

func TestCreateConsensusEngine_OverrideGiltConsensusClient(t *testing.T) {
	t.Parallel()
	ethConfig := &Config{
		OverrideGiltConsensusClient: &mockGiltConsensusClient{},
		WithoutGiltConsensus:        false,
	}

	engine, err := CreateConsensusEngine(newTestGiltChainConfig(), ethConfig, rawdb.NewMemoryDatabase(), nil)
	require.NoError(t, err)
	defer engine.Close()

	_, ok := engine.(*gilt.Gilt)
	require.True(t, ok, "Expected Gilt consensus engine")
}

func TestCreateConsensusEngine_CommaSeparatedGiltConsensusURL(t *testing.T) {
	t.Parallel()
	ethConfig := &Config{
		GiltConsensusURL: "http://primary:1317,http://secondary:1317",
	}

	engine, err := CreateConsensusEngine(newTestGiltChainConfig(), ethConfig, rawdb.NewMemoryDatabase(), nil)
	require.NoError(t, err)
	defer engine.Close()

	giltEngine, ok := engine.(*gilt.Gilt)
	require.True(t, ok, "Expected Gilt consensus engine")

	_, ok = giltEngine.GiltConsensusClient.(*giltconsensus.MultiGiltConsensusClient)
	require.True(t, ok, "Expected GiltConsensusClient to be wrapped in MultiGiltConsensusClient")
}

func TestCreateConsensusEngine_SingleGiltConsensusURL(t *testing.T) {
	t.Parallel()
	ethConfig := &Config{
		GiltConsensusURL: "http://primary:1317",
	}

	engine, err := CreateConsensusEngine(newTestGiltChainConfig(), ethConfig, rawdb.NewMemoryDatabase(), nil)
	require.NoError(t, err)
	defer engine.Close()

	giltEngine, ok := engine.(*gilt.Gilt)
	require.True(t, ok, "Expected Gilt consensus engine")

	// Single URL should NOT produce a MultiGiltConsensusClient
	_, ok = giltEngine.GiltConsensusClient.(*giltconsensus.MultiGiltConsensusClient)
	require.False(t, ok, "Expected no MultiGiltConsensusClient for single URL")
}

func TestCreateConsensusEngine_WithoutGiltConsensus(t *testing.T) {
	t.Parallel()
	ethConfig := &Config{WithoutGiltConsensus: true}

	engine, err := CreateConsensusEngine(newTestGiltChainConfig(), ethConfig, rawdb.NewMemoryDatabase(), nil)
	require.NoError(t, err)
	defer engine.Close()

	_, ok := engine.(*gilt.Gilt)
	require.True(t, ok, "Expected Gilt consensus engine")
}

func TestCreateConsensusEngine_CommaSeparatedGRPC(t *testing.T) {
	t.Parallel()
	ethConfig := &Config{
		GiltConsensusURL:         "http://primary:1317,http://secondary:1317",
		GiltConsensusgRPCAddress: "localhost:50051,localhost:50052",
	}

	engine, err := CreateConsensusEngine(newTestGiltChainConfig(), ethConfig, rawdb.NewMemoryDatabase(), nil)
	require.NoError(t, err)
	defer engine.Close()

	giltEngine, ok := engine.(*gilt.Gilt)
	require.True(t, ok, "Expected Gilt consensus engine")

	_, ok = giltEngine.GiltConsensusClient.(*giltconsensus.MultiGiltConsensusClient)
	require.True(t, ok, "Expected MultiGiltConsensusClient with multiple gRPC endpoints")
}

func TestCreateConsensusEngine_GRPCInitFailsFallsBackToHTTP(t *testing.T) {
	t.Parallel()

	tests := []struct {
		name           string
		giltconsensusURL    string
		grpcAddress    string
		expectFailover bool
	}{
		{
			// gRPC uses unsupported scheme → NewGiltConsensusGRPCClient fails.
			// Fallback appends HTTP client for httpURLs[0]; httpURLs[1] also
			// gets an HTTP client via the else-if branch → 2 clients → failover.
			name:           "with HTTP URL available",
			giltconsensusURL:    "http://a:1317,http://b:1317",
			grpcAddress:    "ftp://invalid:50051",
			expectFailover: true,
		},
		{
			// gRPC[0] succeeds (localhost is allowed), gRPC[1] fails (bad scheme).
			// i=1 >= len(httpURLs)=1 so no HTTP fallback is added → only 1 client.
			name:           "without HTTP URL at that index",
			giltconsensusURL:    "http://a:1317",
			grpcAddress:    "localhost:50051,ftp://invalid:50052",
			expectFailover: false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			t.Parallel()

			ethConfig := &Config{
				GiltConsensusURL:         tt.giltconsensusURL,
				GiltConsensusgRPCAddress: tt.grpcAddress,
			}

			engine, err := CreateConsensusEngine(newTestGiltChainConfig(), ethConfig, rawdb.NewMemoryDatabase(), nil)
			require.NoError(t, err)
			defer engine.Close()

			giltEngine, ok := engine.(*gilt.Gilt)
			require.True(t, ok, "Expected Gilt consensus engine")

			_, ok = giltEngine.GiltConsensusClient.(*giltconsensus.MultiGiltConsensusClient)
			require.Equal(t, tt.expectFailover, ok)
		})
	}
}

func TestCreateConsensusEngine_WSAddress(t *testing.T) {
	t.Parallel()

	tests := []struct {
		name string
		addr string
	}{
		{"comma-separated", "ws://localhost:26657,ws://secondary:26657"},
		{"primary only", "ws://localhost:26657"},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			t.Parallel()

			ethConfig := &Config{
				OverrideGiltConsensusClient: &mockGiltConsensusClient{},
				GiltConsensusWSAddress:      tt.addr,
			}

			engine, err := CreateConsensusEngine(newTestGiltChainConfig(), ethConfig, rawdb.NewMemoryDatabase(), nil)
			require.NoError(t, err)
			defer engine.Close()

			giltEngine, ok := engine.(*gilt.Gilt)
			require.True(t, ok, "Expected Gilt consensus engine")

			require.NotNil(t, giltEngine.GiltConsensusWSClient, "Expected non-nil GiltConsensusWSClient")

			_, ok = giltEngine.GiltConsensusWSClient.(*giltconsensusws.GiltConsensusWSClient)
			require.True(t, ok, "Expected GiltConsensusWSClient type")
		})
	}
}

func TestCreateConsensusEngine_NoWSAddress(t *testing.T) {
	t.Parallel()

	ethConfig := &Config{
		OverrideGiltConsensusClient: &mockGiltConsensusClient{},
		// No GiltConsensusWSAddress set
	}

	engine, err := CreateConsensusEngine(newTestGiltChainConfig(), ethConfig, rawdb.NewMemoryDatabase(), nil)
	require.NoError(t, err)
	defer engine.Close()

	giltEngine, ok := engine.(*gilt.Gilt)
	require.True(t, ok, "Expected Gilt consensus engine")

	require.Nil(t, giltEngine.GiltConsensusWSClient, "Expected nil GiltConsensusWSClient when no WS address configured")
}

func TestParseURLs(t *testing.T) {
	t.Parallel()

	tests := []struct {
		name     string
		input    string
		expected []string
	}{
		{"empty string", "", nil},
		{"single URL", "http://localhost:1317", []string{"http://localhost:1317"}},
		{"two URLs", "http://a:1317,http://b:1317", []string{"http://a:1317", "http://b:1317"}},
		{"three URLs", "http://a:1317,http://b:1317,http://c:1317", []string{"http://a:1317", "http://b:1317", "http://c:1317"}},
		{"whitespace trimmed", " http://a:1317 , http://b:1317 ", []string{"http://a:1317", "http://b:1317"}},
		{"trailing comma", "http://a:1317,", []string{"http://a:1317"}},
		{"leading comma", ",http://a:1317", []string{"http://a:1317"}},
		{"empty entries filtered", "http://a:1317,,http://b:1317", []string{"http://a:1317", "http://b:1317"}},
		{"only commas", ",,,", nil},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			t.Parallel()
			result := parseURLs(tt.input)
			assert.Equal(t, tt.expected, result)
		})
	}
}
