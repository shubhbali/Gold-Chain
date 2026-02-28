package qkcapi

import (
	"encoding/binary"
	"errors"
	"fmt"
	"math/big"
	"sort"
	"strings"
	"sync"

	"github.com/QuarkChain/goquarkchain/account"
	qCommon "github.com/QuarkChain/goquarkchain/common"
	"github.com/QuarkChain/goquarkchain/common/hexutil"
	"github.com/QuarkChain/goquarkchain/core/types"
	qrpc "github.com/QuarkChain/goquarkchain/rpc"
	"github.com/ethereum/go-ethereum/common"
	ethTypes "github.com/ethereum/go-ethereum/core/types"
	"github.com/ethereum/go-ethereum/rlp"
	"github.com/ybbus/jsonrpc"
)

// ShardInfo contains the configuration for a single shard
type ShardInfo struct {
	FullShardID uint32
	ChainID     uint32
}

// UnifiedShardAPI provides a single RPC endpoint that routes requests
// to the appropriate shard based on the address involved.
// This enables MetaMask compatibility with standard 20-byte addresses.
type UnifiedShardAPI struct {
	// shardSize is the number of shards (must be power of 2)
	shardSize uint32

	// chainID is the EVM chain ID for signing
	chainID uint32

	// shards maps shardID -> ShardInfo
	shards map[uint32]ShardInfo
	// qkcChainID is the QuarkChain chain id encoded in full-shard keys
	qkcChainID uint32

	// client is the RPC client to the QuarkChain cluster
	client jsonrpc.RPCClient

	// hashMap stores eth tx hash -> qkc tx hash mapping
	// Protected by mutex for concurrent access
	hashMapMu sync.RWMutex
	hashMap   map[common.Hash]txHashInfo

	// logFilters stores eth_newFilter state for polling APIs.
	logFiltersMu sync.RWMutex
	logFilters   map[uint64]*unifiedLogFilter
	nextFilterID uint64
}

// txHashInfo stores the QuarkChain hash and the shard where tx was sent
type txHashInfo struct {
	qkcHash     common.Hash
	fullShardID uint32
}

type unifiedLogFilter struct {
	query       qrpc.FilterQuery
	lastHeights map[uint32]uint64
}

// NewUnifiedShardAPI creates a UnifiedShardAPI that routes to multiple shards.
//
// Parameters:
//   - shardSize: number of shards (must be power of 2: 1, 2, 4, 8, etc.)
//   - chainID: EVM chain ID for transaction signing
//   - shards: slice of ShardInfo for each shard
//   - client: RPC client to QuarkChain cluster
func NewUnifiedShardAPI(shardSize uint32, chainID uint32, shards []ShardInfo, client jsonrpc.RPCClient) (*UnifiedShardAPI, error) {
	// Validate shardSize is power of 2
	if shardSize == 0 || (shardSize&(shardSize-1)) != 0 {
		return nil, fmt.Errorf("shardSize must be power of 2, got %d", shardSize)
	}

	// Validate we have the right number of shards
	if uint32(len(shards)) != shardSize {
		return nil, fmt.Errorf("expected %d shards, got %d", shardSize, len(shards))
	}

	// Build shard map
	shardMap := make(map[uint32]ShardInfo)
	for _, s := range shards {
		shardID := s.FullShardID & (shardSize - 1)
		if _, exists := shardMap[shardID]; exists {
			return nil, fmt.Errorf("duplicate shard ID %d", shardID)
		}
		shardMap[shardID] = s
	}

	// Verify all shard IDs from 0 to shardSize-1 are present
	for i := uint32(0); i < shardSize; i++ {
		if _, exists := shardMap[i]; !exists {
			return nil, fmt.Errorf("missing shard ID %d", i)
		}
	}

	qkcChainID := shards[0].FullShardID >> 16

	return &UnifiedShardAPI{
		shardSize:    shardSize,
		chainID:      chainID,
		shards:       shardMap,
		qkcChainID:   qkcChainID,
		client:       client,
		hashMap:      make(map[common.Hash]txHashInfo),
		logFilters:   make(map[uint64]*unifiedLogFilter),
		nextFilterID: 1,
	}, nil
}

