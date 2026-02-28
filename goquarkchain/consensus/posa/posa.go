package posa

import (
	"errors"
	"math/big"

	"github.com/QuarkChain/goquarkchain/account"
	"github.com/QuarkChain/goquarkchain/cluster/config"
	"github.com/QuarkChain/goquarkchain/consensus"
	"github.com/QuarkChain/goquarkchain/core/state"
	"github.com/QuarkChain/goquarkchain/core/types"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/crypto"
)

// Engine is a minimal validator-consensus scaffold.
// It avoids PoW verification paths and validates basic header/linking rules.
// Full proposer/vote/finality logic will be added in follow-up steps.
type Engine struct {
	guardianPublicKey []byte
	targetBlockTime   uint64
}

func New(targetBlockTime uint64, guardianPublicKey []byte) *Engine {
	return &Engine{
		guardianPublicKey: guardianPublicKey,
		targetBlockTime:   targetBlockTime,
	}
}

func (e *Engine) Author(header types.IHeader) (account.Address, error) {
	return header.GetCoinbase(), nil
}

func (e *Engine) VerifyHeader(chain consensus.ChainReader, header types.IHeader, seal bool) error {
	parent := chain.GetBlock(header.GetParentHash())
	if parent == nil {
		return consensus.ErrUnknownAncestor
	}
	if parent.NumberU64()+1 != header.NumberU64() {
		return consensus.ErrInvalidNumber
	}
	if header.GetTime() <= parent.Time() {
		return errors.New("incorrect create time")
	}
	if seal {
		return e.VerifySeal(chain, header, nil)
	}
	return nil
}

func (e *Engine) VerifyHeaders(chain consensus.ChainReader, headers []types.IHeader, seals []bool) (chan<- struct{}, <-chan error) {
	abort := make(chan struct{})
	out := make(chan error, len(headers))
	go func() {
		for i, h := range headers {
			seal := true
			if len(seals) > i {
				seal = seals[i]
			}
			out <- e.VerifyHeader(chain, h, seal)
		}
	}()
	return abort, out
}

func (e *Engine) VerifySeal(_ consensus.ChainReader, header types.IHeader, _ *big.Int) error {
	rootHeader, ok := header.(*types.RootBlockHeader)
	if !ok {
		// Minor headers currently do not carry consensus signatures.
		// Full committee attestation checks are added in follow-up steps.
		return nil
	}
	// If guardian key is configured and a signature is present, verify it.
	if len(e.guardianPublicKey) > 0 {
		zeroSig := [65]byte{}
		if rootHeader.Signature != zeroSig {
			if !crypto.VerifySignature(e.guardianPublicKey, rootHeader.SealHash().Bytes(), rootHeader.Signature[:64]) {
				return errors.New("invalid root block signature")
			}
		}
	}
	return nil
}

func (e *Engine) Prepare(chain consensus.ChainReader, header types.IHeader) error {
	parent := chain.GetBlock(header.GetParentHash())
	if parent == nil {
		return consensus.ErrUnknownAncestor
	}
	diff, err := e.CalcDifficulty(chain, header.GetTime(), parent)
	if err != nil {
		return err
	}
	header.SetDifficulty(diff)
	return nil
}

func (e *Engine) Finalize(_ consensus.ChainReader, header types.IHeader, state *state.StateDB, txs []*types.Transaction, receipts []*types.Receipt) (types.IBlock, error) {
	// Keep block assembly unchanged at this stage. Returning nil is acceptable here
	// because QuarkChain state processors don't use Engine.Finalize for block creation.
	_ = header
	_ = state
	_ = txs
	_ = receipts
	return nil, nil
}

func (e *Engine) Seal(_ consensus.ChainReader, block types.IBlock, _ *big.Int, _ uint64, results chan<- types.IBlock, stop <-chan struct{}) error {
	go func() {
		select {
		case <-stop:
			return
		default:
			results <- block.WithMingResult(0, common.Hash{}, nil)
		}
	}()
	return nil
}

func (e *Engine) CalcDifficulty(_ consensus.ChainReader, _ uint64, parent types.IBlock) (*big.Int, error) {
	// Keep a stable non-zero difficulty for compatibility with existing fields.
	diff := parent.Difficulty()
	if diff == nil || diff.Sign() <= 0 {
		return big.NewInt(1), nil
	}
	return diff, nil
}

func (e *Engine) GetWork(_ account.Address) (*consensus.MiningWork, error) {
	return nil, consensus.ErrNotRemote
}

func (e *Engine) SubmitWork(_ uint64, _ common.Hash, _ common.Hash, _ *[65]byte) bool {
	return false
}

func (e *Engine) SetThreads(_ int) {}

func (e *Engine) RefreshWork(_ uint64) {}

func (e *Engine) Close() error { return nil }

func (e *Engine) Name() string { return config.PoSA }
