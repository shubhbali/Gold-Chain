package parlia

import (
	"encoding/binary"
	"errors"
	"math"
	"math/big"

	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/consensus"
	"github.com/ethereum/go-ethereum/core"
	"github.com/ethereum/go-ethereum/core/systemcontracts"
	"github.com/ethereum/go-ethereum/core/tracing"
	"github.com/ethereum/go-ethereum/core/types"
	"github.com/ethereum/go-ethereum/core/vm"
	"github.com/ethereum/go-ethereum/crypto"
	"github.com/ethereum/go-ethereum/log"
	"github.com/holiman/uint256"
)

type stakeHubInflationState struct {
	enabled            bool
	dayIndex           uint64
	expectedMintAmount *big.Int
	mintedByDay        *big.Int
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
	inflationState, err := p.loadStakeHubInflationState(state, header, chain)
	if err != nil {
		return err
	}
	if inflationState == nil {
		return nil
	}

	amount := mintableInflationReward(inflationState)
	if amount.Sign() <= 0 {
		return nil
	}

	snapshot := state.Snapshot()
	state.AddBalance(header.Coinbase, uint256.MustFromBig(amount), tracing.BalanceChangeUnspecified)
	log.Trace("mint direct inflation reward", "block hash", header.Hash(), "amount", amount)
	if err := p.distributeInflationToValidator(amount, val, state, header, chain, txs, receipts, receivedTxs, usedGas, mining, tracer); err != nil {
		state.RevertToSnapshot(snapshot)
		return err
	}
	return nil
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

func (p *Parlia) loadStakeHubInflationState(
	state vm.StateDB,
	header *types.Header,
	chain core.ChainContext,
) (*stakeHubInflationState, error) {
	enabled, err := p.callStakeHubBool(state, header, chain, "inflationEnabled()")
	if err != nil {
		return nil, err
	}
	if !enabled {
		return &stakeHubInflationState{enabled: false, expectedMintAmount: new(big.Int)}, nil
	}

	interval, err := p.callStakeHubUint64(state, header, chain, "BREATHE_BLOCK_INTERVAL()")
	if err != nil {
		return nil, err
	}
	if interval == 0 {
		return nil, errors.New("stake hub BREATHE_BLOCK_INTERVAL is zero")
	}

	dayIndex := header.Time / interval
	mintedByDay, err := p.callStakeHubUint256WithUint64(state, header, chain, "inflationMintedByDay(uint256)", dayIndex)
	if err != nil {
		return nil, err
	}
	if mintedByDay.Sign() > 0 {
		return &stakeHubInflationState{
			enabled:            true,
			dayIndex:           dayIndex,
			expectedMintAmount: new(big.Int),
			mintedByDay:        mintedByDay,
		}, nil
	}

	expectedMintAmount, err := p.callStakeHubUint256WithUint64(
		state,
		header,
		chain,
		"expectedInflationMintAmount(uint256)",
		dayIndex,
	)
	if err != nil {
		return nil, err
	}
	return &stakeHubInflationState{
		enabled:            true,
		dayIndex:           dayIndex,
		expectedMintAmount: expectedMintAmount,
		mintedByDay:        mintedByDay,
	}, nil
}

func (p *Parlia) callStakeHubBool(
	state vm.StateDB,
	header *types.Header,
	chain core.ChainContext,
	methodSig string,
) (bool, error) {
	result, err := p.callStakeHub(state, header, chain, selectorCallData(methodSig))
	if err != nil {
		return false, err
	}
	if len(result) == 0 {
		return false, nil
	}
	return result[len(result)-1] == 1, nil
}

func (p *Parlia) callStakeHubUint64(
	state vm.StateDB,
	header *types.Header,
	chain core.ChainContext,
	methodSig string,
) (uint64, error) {
	value, err := p.callStakeHubUint256(state, header, chain, methodSig)
	if err != nil {
		return 0, err
	}
	return value.Uint64(), nil
}

func (p *Parlia) callStakeHubUint256(
	state vm.StateDB,
	header *types.Header,
	chain core.ChainContext,
	methodSig string,
) (*big.Int, error) {
	result, err := p.callStakeHub(state, header, chain, selectorCallData(methodSig))
	if err != nil {
		return nil, err
	}
	if len(result) == 0 {
		return new(big.Int), nil
	}
	return new(big.Int).SetBytes(result), nil
}

func (p *Parlia) callStakeHubUint256WithUint64(
	state vm.StateDB,
	header *types.Header,
	chain core.ChainContext,
	methodSig string,
	arg uint64,
) (*big.Int, error) {
	result, err := p.callStakeHub(state, header, chain, encodeSingleUint64Call(methodSig, arg))
	if err != nil {
		return nil, err
	}
	if len(result) == 0 {
		return new(big.Int), nil
	}
	return new(big.Int).SetBytes(result), nil
}

func (p *Parlia) callStakeHub(
	state vm.StateDB,
	header *types.Header,
	chain core.ChainContext,
	data []byte,
) ([]byte, error) {
	toAddress := common.HexToAddress(systemcontracts.StakeHubContract)
	evm := vm.NewEVM(core.NewEVMBlockContext(header, chain, nil), state, p.chainConfig, vm.Config{})
	snapshot := state.Snapshot()
	result, _, err := evm.StaticCall(consensus.SystemAddress, toAddress, data, math.MaxUint64/2)
	state.RevertToSnapshot(snapshot)
	return result, err
}

func mintableInflationReward(cfg *stakeHubInflationState) *big.Int {
	if cfg == nil || !cfg.enabled || cfg.expectedMintAmount == nil {
		return new(big.Int)
	}
	if cfg.mintedByDay != nil && cfg.mintedByDay.Sign() > 0 {
		return new(big.Int)
	}
	return new(big.Int).Set(cfg.expectedMintAmount)
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

func encodeSingleUint64Call(methodSig string, value uint64) []byte {
	data := make([]byte, 4+32)
	copy(data[:4], selectorCallData(methodSig))
	binary.BigEndian.PutUint64(data[4+24:], value)
	return data
}