// deriveShardID derives the shard ID from the canonical default full-shard-key seed.
func (u *UnifiedShardAPI) deriveShardID(addr common.Address) uint32 {
	return u.deriveDefaultShardSeed(addr) & (u.shardSize - 1)
}

// deriveFullShardKey derives a canonical full-shard key from a 20-byte address.
// This mirrors account.Identity.GetDefaultFullShardKey semantics for consistency.
func (u *UnifiedShardAPI) deriveFullShardKey(addr common.Address) uint32 {
	return (u.qkcChainID << 16) | u.deriveDefaultShardSeed(addr)
}

// getFullShardIDForAddress returns the full shard ID for routing an address
func (u *UnifiedShardAPI) getFullShardIDForAddress(addr common.Address) uint32 {
	shardID := u.deriveShardID(addr)
	return u.shards[shardID].FullShardID
}

// deriveDefaultShardSeed uses the same two address bytes as Identity.GetDefaultFullShardKey.
func (u *UnifiedShardAPI) deriveDefaultShardSeed(addr common.Address) uint32 {
	return (uint32(addr[0]) << 8) | uint32(addr[10])
}

func (u *UnifiedShardAPI) keyWithShard(baseFullShardKey uint32, shardID uint32) uint32 {
	return (baseFullShardKey & ^(u.shardSize - 1)) | shardID
}

func (u *UnifiedShardAPI) addressInShard(addr common.Address, shardID uint32) account.Address {
	base := u.deriveFullShardKey(addr)
	return account.NewAddress(addr, u.keyWithShard(base, shardID))
}

func (u *UnifiedShardAPI) shardOrder(primary uint32) []uint32 {
	order := make([]uint32, 0, u.shardSize)
	order = append(order, primary)
	for i := uint32(0); i < u.shardSize; i++ {
		if i != primary {
			order = append(order, i)
		}
	}
	return order
}

// ChainId returns the EVM chain ID
func (u *UnifiedShardAPI) ChainId() hexutil.Uint64 {
	return hexutil.Uint64(u.chainID)
}

// GasPrice returns the gas price from shard 0 (gas price should be network-wide)
func (u *UnifiedShardAPI) GasPrice() (*hexutil.Big, error) {
	// Use shard 0 for gas price - it should be consistent across shards
	fullShardID := u.shards[0].FullShardID
	resp, err := u.client.Call("gasPrice", hexutil.EncodeUint64(uint64(fullShardID)))
	if err != nil {
		return nil, err
	}
	gasPriceStr, ok := resp.Result.(string)
	if !ok {
		return nil, errors.New("invalid gas price response")
	}
	gasPrice, err := hexutil.DecodeBig(gasPriceStr)
	if err != nil {
		return nil, err
	}
	if gasPrice.Cmp(new(big.Int).SetUint64(0)) == 0 {
		gasPrice = new(big.Int).SetUint64(1)
	}
	return (*hexutil.Big)(gasPrice), nil
}

func extractDefaultTokenBalance(result interface{}) (*big.Int, bool) {
	obj, ok := result.(map[string]interface{})
	if !ok {
		return nil, false
	}
	balances, ok := obj["balances"].([]interface{})
	if !ok {
		return big.NewInt(0), true
	}
	for _, b := range balances {
		bInfo, ok := b.(map[string]interface{})
		if !ok {
			continue
		}
		tokenStr, _ := bInfo["tokenStr"].(string)
		if strings.ToUpper(tokenStr) != "QKC" && tokenStr != DefaultTokenID {
			continue
		}
		balStr, ok := bInfo["balance"].(string)
		if !ok {
			continue
		}
		val, err := hexutil.DecodeBig(balStr)
		if err != nil {
			continue
		}
		return val, true
	}
	return big.NewInt(0), true
}

// GetBalance returns the balance for an address.
// It probes the derived shard first and falls back to others for robustness.
func (u *UnifiedShardAPI) GetBalance(address common.Address, blockNrOrHash string) (*hexutil.Big, error) {
	primary := u.deriveShardID(address)
	order := u.shardOrder(primary)
	best := big.NewInt(0)
	var lastErr error
	success := false

	for _, shardID := range order {
		qkcAddr := u.addressInShard(address, shardID)
		resp, err := u.client.Call("getBalances", qkcAddr.ToHex(), blockNrOrHash)
		if err != nil {
			lastErr = err
			continue
		}
		balance, ok := extractDefaultTokenBalance(resp.Result)
		if !ok {
			continue
		}
		success = true
		if balance.Cmp(best) > 0 {
			best = balance
		}
		if shardID == primary && best.Sign() > 0 {
			break
		}
	}

	if !success && lastErr != nil {
		return nil, lastErr
	}
	return (*hexutil.Big)(best), nil
}

