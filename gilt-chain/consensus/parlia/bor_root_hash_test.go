package parlia

import (
	"math/big"
	"testing"

	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/consensus"
	"github.com/ethereum/go-ethereum/core/types"
	"github.com/ethereum/go-ethereum/params"
)

type rootHashTestChain struct {
	headersByNumber map[uint64]*types.Header
	headersByHash   map[common.Hash]*types.Header
	head            *types.Header
}

func newRootHashTestChain(count int) *rootHashTestChain {
	headersByNumber := make(map[uint64]*types.Header, count)
	headersByHash := make(map[common.Hash]*types.Header, count)

	var parentHash common.Hash
	var head *types.Header
	for i := 0; i < count; i++ {
		header := &types.Header{
			ParentHash:  parentHash,
			Number:      big.NewInt(int64(i)),
			Time:        uint64(100 + i),
			TxHash:      common.BytesToHash([]byte{byte(i + 1), 0x11}),
			ReceiptHash: common.BytesToHash([]byte{byte(i + 1), 0x22}),
		}
		parentHash = header.Hash()
		headersByNumber[uint64(i)] = header
		headersByHash[header.Hash()] = header
		head = header
	}

	return &rootHashTestChain{
		headersByNumber: headersByNumber,
		headersByHash:   headersByHash,
		head:            head,
	}
}

func (c *rootHashTestChain) Config() *params.ChainConfig  { return params.ParliaTestChainConfig }
func (c *rootHashTestChain) CurrentHeader() *types.Header { return c.head }
func (c *rootHashTestChain) GetHeader(hash common.Hash, number uint64) *types.Header {
	header := c.headersByNumber[number]
	if header == nil || header.Hash() != hash {
		return nil
	}
	return header
}
func (c *rootHashTestChain) GetHeaderByNumber(number uint64) *types.Header {
	return c.headersByNumber[number]
}
func (c *rootHashTestChain) GetHeaderByHash(hash common.Hash) *types.Header {
	return c.headersByHash[hash]
}
func (c *rootHashTestChain) GenesisHeader() *types.Header { return c.headersByNumber[0] }
func (c *rootHashTestChain) GetTd(hash common.Hash, number uint64) *big.Int {
	return big.NewInt(int64(number + 1))
}
func (c *rootHashTestChain) GetHighestVerifiedHeader() *types.Header { return c.head }
func (c *rootHashTestChain) GetVerifiedBlockByHash(hash common.Hash) *types.Header {
	return c.headersByHash[hash]
}
func (c *rootHashTestChain) ChasingHead() *types.Header { return c.head }

var _ consensus.ChainHeaderReader = (*rootHashTestChain)(nil)

func TestGetRootHashStableForRepeatedCall(t *testing.T) {
	chain := newRootHashTestChain(4)
	api := &API{chain: chain}

	root1, err := api.GetRootHash(0, 3)
	if err != nil {
		t.Fatalf("first GetRootHash failed: %v", err)
	}
	if root1 == "" {
		t.Fatal("expected non-empty root hash")
	}

	root2, err := api.GetRootHash(0, 3)
	if err != nil {
		t.Fatalf("second GetRootHash failed: %v", err)
	}
	if root1 != root2 {
		t.Fatalf("expected stable root hash, got %s then %s", root1, root2)
	}
}

func TestGetRootHashStartGreaterThanEnd(t *testing.T) {
	chain := newRootHashTestChain(4)
	api := &API{chain: chain}

	if _, err := api.GetRootHash(3, 1); err == nil {
		t.Fatal("expected error for start greater than end")
	}
}

func TestGetRootHashEndBeyondHead(t *testing.T) {
	chain := newRootHashTestChain(4)
	api := &API{chain: chain}

	if _, err := api.GetRootHash(0, 9); err == nil {
		t.Fatal("expected error for end beyond head")
	}
}

func TestGetRootHashRejectsBrokenHeaderRange(t *testing.T) {
	chain := newRootHashTestChain(4)
	chain.headersByNumber[2] = &types.Header{
		ParentHash:  common.HexToHash("0x1234"),
		Number:      big.NewInt(2),
		Time:        uint64(102),
		TxHash:      common.BytesToHash([]byte{0x03, 0x11}),
		ReceiptHash: common.BytesToHash([]byte{0x03, 0x22}),
	}
	api := &API{chain: chain}

	if _, err := api.GetRootHash(0, 3); err == nil {
		t.Fatal("expected error for non-contiguous header range")
	}
}
