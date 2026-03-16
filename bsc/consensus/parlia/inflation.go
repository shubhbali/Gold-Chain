package parlia

import (
	"context"
	"math/big"

	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/common/hexutil"
	"github.com/ethereum/go-ethereum/core"
	"github.com/ethereum/go-ethereum/core/systemcontracts"
	"github.com/ethereum/go-ethereum/core/tracing"
	"github.com/ethereum/go-ethereum/core/types"
	"github.com/ethereum/go-ethereum/core/vm"
	"github.com/ethereum/go-ethereum/crypto"
	"github.com/ethereum/go-ethereum/internal/ethapi"
	"github.com/ethereum/go-ethereum/log"
	"github.com/ethereum/go-ethereum/params"
	"github.com/ethereum/go-ethereum/rpc"
	"github.com/holiman/uint256"
)

var (
	inflationPowerScale  = big.NewInt(10_000)
	inflationSecondsYear = big.NewInt(365 * 24 * 60 * 60)
)

type stakeHubInflationState struct {
	enabled           bool
	startDayIndex     uint64
	initialBps        uint64
	minBps            uint64
	decayBpsPerYear   uint64
	baseSupply        *big.Int
	mintedAmount      *big.Int
	lastMintTimestamp uint64
}

func (p *Parlia) distributeInflation(
	val common.Address,
	state vm.StateDB,
	header *types.Header,
	chain core.ChainContext,
	txs *[]*types.Transaction,
	receipts *[]*types.Receipt,
	receivedTxs *[]*types.Transaction,
	usedGas *uint64,
	mining bool,
	tracer *tracing.Hooks,
) error {
	if p.ethAPI == nil {
		return nil
	}

	blockNr := rpc.BlockNumberOrHashWithHash(header.ParentHash, false)
	inflationState, err := p.loadStakeHubInflationState(blockNr)
	if err != nil {
		return err
	}
	if inflationState == nil {
		return nil
	}

	amount := mintableInflationReward(inflationState, header.Time)
	if amount.Sign() <= 0 {
		return nil
	}

	state.AddBalance(header.Coinbase, uint256.MustFromBig(amount), tracing.BalanceChangeUnspecified)
	log.Trace("mint direct inflation reward", "block hash", header.Hash(), "amount", amount)
	return p.distributeInflationToValidator(amount, val, state, header, chain, txs, receipts, receivedTxs, usedGas, mining, tracer)
}

func (p *Parlia) distributeInflationToValidator(
	amount *big.Int,
	validator common.Address,
	state vm.StateDB,
	header *types.Header,
	chain core.ChainContext,
	txs *[]*types.Transaction,
	receipts *[]*types.Receipt,
	receivedTxs *[]*types.Transaction,
	usedGas *uint64,
	mining bool,
	tracer *tracing.Hooks,
) error {
	data := encodeSingleAddressCall("depositInflation(address)", validator)
	msg := p.getSystemMessage(header.Coinbase, common.HexToAddress(systemcontracts.ValidatorContract), data, amount)
	return p.applyTransaction(msg, state, header, chain, txs, receipts, receivedTxs, usedGas, mining, tracer)
}

func (p *Parlia) loadStakeHubInflationState(blockNr rpc.BlockNumberOrHash) (*stakeHubInflationState, error) {
	enabled, err := p.callStakeHubBool(blockNr, "inflationEnabled()")
	if err != nil || !enabled {
		return nil, err
	}
	startDayIndex, err := p.callStakeHubUint64(blockNr, "inflationStartDayIndex()")
	if err != nil {
		return nil, err
	}
	initialBps, err := p.callStakeHubUint64(blockNr, "inflationRateInitialBps()")
	if err != nil {
		return nil, err
	}
	minBps, err := p.callStakeHubUint64(blockNr, "inflationRateMinBps()")
	if err != nil {
		return nil, err
	}
	decayBpsPerYear, err := p.callStakeHubUint64(blockNr, "inflationDecayBpsPerYear()")
	if err != nil {
		return nil, err
	}
	baseSupply, err := p.callStakeHubUint256(blockNr, "inflationBaseSupply()")
	if err != nil {
		return nil, err
	}
	mintedAmount, err := p.callStakeHubUint256(blockNr, "inflationMintedAmount()")
	if err != nil {
		return nil, err
	}
	lastMintTimestamp, err := p.callStakeHubUint64(blockNr, "inflationLastMintTimestamp()")
	if err != nil {
		return nil, err
	}
	return &stakeHubInflationState{
		enabled:           enabled,
		startDayIndex:     startDayIndex,
		initialBps:        initialBps,
		minBps:            minBps,
		decayBpsPerYear:   decayBpsPerYear,
		baseSupply:        baseSupply,
		mintedAmount:      mintedAmount,
		lastMintTimestamp: lastMintTimestamp,
	}, nil
}