// BlockNumber returns the latest block number.
// Since shards can have different heights, we return the minimum to be safe.
// For a unified view, clients should not rely on block numbers across shards.
func (u *UnifiedShardAPI) BlockNumber() (hexutil.Uint64, error) {
	// Return block number from shard 0 - this is a simplification
	// In a true unified API, you might want to aggregate or pick a specific shard
	fullShardID := u.shards[0].FullShardID
	resp, err := u.client.Call("getMinorBlockByHeight", hexutil.EncodeUint64(uint64(fullShardID)))
	if err != nil {
		return 0, err
	}
	result, ok := resp.Result.(map[string]interface{})
	if !ok {
		return 0, errors.New("invalid response")
	}
	heightStr, ok := result["height"].(string)
	if !ok {
		return 0, errors.New("missing height")
	}
	height, err := hexutil.DecodeUint64(heightStr)
	return hexutil.Uint64(height), err
}

// GetBlockByNumber returns a block by number from shard 0
func (u *UnifiedShardAPI) GetBlockByNumber(blockNr string, fullTx bool) (map[string]interface{}, error) {
	fullShardID := u.shards[0].FullShardID
	var resp *jsonrpc.RPCResponse
	var err error

	if blockNr == "latest" {
		resp, err = u.client.Call("getMinorBlockByHeight", hexutil.EncodeUint64(uint64(fullShardID)), nil, fullTx)
	} else {
		resp, err = u.client.Call("getMinorBlockByHeight", hexutil.EncodeUint64(uint64(fullShardID)), blockNr, fullTx)
	}
	if err != nil {
		return nil, err
	}

	block, ok := resp.Result.(map[string]interface{})
	if !ok {
		return nil, errors.New("GetBlockByNumber failed")
	}
	return reWriteBlockResult(block), nil
}

func (u *UnifiedShardAPI) getNonceForAddressOnShard(address common.Address, shardID uint32, blockNr string) (uint64, error) {
	qkcAddr := u.addressInShard(address, shardID)
	var (
		resp *jsonrpc.RPCResponse
		err  error
	)
	if blockNr == "pending" {
		resp, err = u.client.Call("getTransactionCount", qkcAddr.ToHex(), nil)
	} else {
		resp, err = u.client.Call("getTransactionCount", qkcAddr.ToHex(), blockNr)
	}
	if err != nil {
		return 0, err
	}
	nonceStr, ok := resp.Result.(string)
	if !ok {
		return 0, errors.New("invalid nonce response")
	}
	return hexutil.DecodeUint64(nonceStr)
}

// GetTransactionCount returns the nonce for an address.
// It returns the max nonce across shards to avoid user-visible shard misses.
func (u *UnifiedShardAPI) GetTransactionCount(address common.Address, blockNr string) (hexutil.Uint64, error) {
	primary := u.deriveShardID(address)
	order := u.shardOrder(primary)
	var (
		maxNonce uint64
		haveOne  bool
		lastErr  error
	)
	for _, shardID := range order {
		nonce, err := u.getNonceForAddressOnShard(address, shardID, blockNr)
		if err != nil {
			lastErr = err
			continue
		}
		haveOne = true
		if nonce > maxNonce {
			maxNonce = nonce
		}
	}
	if !haveOne && lastErr != nil {
		return 0, lastErr
	}
	return hexutil.Uint64(maxNonce), nil
}

func (u *UnifiedShardAPI) getCodeForAddressOnShard(address common.Address, shardID uint32, blockNr string) (hexutil.Bytes, error) {
	qkcAddr := u.addressInShard(address, shardID)
	var resp *jsonrpc.RPCResponse
	var err error
	if blockNr == "pending" {
		resp, err = u.client.Call("getCode", qkcAddr.ToHex(), nil)
	} else {
		resp, err = u.client.Call("getCode", qkcAddr.ToHex(), blockNr)
	}
	if err != nil {
		return nil, err
	}

	codeStr, ok := resp.Result.(string)
	if !ok {
		return nil, errors.New("invalid code response")
	}
	return hexutil.Decode(codeStr)
}

