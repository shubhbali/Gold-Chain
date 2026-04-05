package parlia

import (
	"encoding/hex"
	"fmt"
	"math/big"

	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/core/types"
	"github.com/ethereum/go-ethereum/crypto"
)

const maxBorCheckpointLength uint64 = 1 << 15

var (
	errReorgDuringRootHash      = fmt.Errorf("reorg occurred while computing checkpoint root")
	errNonContiguousHeaderRange = fmt.Errorf("non-contiguous headers in checkpoint range")
)

// GetRootHash returns the Bor-compatible checkpoint root for the inclusive header range.
func (api *API) GetRootHash(start uint64, end uint64) (string, error) {
	head := api.chain.CurrentHeader()
	if head == nil {
		return "", errUnknownBlock
	}

	headNumber := head.Number.Uint64()
	if start > end || end > headNumber {
		return "", fmt.Errorf("invalid start/end block range: start=%d end=%d head=%d", start, end, headNumber)
	}

	length := end - start + 1
	if length > maxBorCheckpointLength {
		return "", fmt.Errorf(
			"checkpoint range exceeds maximum length: start=%d end=%d max=%d",
			start,
			end,
			maxBorCheckpointLength,
		)
	}

	endHeader := api.chain.GetHeaderByNumber(end)
	if endHeader == nil {
		return "", errUnknownBlock
	}
	endHash := endHeader.Hash()

	leaves := make([][32]byte, nextPowerOfTwo(length))
	var prevHash common.Hash

	for number := start; number <= end; number++ {
		header := api.chain.GetHeaderByNumber(number)
		if header == nil {
			return "", errUnknownBlock
		}
		if number > start && header.ParentHash != prevHash {
			return "", errNonContiguousHeaderRange
		}

		prevHash = header.Hash()
		leaves[number-start] = headerLeafHash(header)
	}

	latestEndHeader := api.chain.GetHeaderByNumber(end)
	if latestEndHeader == nil || latestEndHeader.Hash() != endHash {
		return "", errReorgDuringRootHash
	}

	root := checkpointMerkleRoot(leaves)
	return hex.EncodeToString(root[:]), nil
}

func headerLeafHash(header *types.Header) [32]byte {
	hash := crypto.Keccak256(appendPaddedBytes32(
		header.Number.Bytes(),
		new(big.Int).SetUint64(header.Time).Bytes(),
		header.TxHash.Bytes(),
		header.ReceiptHash.Bytes(),
	))
	var out [32]byte
	copy(out[:], hash)
	return out
}

func checkpointMerkleRoot(leaves [][32]byte) [32]byte {
	level := make([][32]byte, len(leaves))
	copy(level, leaves)

	for len(level) > 1 {
		next := make([][32]byte, len(level)/2)
		for i := 0; i < len(level); i += 2 {
			hash := crypto.Keccak256(level[i][:], level[i+1][:])
			copy(next[i/2][:], hash)
		}
		level = next
	}

	return level[0]
}

func appendPaddedBytes32(parts ...[]byte) []byte {
	out := make([]byte, 0, 32*len(parts))
	for _, part := range parts {
		out = append(out, leftPadTo32(part)...)
	}
	return out
}

func leftPadTo32(value []byte) []byte {
	padded := make([]byte, 32)
	if len(value) == 0 || len(value) > 32 {
		return padded
	}
	copy(padded[32-len(value):], value)
	return padded
}

func nextPowerOfTwo(n uint64) uint64 {
	if n == 0 {
		return 1
	}
	n--
	n |= n >> 1
	n |= n >> 2
	n |= n >> 4
	n |= n >> 8
	n |= n >> 16
	n |= n >> 32
	n++
	return n
}
