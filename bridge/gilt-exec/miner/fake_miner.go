package miner

import (
	"errors"
	"math/big"
	"testing"

	giltTypes "github.com/giltchain/gilt-consensus/x/gilt/types"
	ctypes "github.com/cometbft/cometbft/rpc/core/types"
	"go.uber.org/mock/gomock"

	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/consensus"
	"github.com/ethereum/go-ethereum/consensus/gilt"
	"github.com/ethereum/go-ethereum/consensus/gilt/api"
	"github.com/ethereum/go-ethereum/consensus/gilt/consensusclient/milestone"
	giltSpan "github.com/ethereum/go-ethereum/consensus/gilt/consensusclient/span"
	"github.com/ethereum/go-ethereum/consensus/gilt/valset"
	"github.com/ethereum/go-ethereum/core"
	"github.com/ethereum/go-ethereum/core/rawdb"
	"github.com/ethereum/go-ethereum/core/state"
	"github.com/ethereum/go-ethereum/core/txpool"
	"github.com/ethereum/go-ethereum/core/txpool/legacypool"
	"github.com/ethereum/go-ethereum/core/types"
	"github.com/ethereum/go-ethereum/ethdb"
	"github.com/ethereum/go-ethereum/ethdb/memorydb"
	"github.com/ethereum/go-ethereum/event"
	"github.com/ethereum/go-ethereum/params"
	"github.com/ethereum/go-ethereum/tests/gilt/mocks"
	"github.com/ethereum/go-ethereum/triedb"
)

type DefaultGiltMiner struct {
	Miner   *Miner
	Mux     *event.TypeMux //nolint:staticcheck
	Cleanup func(skipMiner bool)

	Ctrl               *gomock.Controller
	EthAPIMock         api.Caller
	GiltConsensusClientMock gilt.IGiltConsensusClient
	ContractMock       gilt.GenesisContract
}

func NewGiltDefaultMiner(t *testing.T) *DefaultGiltMiner {
	t.Helper()

	ctrl := gomock.NewController(t)

	ethAPI := api.NewMockCaller(ctrl)
	ethAPI.EXPECT().Call(gomock.Any(), gomock.Any(), gomock.Any(), gomock.Any(), gomock.Any()).AnyTimes()

	// Mock span 0 for giltconsensus
	span0 := createMockSpanForTest(common.Address{0x1}, "1337")

	validators := make([]*valset.Validator, len(span0.ValidatorSet.Validators))
	for i, v := range span0.ValidatorSet.Validators {
		validators[i] = &valset.Validator{
			Address:     common.HexToAddress(v.Signer),
			VotingPower: v.VotingPower,
		}
	}

	spanner := gilt.NewMockSpanner(ctrl)
	spanner.EXPECT().GetCurrentValidatorsByHash(gomock.Any(), gomock.Any(), gomock.Any()).Return(giltSpan.ConvertGiltConsensusValSetToGiltValSet(span0.ValidatorSet).Validators, nil).AnyTimes()

	giltconsensusClient := mocks.NewMockIGiltConsensusClient(ctrl)
	giltconsensusWSClient := mocks.NewMockIGiltConsensusWSClient(ctrl)
	giltconsensusClient.EXPECT().GetSpan(gomock.Any(), uint64(0)).Return(&span0, nil).AnyTimes()
	giltconsensusClient.EXPECT().GetLatestSpan(gomock.Any()).Return(&span0, nil).AnyTimes()
	giltconsensusClient.EXPECT().FetchMilestone(gomock.Any()).Return(&milestone.Milestone{}, nil).AnyTimes()
	giltconsensusClient.EXPECT().FetchStatus(gomock.Any()).Return(&ctypes.SyncInfo{CatchingUp: false}, nil).AnyTimes()
	giltconsensusClient.EXPECT().Close().Times(1)

	genesisContracts := gilt.NewMockGenesisContract(ctrl)

	miner, mux, cleanup := createGiltMiner(t, ethAPI, spanner, giltconsensusClient, giltconsensusWSClient, genesisContracts)

	return &DefaultGiltMiner{
		Miner:              miner,
		Mux:                mux,
		Cleanup:            cleanup,
		Ctrl:               ctrl,
		EthAPIMock:         ethAPI,
		GiltConsensusClientMock: giltconsensusClient,
		ContractMock:       genesisContracts,
	}
}

// //nolint:staticcheck
func createGiltMiner(t *testing.T, ethAPIMock api.Caller, spanner gilt.Spanner, giltconsensusClientMock gilt.IGiltConsensusClient, giltconsensusClientWSMock gilt.IGiltConsensusWSClient, contractMock gilt.GenesisContract) (*Miner, *event.TypeMux, func(skipMiner bool)) {
	t.Helper()

	// Create Ethash config
	chainDB, genspec, chainConfig := NewDBForFakes(t)

	engine := NewFakeGilt(t, chainDB, chainConfig, ethAPIMock, spanner, giltconsensusClientMock, giltconsensusClientWSMock, contractMock)

	// Create Ethereum backend
	bc, err := core.NewBlockChain(chainDB, genspec, engine, core.DefaultConfig())
	if err != nil {
		t.Fatalf("can't create new chain %v", err)
	}

	statedb, _ := state.New(common.Hash{}, state.NewDatabase(triedb.NewDatabase(rawdb.NewMemoryDatabase(), nil), nil))
	blockchain := &testBlockChainGilt{chainConfig, statedb, 10000000, new(event.Feed)}

	pool := legacypool.New(testTxPoolConfigGilt, blockchain)
	txpool, _ := txpool.New(testTxPoolConfigGilt.PriceLimit, blockchain, []txpool.SubPool{pool})

	backend := NewMockBackendGilt(bc, txpool)

	// Create event Mux
	mux := new(event.TypeMux)

	config := Config{
		Etherbase: common.HexToAddress("123456789"),
	}

	// Create Miner
	miner := New(backend, &config, chainConfig, mux, engine, nil, false)

	cleanup := func(skipMiner bool) {
		bc.Stop()
		engine.Close()

		if !skipMiner {
			miner.Close()
		}
	}

	return miner, mux, cleanup
}