// GetCode returns the code at an address.
// It probes the derived shard first and falls back to all shards until code is found.
func (u *UnifiedShardAPI) GetCode(address common.Address, blockNr string) (hexutil.Bytes, error) {
	primary := u.deriveShardID(address)
	order := u.shardOrder(primary)
	var lastErr error
	for _, shardID := range order {
		code, err := u.getCodeForAddressOnShard(address, shardID, blockNr)
		if err != nil {
			lastErr = err
			continue
		}
		if len(code) > 0 {
			return code, nil
		}
	}
	if lastErr != nil {
		return nil, lastErr
	}
	return hexutil.Bytes{}, nil
}

// GetBlockByHash returns a block by hash.
// We need to try all shards since we don't know which shard the block is in.
func (u *UnifiedShardAPI) GetBlockByHash(hash common.Hash, fullTx bool) (map[string]interface{}, error) {
	// Try each shard until we find the block
	for shardID := uint32(0); shardID < u.shardSize; shardID++ {
		fullShardID := u.shards[shardID].FullShardID
		// Copy hash bytes to avoid corrupting the original hash's underlying array
		hashBytes := make([]byte, len(hash.Bytes()))
		copy(hashBytes, hash.Bytes())
		blockID := append(hashBytes, qCommon.Uint32ToBytes(fullShardID)...)

		resp, err := u.client.Call("getMinorBlockById", common.ToHex(blockID), fullTx)
		if err != nil {
			continue
		}
		if resp.Result == nil {
			continue
		}

		block, ok := resp.Result.(map[string]interface{})
		if !ok || block == nil {
			continue
		}

		return reWriteBlockResult(block), nil
	}

	return nil, errors.New("block not found")
}

// SendRawTransaction sends a raw transaction, routing based on sender address
func (u *UnifiedShardAPI) SendRawTransaction(encodedTx hexutil.Bytes) (common.Hash, error) {
	// Decode the Ethereum transaction
	tx := new(ethTypes.Transaction)
	if err := rlp.DecodeBytes(encodedTx, tx); err != nil {
		return common.Hash{}, fmt.Errorf("failed to decode transaction: %v", err)
	}

	// Recover sender address from signature
	signer := ethTypes.NewEIP155Signer(big.NewInt(int64(u.chainID)))
	sender, err := ethTypes.Sender(signer, tx)
	if err != nil {
		// Try legacy signer
		signer := ethTypes.HomesteadSigner{}
		sender, err = ethTypes.Sender(signer, tx)
		if err != nil {
			return common.Hash{}, fmt.Errorf("failed to recover sender: %v", err)
		}
	}

	// Derive shard from sender address
	fromFullShardKey := u.deriveFullShardKey(sender)
	fromFullShardID := u.getFullShardIDForAddress(sender)

	// Derive shard for recipient (or same as sender for contract creation)
	var toFullShardKey uint32
	if tx.To() != nil {
		toFullShardKey = u.deriveFullShardKey(*tx.To())
	} else {
		// Contract creation - deploy to sender's shard
		toFullShardKey = fromFullShardKey
	}

	// Create QuarkChain transaction
	var evmTx *types.EvmTransaction
	if tx.To() != nil {
		evmTx = types.NewEvmTransaction(
			tx.Nonce(),
			*tx.To(),
			tx.Value(),
			tx.Gas(),
			tx.GasPrice(),
			fromFullShardKey,
			toFullShardKey,
			u.chainID,
			2, // version
			tx.Data(),
			35760, // default gas token
			35760, // default transfer token
		)
	} else {
		evmTx = types.NewEvmContractCreation(
			tx.Nonce(),
			tx.Value(),
			tx.Gas(),
			tx.GasPrice(),
			fromFullShardKey,
			toFullShardKey,
			u.chainID,
			2, // version
			tx.Data(),
			35760, // default gas token
			35760, // default transfer token
		)
	}

	// Copy signature
	evmTx.SetVRS(tx.RawSignatureValues())

	// Encode and send
	rlpTxBytes, err := rlp.EncodeToBytes(evmTx)
	if err != nil {
		return common.Hash{}, fmt.Errorf("failed to encode transaction: %v", err)
	}

	_, err = u.client.Call("sendRawTransaction", common.ToHex(rlpTxBytes))
	if err != nil {
		return common.Hash{}, err
	}

	// Build QuarkChain transaction for hash
	txQkc := &types.Transaction{
		TxType: types.EvmTx,
		EvmTx:  evmTx,
	}

	// Store mapping from eth hash to qkc hash + shard
	qkcHash := txQkc.Hash()
	u.hashMapMu.Lock()
	u.hashMap[tx.Hash()] = txHashInfo{
		qkcHash:     qkcHash,
		fullShardID: fromFullShardID,
	}
	// Store canonical self-mapping so lookups stay fast when clients use returned hash.
	u.hashMap[qkcHash] = txHashInfo{
		qkcHash:     qkcHash,
		fullShardID: fromFullShardID,
	}
	u.hashMapMu.Unlock()

	return qkcHash, nil
}