func (p *Parlia) callStakeHubBool(blockNr rpc.BlockNumberOrHash, methodSig string) (bool, error) {
	result, err := p.callStakeHub(blockNr, selectorCallData(methodSig))
	if err != nil {
		return false, err
	}
	if len(result) == 0 {
		return false, nil
	}
	return result[len(result)-1] == 1, nil
}

func (p *Parlia) callStakeHubUint64(blockNr rpc.BlockNumberOrHash, methodSig string) (uint64, error) {
	value, err := p.callStakeHubUint256(blockNr, methodSig)
	if err != nil {
		return 0, err
	}
	return value.Uint64(), nil
}

func (p *Parlia) callStakeHubUint256(blockNr rpc.BlockNumberOrHash, methodSig string) (*big.Int, error) {
	result, err := p.callStakeHub(blockNr, selectorCallData(methodSig))
	if err != nil {
		return nil, err
	}
	if len(result) == 0 {
		return new(big.Int), nil
	}
	return new(big.Int).SetBytes(result), nil
}

func (p *Parlia) callStakeHub(blockNr rpc.BlockNumberOrHash, data []byte) (hexutil.Bytes, error) {
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	toAddress := common.HexToAddress(systemcontracts.StakeHubContract)
	gas := hexutil.Uint64(^uint64(0) / 2)
	msgData := hexutil.Bytes(data)
	return p.ethAPI.Call(ctx, ethapi.TransactionArgs{
		Gas:  &gas,
		To:   &toAddress,
		Data: &msgData,
	}, &blockNr, nil, nil)
}

func mintableInflationReward(cfg *stakeHubInflationState, blockTime uint64) *big.Int {
	if cfg == nil || !cfg.enabled || cfg.baseSupply.Sign() == 0 {
		return new(big.Int)
	}
	if cfg.lastMintTimestamp == 0 || blockTime <= cfg.lastMintTimestamp {
		return new(big.Int)
	}

	currentTs := cfg.lastMintTimestamp
	effectiveSupply := new(big.Int).Add(new(big.Int).Set(cfg.baseSupply), cfg.mintedAmount)
	totalMint := new(big.Int)

	for currentTs < blockTime {
		dayIndex := currentTs / params.BreatheBlockInterval
		currentBps := currentInflationBpsForDay(cfg, dayIndex)
		if currentBps == 0 {
			break
		}

		nextBoundaryTs := blockTime
		nextBoundaryDay := nextInflationBoundaryDay(cfg.startDayIndex, dayIndex)
		if nextBoundaryDay != 0 {
			boundaryTs := nextBoundaryDay * params.BreatheBlockInterval
			if boundaryTs > currentTs && boundaryTs < nextBoundaryTs {
				nextBoundaryTs = boundaryTs
			}
		}
		if nextBoundaryTs <= currentTs {
			break
		}

		elapsed := nextBoundaryTs - currentTs
		chunkMint := new(big.Int).Mul(effectiveSupply, new(big.Int).SetUint64(currentBps))
		chunkMint.Mul(chunkMint, new(big.Int).SetUint64(elapsed))
		chunkMint.Div(chunkMint, inflationPowerScale)
		chunkMint.Div(chunkMint, inflationSecondsYear)

		if chunkMint.Sign() > 0 {
			totalMint.Add(totalMint, chunkMint)
			effectiveSupply.Add(effectiveSupply, chunkMint)
		}
		currentTs = nextBoundaryTs
	}
	return totalMint
}

func currentInflationBpsForDay(cfg *stakeHubInflationState, dayIndex uint64) uint64 {
	if dayIndex <= cfg.startDayIndex {
		return cfg.initialBps
	}
	yearsElapsed := (dayIndex - cfg.startDayIndex) / 365
	current := cfg.initialBps
	for i := uint64(0); i < yearsElapsed; i++ {
		current = (current * (10_000 - cfg.decayBpsPerYear)) / 10_000
		if current <= cfg.minBps {
			return cfg.minBps
		}
	}
	if current < cfg.minBps {
		return cfg.minBps
	}
	return current
}

func nextInflationBoundaryDay(startDayIndex uint64, dayIndex uint64) uint64 {
	if dayIndex <= startDayIndex {
		return startDayIndex + 365
	}
	yearsElapsed := (dayIndex - startDayIndex) / 365
	return startDayIndex + (yearsElapsed+1)*365
}

func selectorCallData(methodSig string) []byte {
	return crypto.Keccak256([]byte(methodSig))[:4]
}

func encodeSingleAddressCall(methodSig string, addr common.Address) []byte {
	data := make([]byte, 4+32)
	copy(data[:4], selectorCallData(methodSig))
	copy(data[4+12:], addr.Bytes())
	return data
}