type TensingObject interface {
	Helper()
	Fatalf(format string, args ...any)
}

func NewDBForFakes(t TensingObject) (ethdb.Database, *core.Genesis, *params.ChainConfig) {
	t.Helper()

	memdb := memorydb.New()
	chainDB := rawdb.NewDatabase(memdb)
	addr := common.HexToAddress("12345")
	genesis := core.DeveloperGenesisBlock(11_500_000, &addr)

	chainConfig, _, err, _ := core.SetupGenesisBlock(chainDB, triedb.NewDatabase(chainDB, triedb.HashDefaults), genesis)
	if err != nil {
		t.Fatalf("can't create new chain config: %v", err)
	}

	// Make a copy of GiltConfig to avoid race conditions with parallel tests
	if chainConfig.Gilt != nil {
		giltCopy := *chainConfig.Gilt
		chainConfig.Gilt = &giltCopy
	}

	chainConfig.Gilt.Period = map[string]uint64{
		"0": 1,
	}
	chainConfig.Gilt.Sprint = map[string]uint64{
		"0": 64,
	}

	return chainDB, genesis, chainConfig
}

func NewFakeGilt(t TensingObject, chainDB ethdb.Database, chainConfig *params.ChainConfig, ethAPIMock api.Caller, spanner gilt.Spanner, giltconsensusClientMock gilt.IGiltConsensusClient, giltconsensusClientWSMock gilt.IGiltConsensusWSClient, contractMock gilt.GenesisContract) consensus.Engine {
	t.Helper()

	if chainConfig.Gilt == nil {
		chainConfig.Gilt = params.GiltUnittestChainConfig.Gilt
	}

	return gilt.New(chainConfig, chainDB, ethAPIMock, spanner, giltconsensusClientMock, giltconsensusClientWSMock, contractMock, false, 0)
}

func createMockSpanForTest(address common.Address, chainId string) giltTypes.Span {
	// Mock span 0 for giltconsensus calls
	validator := valset.Validator{
		ID:               0,
		Address:          address,
		VotingPower:      100,
		ProposerPriority: 0,
	}
	validatorSet := valset.ValidatorSet{
		Validators: []*valset.Validator{&validator},
		Proposer:   &validator,
	}
	span0 := giltTypes.Span{
		Id:                0,
		StartBlock:        0,
		EndBlock:          255,
		ValidatorSet:      giltSpan.ConvertGiltValSetToGiltConsensusValSet(&validatorSet),
		SelectedProducers: giltSpan.ConvertGiltValidatorsToGiltConsensusValidators([]*valset.Validator{&validator}),
		GiltChainId:        chainId,
	}

	return span0
}

var (
	// Test chain configurations
	testTxPoolConfigGilt legacypool.Config
)

// TODO - Arpit, Duplicate Functions
type mockBackendGilt struct {
	bc     *core.BlockChain
	txPool *txpool.TxPool
}

func NewMockBackendGilt(bc *core.BlockChain, txPool *txpool.TxPool) *mockBackendGilt {
	return &mockBackendGilt{
		bc:     bc,
		txPool: txPool,
	}
}

func (m *mockBackendGilt) BlockChain() *core.BlockChain {
	return m.bc
}

// PeerCount implements Backend.
func (*mockBackendGilt) PeerCount() int {
	panic("unimplemented")
}

func (m *mockBackendGilt) TxPool() *txpool.TxPool {
	return m.txPool
}

func (m *mockBackendGilt) StateAtBlock(block *types.Block, reexec uint64, base *state.StateDB, checkLive bool, preferDisk bool) (statedb *state.StateDB, err error) {
	return nil, errors.New("not supported")
}

// TODO - Arpit, Duplicate Functions
type testBlockChainGilt struct {
	config        *params.ChainConfig
	statedb       *state.StateDB
	gasLimit      uint64
	chainHeadFeed *event.Feed
}

func (bc *testBlockChainGilt) Config() *params.ChainConfig {
	return bc.config
}

func (bc *testBlockChainGilt) CurrentBlock() *types.Header {
	return &types.Header{
		Number:   new(big.Int),
		GasLimit: bc.gasLimit,
	}
}

func (bc *testBlockChainGilt) GetBlock(hash common.Hash, number uint64) *types.Block {
	return types.NewBlock(bc.CurrentBlock(), nil, nil, nil)
}

func (bc *testBlockChainGilt) StateAt(common.Hash) (*state.StateDB, error) {
	return bc.statedb, nil
}

func (bc *testBlockChainGilt) SubscribeChainHeadEvent(ch chan<- core.ChainHeadEvent) event.Subscription {
	return bc.chainHeadFeed.Subscribe(ch)
}