// getTxIDWithShard builds the transaction ID with shard suffix
func getTxIDWithShard(hash common.Hash, fullShardID uint32) []byte {
	fullShardIDBytes := make([]byte, 4)
	binary.BigEndian.PutUint32(fullShardIDBytes, fullShardID)

	txID := make([]byte, 0, 36)
	txID = append(txID, hash.Bytes()...)
	txID = append(txID, fullShardIDBytes...)
	return txID
}

// GetTransactionByHash returns transaction details by hash
func (u *UnifiedShardAPI) GetTransactionByHash(ethHash common.Hash) (map[string]interface{}, error) {
	// Check if we have a mapping for this hash
	u.hashMapMu.RLock()
	info, ok := u.hashMap[ethHash]
	u.hashMapMu.RUnlock()

	if ok {
		// We know the exact shard
		txID := getTxIDWithShard(info.qkcHash, info.fullShardID)
		return u.getTransactionByID(txID)
	}

	// We don't have a mapping - try all shards
	for shardID := uint32(0); shardID < u.shardSize; shardID++ {
		fullShardID := u.shards[shardID].FullShardID
		txID := getTxIDWithShard(ethHash, fullShardID)

		result, err := u.getTransactionByID(txID)
		if err == nil && result != nil {
			return result, nil
		}
	}

	return nil, nil // Transaction not found
}

func (u *UnifiedShardAPI) getTransactionByID(txID []byte) (map[string]interface{}, error) {
	resp, err := u.client.Call("getTransactionById", common.ToHex(txID))
	if err != nil {
		return nil, err
	}
	if resp.Result == nil {
		return nil, nil
	}

	ans, ok := resp.Result.(map[string]interface{})
	if !ok {
		return nil, nil
	}

	// Truncate addresses to 20 bytes (remove shard suffix)
	if ans["from"] != nil {
		fromStr, ok := ans["from"].(string)
		if ok && len(fromStr) > 42 {
			ans["from"] = fromStr[:42]
		}
	}
	if ans["to"] != nil {
		toStr, ok := ans["to"].(string)
		if ok {
			if len(toStr) > 42 {
				ans["to"] = toStr[:42]
			} else if len(toStr) <= 2 {
				delete(ans, "to")
			}
		}
	}
	if ans["data"] != nil {
		ans["input"] = ans["data"]
	}
	if ans["blockId"] != nil {
		blockIdStr, ok := ans["blockId"].(string)
		if ok && len(blockIdStr) > 66 {
			ans["blockHash"] = blockIdStr[:66]
		}
	}
	if ans["blockHeight"] != nil {
		ans["blockNumber"] = ans["blockHeight"]
	}

	return ans, nil
}

// GetTransactionReceipt returns the receipt for a transaction
func (u *UnifiedShardAPI) GetTransactionReceipt(ethHash common.Hash) (map[string]interface{}, error) {
	// Check if we have a mapping for this hash
	u.hashMapMu.RLock()
	info, ok := u.hashMap[ethHash]
	u.hashMapMu.RUnlock()

	if ok {
		// We know the exact shard
		txID := getTxIDWithShard(info.qkcHash, info.fullShardID)
		return u.getTransactionReceipt(txID)
	}

	// We don't have a mapping - try all shards
	for shardID := uint32(0); shardID < u.shardSize; shardID++ {
		fullShardID := u.shards[shardID].FullShardID
		txID := getTxIDWithShard(ethHash, fullShardID)

		result, err := u.getTransactionReceipt(txID)
		if err == nil && result != nil {
			return result, nil
		}
	}

	return nil, nil // Receipt not found
}

func (u *UnifiedShardAPI) getTransactionReceipt(txID []byte) (map[string]interface{}, error) {
	resp, err := u.client.Call("getTransactionReceipt", common.ToHex(txID))
	if err != nil {
		return nil, err
	}
	if resp.Result == nil {
		return nil, nil
	}

	ans, ok := resp.Result.(map[string]interface{})
	if !ok {
		return nil, nil
	}

	// Truncate contract address to 20 bytes
	if ans["contractAddress"] != nil {
		addrStr, ok := ans["contractAddress"].(string)
		if ok && len(addrStr) > 42 {
			ans["contractAddress"] = addrStr[:42]
		}
	}
	if ans["logsBloom"] == nil {
		ans["logsBloom"] = common.ToHex(make([]byte, types.BloomByteLength))
	}

	return ans, nil
}

func (u *UnifiedShardAPI) allShardCandidates(hasAddress bool, addr *common.Address) []uint32 {
	if !hasAddress || addr == nil {
		return nil
	}
	primary := u.deriveShardID(*addr)
	return u.shardOrder(primary)
}

func (u *UnifiedShardAPI) callCandidates(mdata MetaCallArgs) [][2]*uint32 {
	var fromAddr, toAddr *common.Address
	if mdata.From != nil {
		a := common.Address(*mdata.From)
		fromAddr = &a
	}
	if mdata.To != nil {
		a := common.Address(*mdata.To)
		toAddr = &a
	}
	fromCandidates := u.allShardCandidates(fromAddr != nil, fromAddr)
	toCandidates := u.allShardCandidates(toAddr != nil, toAddr)
	if len(fromCandidates) == 0 {
		fromCandidates = []uint32{0}
	}
	if len(toCandidates) == 0 {
		toCandidates = []uint32{0}
	}

	type key struct {
		from uint32
		to   uint32
	}
	seen := make(map[key]struct{})
	out := make([][2]*uint32, 0, u.shardSize*u.shardSize)
	for _, f := range fromCandidates {
		for _, t := range toCandidates {
			k := key{from: f, to: t}
			if _, ok := seen[k]; ok {
				continue
			}
			seen[k] = struct{}{}
			fv := f
			tv := t
			var fp, tp *uint32
			if mdata.From != nil {
				fp = &fv
			}
			if mdata.To != nil {
				tp = &tv
			}
			out = append(out, [2]*uint32{fp, tp})
		}
	}
	return out
}

// Call executes a call. It retries shard hints so callers never need to provide shard IDs.
func (u *UnifiedShardAPI) Call(mdata MetaCallArgs, blockNr string) (hexutil.Bytes, error) {
	candidates := u.callCandidates(mdata)
	var lastErr error
	for _, c := range candidates {
		arg := u.buildCallArg(mdata, c[0], c[1])
		resp, err := u.client.Call("call", arg, blockNr)
		if err != nil {
			lastErr = err
			continue
		}
		resultStr, ok := resp.Result.(string)
		if !ok {
			lastErr = errors.New("call failed")
			continue
		}
		decoded, err := hexutil.Decode(resultStr)
		if err != nil {
			lastErr = err
			continue
		}
		return decoded, nil
	}
	if lastErr != nil {
		return nil, lastErr
	}
	return nil, errors.New("call failed")
}

// EstimateGas estimates gas and retries shard hints for cross-shard compatibility.
func (u *UnifiedShardAPI) EstimateGas(mdata MetaCallArgs) (hexutil.Uint, error) {
	candidates := u.callCandidates(mdata)
	var lastErr error
	for _, c := range candidates {
		arg := u.buildCallArg(mdata, c[0], c[1])
		estimates := []map[string]interface{}{arg}
		resp, err := u.client.Call("estimateGas", estimates)
		if err != nil {
			lastErr = err
			continue
		}
		gasStr, ok := resp.Result.(string)
		if !ok {
			lastErr = errors.New("estimateGas failed")
			continue
		}
		gas, err := hexutil.DecodeUint64(gasStr)
		if err != nil {
			lastErr = err
			continue
		}
		return hexutil.Uint(gas), nil
	}
	if lastErr != nil {
		return hexutil.Uint(21000), lastErr
	}
	return hexutil.Uint(21000), errors.New("estimateGas failed")
}

// buildCallArg builds the call argument with optional shard hints.
func (u *UnifiedShardAPI) buildCallArg(mdata MetaCallArgs, fromShardID *uint32, toShardID *uint32) map[string]interface{} {
	defaultToken := hexutil.Uint64(35760)
	arg := make(map[string]interface{})

	if mdata.From != nil {
		fromAddress := common.Address(*mdata.From)
		fromShardKey := u.deriveFullShardKey(fromAddress)
		if fromShardID != nil {
			fromShardKey = u.keyWithShard(fromShardKey, *fromShardID)
		}
		arg["from"] = account.Address{
			Recipient:    *mdata.From,
			FullShardKey: fromShardKey,
		}.ToHex()
	}
	if mdata.To != nil {
		toAddress := common.Address(*mdata.To)
		toShardKey := u.deriveFullShardKey(toAddress)
		if toShardID != nil {
			toShardKey = u.keyWithShard(toShardKey, *toShardID)
		}
		arg["to"] = account.Address{
			Recipient:    *mdata.To,
			FullShardKey: toShardKey,
		}.ToHex()
	}

	arg["gas"] = mdata.Gas
	arg["gasPrice"] = mdata.GasPrice
	arg["value"] = mdata.Value
	arg["data"] = mdata.Data
	arg["gas_token_id"] = &defaultToken
	arg["transfer_token_id"] = &defaultToken

	return arg
}

func cloneFilterQuery(query qrpc.FilterQuery) qrpc.FilterQuery {
	cloned := query
	if query.FromBlock != nil {
		cloned.FromBlock = new(big.Int).Set(query.FromBlock)
	}
	if query.ToBlock != nil {
		cloned.ToBlock = new(big.Int).Set(query.ToBlock)
	}
	if query.BlockHash != nil {
		hash := *query.BlockHash
		cloned.BlockHash = &hash
	}
	if len(query.Addresses) > 0 {
		cloned.Addresses = append([]common.Address(nil), query.Addresses...)
	}
	if len(query.Topics) > 0 {
		cloned.Topics = make([][]common.Hash, len(query.Topics))
		for i := range query.Topics {
			cloned.Topics[i] = append([]common.Hash(nil), query.Topics[i]...)
		}
	}
	return cloned
}

func parseLogList(result interface{}) []map[string]interface{} {
	raw, ok := result.([]interface{})
	if !ok {
		return nil
	}
	logs := make([]map[string]interface{}, 0, len(raw))
	for _, item := range raw {
		entry, ok := item.(map[string]interface{})
		if !ok {
			continue
		}
		if addr, ok := entry["address"].(string); ok && len(addr) > 42 {
			entry["address"] = addr[:42]
		}
		logs = append(logs, entry)
	}
	return logs
}

func hexToUint64(v interface{}) uint64 {
	s, ok := v.(string)
	if !ok {
		return 0
	}
	u, err := hexutil.DecodeUint64(s)
	if err != nil {
		return 0
	}
	return u
}

func sortLogs(logs []map[string]interface{}) {
	sort.Slice(logs, func(i, j int) bool {
		bi := hexToUint64(logs[i]["blockNumber"])
		bj := hexToUint64(logs[j]["blockNumber"])
		if bi != bj {
			return bi < bj
		}
		li := hexToUint64(logs[i]["logIndex"])
		lj := hexToUint64(logs[j]["logIndex"])
		return li < lj
	})
}

func (u *UnifiedShardAPI) getLatestHeight(fullShardID uint32) (uint64, error) {
	resp, err := u.client.Call("getMinorBlockByHeight", hexutil.EncodeUint64(uint64(fullShardID)))
	if err != nil {
		return 0, err
	}
	obj, ok := resp.Result.(map[string]interface{})
	if !ok {
		return 0, errors.New("invalid latest block response")
	}
	heightStr, ok := obj["height"].(string)
	if !ok {
		return 0, errors.New("missing latest block height")
	}
	return hexutil.DecodeUint64(heightStr)
}

func (u *UnifiedShardAPI) getLogsForShard(query qrpc.FilterQuery, shardID uint32) ([]map[string]interface{}, error) {
	fullShardID := u.shards[shardID].FullShardID
	fullShardKey := (fullShardID >> 16) << 16
	fullShardKey |= shardID
	resp, err := u.client.Call("getLogs", query, hexutil.EncodeUint64(uint64(fullShardKey)))
	if err != nil {
		return nil, err
	}
	return parseLogList(resp.Result), nil
}

// GetLogs aggregates logs across all shards so callers never need shard-aware queries.
func (u *UnifiedShardAPI) GetLogs(query qrpc.FilterQuery) ([]map[string]interface{}, error) {
	logs := make([]map[string]interface{}, 0)
	for shardID := uint32(0); shardID < u.shardSize; shardID++ {
		cloned := cloneFilterQuery(query)
		shardLogs, err := u.getLogsForShard(cloned, shardID)
		if err != nil {
			continue
		}
		logs = append(logs, shardLogs...)
	}
	sortLogs(logs)
	return logs, nil
}

// NewFilter creates a cross-shard log filter.
func (u *UnifiedShardAPI) NewFilter(query qrpc.FilterQuery) (hexutil.Uint64, error) {
	lastHeights := make(map[uint32]uint64, u.shardSize)
	for shardID := uint32(0); shardID < u.shardSize; shardID++ {
		height, err := u.getLatestHeight(u.shards[shardID].FullShardID)
		if err != nil {
			lastHeights[shardID] = 0
			continue
		}
		lastHeights[shardID] = height
	}

	u.logFiltersMu.Lock()
	defer u.logFiltersMu.Unlock()
	id := u.nextFilterID
	u.nextFilterID++
	u.logFilters[id] = &unifiedLogFilter{
		query:       cloneFilterQuery(query),
		lastHeights: lastHeights,
	}
	return hexutil.Uint64(id), nil
}

// GetFilterLogs returns all logs matching a filter.
func (u *UnifiedShardAPI) GetFilterLogs(id hexutil.Uint64) ([]map[string]interface{}, error) {
	u.logFiltersMu.RLock()
	filter, ok := u.logFilters[uint64(id)]
	u.logFiltersMu.RUnlock()
	if !ok {
		return []map[string]interface{}{}, nil
	}
	return u.GetLogs(cloneFilterQuery(filter.query))
}

// GetFilterChanges returns incremental logs since the last poll.
func (u *UnifiedShardAPI) GetFilterChanges(id hexutil.Uint64) ([]map[string]interface{}, error) {
	u.logFiltersMu.Lock()
	defer u.logFiltersMu.Unlock()

	filter, ok := u.logFilters[uint64(id)]
	if !ok {
		return []map[string]interface{}{}, nil
	}

	collected := make([]map[string]interface{}, 0)
	for shardID := uint32(0); shardID < u.shardSize; shardID++ {
		cloned := cloneFilterQuery(filter.query)
		if cloned.BlockHash == nil {
			latest, err := u.getLatestHeight(u.shards[shardID].FullShardID)
			if err != nil {
				continue
			}
			start := filter.lastHeights[shardID] + 1
			if latest < start {
				filter.lastHeights[shardID] = latest
				continue
			}
			cloned.FromBlock = new(big.Int).SetUint64(start)
			cloned.ToBlock = new(big.Int).SetUint64(latest)
			filter.lastHeights[shardID] = latest
		}
		shardLogs, err := u.getLogsForShard(cloned, shardID)
		if err != nil {
			continue
		}
		collected = append(collected, shardLogs...)
	}
	sortLogs(collected)
	return collected, nil
}

// UninstallFilter removes a previously created filter.
func (u *UnifiedShardAPI) UninstallFilter(id hexutil.Uint64) bool {
	u.logFiltersMu.Lock()
	defer u.logFiltersMu.Unlock()
	if _, ok := u.logFilters[uint64(id)]; !ok {
		return false
	}
	delete(u.logFilters, uint64(id))
	return true
}
